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
include "inc/globals.bas"
include "inc/proc_configure_sprites.bas"
include "inc/proc_logo.bas"

goto main

include "inc/proc_update_sprites.bas"
include "inc/proc_shift.bas"
include "inc/proc_query_joystick.bas"
include "inc/proc_poll_collisions.bas"
include "inc/proc_setup_screen.bas"
include "inc/proc_update_radar.bas"
include "inc/proc_intro.bas"
include "inc/proc_actions.bas"
include "inc/proc_move_ufos.bas"

main:

poke VIC_CONTROL2, VIC_CTR_DEFAULT!
poke VIC_MEMSETUP, %00011000
poke VIC_BORDER, 0 : poke VIC_BACKGR, 0

call intro
call configure_sprites
spr_enable 7
let city_map_ptr_right = CITY_MAP_DEFAULT_PTR_RIGHT
let city_map_ptr_left  = CITY_MAP_DEFAULT_PTR_LEFT

rem -- play starts here

call setup_screen(1)
;call configure_sprites

for addr = $d400 to $d418
  poke addr, 0
next addr

poke $d418, 31
poke $d404, 129
''poke $d40b, %00010101

poke $d405, 32
poke $d406, 128
poke $d416, 0
poke $d417, 1
''poke $d40c, 32
''poke $d40d, $88

rem --------------------------------------------
rem -- Set graphics properties on top of screen 
rem --------------------------------------------

proc interrupt1
  poke \VIC_CONTROL2, \VIC_CTR_DEFAULT!
endproc

rem ----------------------------------------------
rem -- Set graphics properties after the dashboard 
rem -- is drawn 
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
ri_on

fleet! = 4
repeat

  speed! = 0
  autopilot! = 1
  aircraft_mode! = AIRCRAFT_MODE_REFUEL!
  textat 14, 12, " refueling  " : memset $d9ed, 13, 2
  
  for j! = 0 to 12
    ufo_on![j!] = 0
    ufo_hit![j!] = 0
  next j!
  
  rem TEST UFOS
  ufo_on![2] = 1 : ufo_path![2] = 0
  ufo_on![3] = 1 : ufo_path![3] = 0
  ufo_on![4] = 1 : ufo_path![4] = 0

  main_loop:

    ;rtextat 2, 0, aircraft_xpos
    ''wait_loop:
      watch RASTER_POS, 248
      ''if peek!($d011) & %10000000 = %10000000 then goto wait_loop
    
    poke 53280, 2
    
    call query_joystick
    call update_sprites
    
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
        call update_radar
        call poll_collisions
        call move_ufos
      endif
    else
      scroll! = scroll! - microspeed!
      aircraft_xpos = aircraft_xpos + microspeed!
      if aircraft_xpos > 5119 then aircraft_xpos = aircraft_xpos - 5120
      if scroll! > 249 then
        scroll! = scroll! & %00000111
        call shift_left
      else
        call update_radar
        call poll_collisions
        call move_ufos
      endif
    endif
    
    
    dec frame_count!
    call actions
    
    
    poke 53280, 0
    goto main_loop
  
until fleet! = 0
  
  
asm "
  ECHO *
"
  
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

instructions:
  memset 1024, 1000, 32
  print " welcome to "
