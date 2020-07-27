rem ----------------------
rem - query joystick state
rem - and update variables
rem - accordingly
rem ----------------------

 proc query_joystick

  if \aircraft_mode! <> \AIRCRAFT_MODE_TAXI! then return
 
  if joy_1_up!() = 1 and \aircraft_altitude > 360 then
    dec \aircraft_altitude
    dec \aircraft_altitude
    \lifting! = 1
  else
    if joy_1_down!() = 1 then
      inc \aircraft_altitude
      inc \aircraft_altitude
      \lifting! = 2
    else
      \lifting! = 0
    endif
  endif

  rem -- TODO: RESOLVE THIS IF..ELSE NIGHTMARE
  
  if joy_1_right!() = 1 then joy_dir! = 1 

  if joy_1_right!() = 1 then
    if \dir! = 1 then
      if \speed! < 96 then
        inc \speed!
      endif
    else
      if \speed! > 48 then
        dec \speed!
        dec \speed!
      else
        \turning! = 2
      endif
    endif
  else
    if joy_1_left!() = 1 then
      if \dir! = 0 then
        if \speed! < 96 then
          inc \speed!
        endif
      else
        if \speed! > 48 then
          dec \speed!
          dec \speed!
        else
          \turning! = 1
        endif
      endif
    endif
  endif
  
  if joy_1_fire!() = 1 and \bullet_on! = 0 then
    if \turning! = 0 then
      \bullet_on! = 1
      \bullet_ypos! = cast!(rshift(\aircraft_altitude, 2))
      \bullet_xpos = 166 + \dir! * 16
      \bullet_dir! = \dir!
      if joy_1_down!() = 1 then
        \bullet_speed! = \microspeed!
        \bullet_sound_step = 75
      else
        \bullet_speed! = \microspeed! + 12
        \bullet_sound_step = 400
      endif
      \bullet_dy! = lifting_to_bullet_dy![\lifting!]
      spr_enable 6
      spr_setshape 6, 223 - \dir!
      sfx_start 1
    endif
  endif
  
  data lifting_to_bullet_dy![] = 0, 255, 1
  
endproc
