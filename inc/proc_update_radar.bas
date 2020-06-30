rem -----------------------
rem -- draw the radar on
rem -- the top of screen 
rem -----------------------

proc update_radar

  rem -- clear radar
  rem TODO if radar objects are all sprites
  rem then we don't need this
  
  rem memset 1076, 16, 32
  rem memset 1116, 16, 32
  rem memset 1156, 16, 32

  rem -- put self location on radar  
  spr_setposx 5, \aircraft_xpos / 40 + 112

  rem -- put ufos on radar
  for i! = 0 to 3
    if \ufo_on![i!] = 1 then
      rem TODO implement!
      'index! = rshift!(\ufo_wave![i!], 4)
      'poke \attack_wave_radar_pos[index!, i!], \attack_wave_radar_shape![index!, i!]
    endif
  next i!

endproc