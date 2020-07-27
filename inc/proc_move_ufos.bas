proc move_ufos
    
  if \aircraft_mode! <> \AIRCRAFT_MODE_TAXI! then return
    
  ufo_landed! = 0
  
  if \frame_count! & %01111111 = 0 then
    rem -- launch new attack wave if time
    xspeed = xspeed_table[\wave_countdown!]
    yspeed! = yspeed_table![\wave_countdown!]
    if \wave_countdown! > 0 then dec \wave_countdown!
    rem -- new wave should not come before the previous one is cleared
    if \no_of_ufos_in_this_wave! = 0 then
      if \wave_countdown! = 0 and \no_of_waves! <> 0 then
        dec \no_of_waves!
        sfx_start 2
        \no_of_ufos_in_this_wave! = 0
        for j! = 0 to 3
          wave_no! = \levels![\attack_wave_index]
          \ufo_wave_select![j!] = wave_no!
          if wave_no! <> 255 then
            inc \no_of_ufos_in_this_wave!
            \ufo_on![j!] = 1
            \ufo_xpos[j!] = \initial_ufo_posx[wave_no!]
            \ufo_altitude![j!] = 81: rem 80
          else
            ufo_on![j!] = 0
          endif
          
          ufo_hit![j!] = 0
          inc \attack_wave_index
        next j!
        \wave_countdown! = 7
      endif
    endif
    for j! = 0 to 3
      \ufo_current_xspeed[j!] = xspeed
      \ufo_current_yspeed![j!] = yspeed!
    next j!
  endif
  
  if \frame_count! & %00000011 = 0 then
    for i! = 0 to 3
      if \ufo_on![i!] = 1 then
        \ufo_xpos[i!] = \ufo_xpos[i!] + \ufo_current_xspeed[i!]
        \ufo_altitude![i!] = \ufo_altitude![i!] + \ufo_current_yspeed![i!]
        if \ufo_altitude![i!] >= 234 then
          textat 12, 12, "   game over   "
          if \ufo_xpos[i!] <= \aircraft_xpos then \dir! = 0 else \dir! = 1
          \speed! = 250
          \sav_ufo_xpos = \ufo_xpos[i!]
          spr_disable 7
          \aircraft_mode! = \AIRCRAFT_MODE_SCROLLING_TO_UFO!
        endif
      endif
    next i!
  endif
  
  if ufo_landed! = 1 then print "game over" : end

  data xspeed_table[] =    0, 0, 4, 0,-4, 0, 4, 0
  data yspeed_table![] =   1, 1, 0, 0, 0, 1, 0, 1
    
endproc