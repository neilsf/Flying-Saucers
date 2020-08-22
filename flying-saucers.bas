rem -------------------------
rem -- FLYING SAUCERS
rem --
rem -- Written by
rem -- Csaba Fekete
rem --
rem -- Graphics
rem -- Daniel Fekete
rem -------------------------

debug! = 0

rem -- init VIC and I/O, 
rem -- detect NTSC or PAL system
sys $ff81
ntsc_pal! = peek!(678) : rem 0 = NTSC, 1 = PAL

if ntsc_pal! = 0 then
  frameskip1 = 720
  frameskip2 = 636
else
  frameskip1 = 600
  frameskip2 = 530
endif

ntsc_frames! = 0

proc music_player
  if \ntsc_pal! = 0 then
    inc \ntsc_frames!
    if \ntsc_frames! = 6 then \ntsc_frames! = 0 : return
  endif
  sys $5440
endproc

proc music_player2
  if \ntsc_pal! = 0 then
    inc \ntsc_frames!
    if \ntsc_frames! = 6 then \ntsc_frames! = 0 : return
  endif
  sys $6721
endproc

include "ext/xcb-ext-sprite.bas"
include "ext/xcb-ext-joystick.bas"
include "ext/xcb-ext-rasterinterrupt.bas"
include "ext/xcb-ext-sfx.bas"
include "inc/constants.bas"
include "inc/globals.bas"
include "inc/proc_configure_sprites.bas"

gosub instructions
goto main

include "inc/proc_update_scoretable.bas"
include "inc/proc_update_sprites.bas"
include "inc/proc_shift.bas"
include "inc/proc_query_joystick.bas"
include "inc/proc_poll_collisions.bas"
include "inc/proc_setup_screen.bas"
include "inc/proc_update_radar.bas"
include "inc/proc_actions.bas"
include "inc/proc_move_ufos.bas"
include "inc/proc_logo.bas"
include "inc/proc_intro.bas"

main:

poke VIC_CONTROL2, VIC_CTR_DEFAULT!
poke VIC_MEMSETUP, %00011000
poke VIC_BORDER, 0 : poke VIC_BACKGR, 0

call intro

for addr = $d400 to $d418
  poke addr, 0
next addr

sfx_init @sounds + 2, 1

rem filter mode and main volume control
rem vol=15, filter=low pass
poke SID_VOLUME, %00011111

rem ** AIRPLANE WHITE NOISE **
rem control register voice 3
poke SID_CTRL3, %10000001

poke SID_AD3, %00100000
poke SID_SR3, %11110000
; filters
poke $d415, 0
poke $d416, %00000100
poke $d417, %01000100
poke $d418, %00011111

rem --------------------------------------------
rem -- Set graphics properties on top of screen 
rem -- and update radar
rem --------------------------------------------

proc interrupt1
  poke \VIC_CONTROL2, \VIC_CTR_DEFAULT!
endproc

rem ----------------------------------------------
rem -- Set graphics properties after the dashboard 
rem -- is drawn + update main sprites
rem ----------------------------------------------

proc interrupt2
  poke $d022, 15 : poke $d023, 12
endproc

rem -----------------------------------------------
rem -- Set graphics properties before the scrolling
rem -- area is drawn 
rem -----------------------------------------------

proc interrupt3
  poke \VIC_CONTROL2, \VIC_CTR_DEFAULT! | \scroll!
  poke $d022, 7 : poke $d023, 2
endproc

rem -----------------------------------------------
rem -- Set up raster interrupts 
rem -----------------------------------------------

ri_isr_count! = 4
ri_set_isr 0, @interrupt1, 50
ri_set_isr 1, @interrupt2, 90
ri_set_isr 2, @interrupt3, 176
ri_set_isr 3, @sfx_play, 0
ri_syshandler_off

rem -----------------------------------------------
rem -- START NEW GAME
rem -----------------------------------------------

ri_off
poke \VIC_CONTROL1, peek!(\VIC_CONTROL1) & %11101111
call configure_sprites
ri_on
poke \VIC_CONTROL1, peek!(\VIC_CONTROL1) | %00010000

rem -- reset variables before starting a new game
level_done! = 1 : wave! = 1 : rem 10
score = 0
fleet! = 3 : wave_countdown! = 4 : ufos_killed = 0
attack_wave_index = 0: rem 126 
no_of_ufos_in_this_wave! = 0

