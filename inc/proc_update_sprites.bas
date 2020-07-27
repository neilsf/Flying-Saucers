rem ----------------------
rem - enable, disable,
rem - move and animate
rem - sprites
rem ----------------------

proc update_sprites

  rem -- move aircraft
  
  freq = 1500 + lshift(cast(\speed!), 3)
  doke $d40e, freq 
  
  spr_setposy 7, cast!(rshift(\aircraft_altitude, 2))

  spr_loc_offset! = spr_loc_offsets![\dir!]
  
  if \turning! = 0 then
    if \aircraft_mode! = \AIRCRAFT_MODE_TAXI! then spr_setshape 7, 168  + \lifting! + spr_loc_offset!
  else
    if \turn_phase! = 0 then
      \turn_phase! = 171 + spr_loc_offset!
      turn_count! = 0
    else
      if \frame_count! & %00000001 = 0 then 
        inc \turn_phase! : inc turn_count! : inc \aircraft_altitude : inc \aircraft_altitude
        spr_setshape 7, \turn_phase!
        \speed! = turn_speed![turn_count!]
        if turn_count! = 11 then \dir! = switchdir![\dir!] 
        if turn_count! = 20 then
          \turn_phase! = 0
          \turning!    = 0
        endif
      endif
    endif    
  endif

rem -- move bullet

  if \bullet_on! = 1 then

    spr_setpos 6, \bullet_xpos, \bullet_ypos!
    
    curr_bullet_dx = bullet_dx[\bullet_dir!]
    
    ''\bullet_xpos = \bullet_xpos + dirmult[\dir!] * microspeed!
    
    if \bullet_dir! = 1 then
      if \dir! = 1 then
        \bullet_xpos = \bullet_xpos + cast(\bullet_speed!) - cast(\microspeed!)
      else
        \bullet_xpos = \bullet_xpos + cast(\bullet_speed!) + cast(\microspeed!)
      endif
    else
      if \dir! = 0 then
        \bullet_xpos = \bullet_xpos - cast(\bullet_speed!) + cast(\microspeed!)
      else
        \bullet_xpos = \bullet_xpos - cast(\bullet_speed!) - cast(\microspeed!)
      endif
    endif
   
    \bullet_ypos! = \bullet_ypos! + \bullet_dy!
   
    if \bullet_xpos < 20 or \bullet_xpos > 340 then \bullet_on! = 0 : spr_disable 6
    if \bullet_ypos! > 230 then \bullet_on! = 0 : spr_disable 6
  endif

  rem -- display ufos
  
  for i! = 0 to 3
    if \ufo_on![i!] = 1 then
      x = \ufo_xpos[i!] - \aircraft_xpos
      if abs(x) <= 160 then
      
        spr_setpos i!, x + 173, \ufo_altitude![i!]
        spr_enable i!
       
        rem -- display fade animation if ufo is shot
        if \ufo_hit![i!] = 1 and \frame_count! & %00000011 = 1 then
          spr_setshape i!, \ufo_animphase![i!]
          inc \ufo_animphase![i!]
          rem -- if animation is over
          if \ufo_animphase![i!] = 167 then
            \ufo_on![i!] = 0
            \ufo_hit![i!] = 0
            spr_disable i!
          endif
        else
          rem -- display normal animation if not
          spr_setshape i!, ufo_anim![rshift!(\frame_count! & %00110000, 4)]
        endif
        
      else
        spr_disable i!
      endif
    else
      spr_disable i!
    endif
  next
  
  data spr_loc_offsets![] = 0, 27

  data turn_speed![] = 48, 46, 44, 42, 40, 38, 36, 34, 32, 32, 32, 32, 34, 36, 38, 40, 42, 44, 46, 48, 48
  data switchdir![] = 1, 0
  data ufo_anim![] = 160, 161, 162, 161
  data bullet_dx[] = 12, 12, 0, 0
endproc
