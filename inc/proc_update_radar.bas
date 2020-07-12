rem -----------------------
rem -- draw the radar on
rem -- the top of screen 
rem -----------------------

proc update_radar

  memcpy @radar_2nd_row!, 1116, 16
  memcpy @radar_3rd_row!, 1156, 16
 
  spr_setposx 5, \aircraft_xpos / 40 + 112

  for i! = 0 to 3
    if \ufo_on![i!] = 1 then
      wave! = \ufo_wave_select![i!]
      char! = 116
      if wave! = 0 then inc char! : inc char!
      if wave! = 16 then inc char! : inc char!
      charpos = 1116 + wave!
      if \ufo_altitude![i!] > 160 then inc char! : charpos = charpos + 40
      poke charpos, char!
    endif
  next i!
  
  data radar_2nd_row![] = 188, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,189
  data radar_3rd_row![] = 187,191,191,191,191,191,191,192,193,191,191,191,191,191,191,186
  
endproc