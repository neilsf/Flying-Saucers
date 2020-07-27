rem -------------------------
rem -- Flying saucers
rem --
rem -- Written by
rem -- Csaba Fekete
rem --
rem -- Graphics
rem -- Daniel Fekete
rem -------------------------

debug! = 0

proc music_player
  sys $5440
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
poke $d416, %00000111
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

ri_isr_count! = 3
ri_set_isr 0, @interrupt1, 50
ri_set_isr 1, @interrupt2, 90
ri_set_isr 2, @interrupt3, 176
ri_syshandler_off

rem -----------------------------------------------
rem -- START NEW GAME
rem -----------------------------------------------

ri_off
poke \VIC_CONTROL1, peek!(\VIC_CONTROL1) & %11101111
call configure_sprites
ri_on
poke \VIC_CONTROL1, peek!(\VIC_CONTROL1) | %00010000

rem -- 0: not done 1: done 2: life lost
level_done! = 1 : wave! = 1
fleet! = 4 : wave_countdown! = 7 : ufos_killed = 0
attack_wave_index = 0 : no_of_ufos_in_this_wave! = 0

game_loop:
  
  no_of_waves! = \levels![attack_wave_index]
  inc attack_wave_index
  
  ufo_count! = \levels![attack_wave_index]
  inc attack_wave_index
  
  level_loop:
  
    aircraft_xpos = 2560
    city_map_ptr_right = CITY_MAP_DEFAULT_PTR_RIGHT
    city_map_ptr_left  = CITY_MAP_DEFAULT_PTR_LEFT
    
    call setup_screen(1)
    call update_scoretable
    
    if level_done! = 1 then
      textat 14, 12, "attack wave" : textat 25, 12, wave! 
      fleet_at_start! = fleet!
      
      for j! = 0 to 3
        ufo_on![j!] = 0
        ufo_hit![j!] = 0
      next j!
    endif
    
    level_done! = 0
    fuel! = 0
    speed! = 0 : dir! = 1 : \turning! = 0 : \turn_phase! = 0
    aircraft_mode! = AIRCRAFT_MODE_REFUEL!
    \turn_phase! = 0
    poke \SID_CTRL3, %10000001
  
    main_loop:
      
      watch RASTER_POS, 230

      call query_joystick
      call update_radar
      
      microspeed! = rshift!(speed!, 4)

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
      call sfx_play
      
      on level_done! goto main_loop, level_done, life_lost
      
      level_done:
        if wave! = LEVEL_COUNT! then goto game_completed
        inc wave!
        inc fleet!
        for j! = 0 to 200
          watch \RASTER_POS, 0
        next j!
        goto game_loop
        
      life_lost:
        dec fleet!
        fuel! = 0
        aircraft_altitude = 848
        let aircraft_xpos = 2560
        for ii = 0 to 400
          watch \RASTER_POS, 0
        next ii
        if fleet! = 0 then goto game_over else goto level_loop
    
    rem -- Program never gets here:
  
game_over:
  goto main
  
game_completed:
  print "WOW, complete" : end

instructions:
  poke VIC_CONTROL2, %11001000
  print "{147}{14}{8}"
  print " Welcome to FLYING SAUCERS!"
  print " =========================={13}"
  
  print " In this game you'll control a fighter"
  print " aircraft and your mission is to save"
  print " the city from an alien invasion. The"
  print " command is simple:{13}"
  print " ** Prevent any UFOs from landing! **{13}"
  
  print " Gameplay"
  print " --------{13}"
  
  print " The game involves several attack waves"
  print " that slowly get more and more diffi-"
  print " cult. When you destroyed all UFOs in"
  print " an attack wave, you have to return to"
  print " the carrier and prepare for the next"
  print " wave. You'll get one extra aircraft in"
  print " the beginning of each attack wave.{13}"
  
  print " press a key to continue..."
  
  gosub wait_key
  
  print "{147}{13} Controls"
  print " --------{13}"
  
  print " Use joystick in port 1. The take-off"
  print " and landing procedures are done by the"
  print " auto-pilot. After taking off, pull up"
  print " to lift or down to descend. Pull left"
  print " or right to increase or decrease speed"
  print " or make a u-turn. Press fire to launch"
  print " projectile or down + fire to bomb.{13}"
  
  print " To avoid losing the aircraft{13}"
  print " * Do not crash into any objects."
  print " * Return to the carrier when you're"
  print "   low on fuel.{13}"

  print " The game ends when{13}"
  print " * A UFO reaches ground - or -"
  print " * You lose all your fleet{13}"
  
  print " press a key to continue..."

  gosub wait_key
  
  print "{147}{13} Landing"
  print " -------{13}"
  
  print " Approach the aircraft carrier with low"
  print " speed and on low altitude to initiate"
  print " the landing procedure. If your speed"
  print " and altitude are low enough, the auto-"
  print " pilot will do the landing for you.{13}"
  print " Scoring"
  print " -------{13}"
  print "  1 pt  for each enemy aircraft down"
  print "  2 pts for each successful landing"
  print "  5 pts for each completed level"
  print " +5 pts if level completed without loss{13}"
  print "{13}{13} GOOD LUCK!{13}{13}"
  print " press a key to begin..."
 

  gosub wait_key
  return
  
  wait_key:
    if inkey!() = 0 then goto wait_key
    return
    
rem -- graphics data
origin $1ffe

rem -- chars ($2000-2800)
incbin "resources/charset.64c"

rem -- sprites ($2800-$3c7a)
incbin "resources/sprites.bin"

rem -- map ($4000-)
origin $4000
incbin "resources/graphics.bin"

origin $5440
incbin "resources/Black_Hawk5400_cut_headless.sid"
rem -- $6400-
incbin "resources/logo.bin"

sounds:
incbin "resources/sfx.bin"