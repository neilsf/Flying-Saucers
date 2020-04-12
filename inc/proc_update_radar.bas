proc update_radar

  rem -- clear radar
  memset 1076, 16, 32
  memset 1116, 16, 32
  memset 1156, 16, 32
  
  rem -- put aircraft on radar  
  spr_setposx 5, \aircraft_xpos / 40 + 112
  
  rem -- put ufos on radar
  for i! = 0 to 12
    if \ufo_on![i!] = 1 then
      ''poke \attack_wave_radar_pos[rshift!(\ufo_path![i!], 5), \ufo_wave![i!]], 110
    endif
  next i!

endproc