game_loop:

  shields_in_this_level! = \levels![attack_wave_index]
  inc attack_wave_index

  no_of_waves! = \levels![attack_wave_index]
  inc attack_wave_index
  
  ufo_count! = \levels![attack_wave_index]
  inc attack_wave_index
  
  level_loop:
 
    aircraft_xpos = 2560 : aircraft_altitude = 848
    city_map_ptr_right = CITY_MAP_DEFAULT_PTR_RIGHT
    city_map_ptr_left  = CITY_MAP_DEFAULT_PTR_LEFT
    
    call setup_screen(0)
    call update_scoretable
    
    if level_done! = 1 then
      textat 14, 12, "attack wave" : textat 25, 12, wave! 
      fleet_at_start! = fleet!
      
      for j! = 0 to 3
        ufo_on![j!] = 0
        ufo_hit![j!] = 0
      next j!
      wave_countdown! = 4
    endif
    
    level_done! = 0
    fuel! = 0
    aircraft_mode! = AIRCRAFT_MODE_REFUEL!
    speed! = 0 : dir! = 1 : lifting! = 0
    frame_count! = 0 : scroll! = 0
    turning! = 0 : turn_phase! = 0 : turn_phase_count! = 0
    poke \SID_CTRL3, %10000001
    sfx_start 1
  
    ntsc_frames! = 0
    
    main_loop:
      
      watch RASTER_POS, 230
      
      if ntsc_pal! = 0 then
        inc ntsc_frames!
        if ntsc_frames! = 6 then ntsc_frames! = 0 : watch RASTER_POS, 220 : goto main_loop
      endif
      
      call query_joystick
      call update_radar
      
      microspeed! = rshift!(speed!, 4)
      distance_taken = distance_taken + cast(microspeed!)

      rem --
      rem -- scroll the stage to left or right
      rem --
      
      if dir! = 0 then
        scroll! = scroll! + microspeed!
        aircraft_xpos = aircraft_xpos - microspeed!
        if aircraft_xpos < 0 then aircraft_xpos = aircraft_xpos + 5120
        if scroll! > 7 then
          scroll! = scroll! & %00000111
          call shift_right
        else
          call poll_collisions
          call update_scoretable
        endif
      else
        scroll! = scroll! - microspeed!
        aircraft_xpos = aircraft_xpos + microspeed!
        if aircraft_xpos > 5119 then aircraft_xpos = aircraft_xpos - 5120
        if scroll! > 249 then
          scroll! = scroll! & %00000111
          call shift_left
        else
          call poll_collisions  
          call update_scoretable
        endif
      endif
      
      dec frame_count!
      dec sound_counter!
      
      call actions
      call move_ufos
      call update_sprites
      
      on level_done! goto main_loop, level_done, life_lost, game_over
      
      level_done:
        if wave! = LEVEL_COUNT! then goto game_completed
        inc wave!
        inc fleet!
        poke \SID_CTRL3, %10000000
        sfx_start 9
        for ii = 0 to 400
          watch \RASTER_POS, 0
        next ii
        goto game_loop
        
      life_lost:
        dec fleet!
        fuel! = 0
        aircraft_altitude = 848
        aircraft_xpos = 2560
        if \ufo_count! = 0 then level_done! = 1 : goto level_done
        rem -- put ufos back to top of screen
        rem -- otherwise it's too hard to kill them
        for j! = 0 to 3
          if ufo_on![j!] = 1 then
            \ufo_xpos[j!] = \ufo_initial_xpos[j!]
            \ufo_altitude![j!] = 81
          endif
        next j!
        \wave_countdown! = 7
        call update_scoretable
        for ii = 0 to 400
          watch \RASTER_POS, 0
        next ii
        if fleet! > 0 then goto level_loop
    
      game_over:
        sfx_start 7
        textat 12, 12, "   game over   "
        if \score > 0 and \score = \hiscore then
          textat 14, 13, "new hiscore" : memset 55830, 11, 2
        endif
        for ii = 0 to 400
          watch \RASTER_POS, 0
        next ii
        goto main
  
game_completed:
  ri_off
  ntsc_frames! = 0
  poke $d022, 15 : poke $d023, 12
  call setup_screen(2)
  call update_scoretable
  \ri_isr_count! = 1
  ri_set_isr 0, @music_player2, 250
  sys $6748
  ri_on
  loop4ever:
    goto loop4ever

instructions:
  include "inc/instructions.bas"
  
rem -----------------------------------------------
rem -- Resource files included in the program
rem -- as binary data
rem -----------------------------------------------
  
origin $1e00
rem -- logo sprites
incbin "resources/logo.bin"

origin $1ffe
rem -- chars ($2000-2800)
incbin "resources/charset.64c"

rem -- sprites ($2800-$3fff)
incbin "resources/sprites.bin"

origin $4000
rem -- tile map ($4000-)
incbin "resources/graphics.bin"

origin $5440
incbin "resources/Black_Hawk5400_cut_headless.sid"

sounds:
incbin "resources/sfx.bin"

origin $6700
incbin "resources/Noice_Anthem6700_cut_headless.sid"
