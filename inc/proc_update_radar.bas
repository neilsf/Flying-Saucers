proc update_radar

;poke 53280, 1
  rem -- clear radar
  memset 1076, 16, 32
  memset 1116, 16, 32
  memset 1156, 16, 32
;poke 53280, 3
  rem -- put self location on radar  
  spr_setposx 5, \aircraft_xpos / 40 + 112
;poke 53280, 4
  rem -- put ufos on radar
  for i! = 0 to 12
    if \ufo_on![i!] = 1 then
      index! = rshift!(\ufo_wave![i!], 4)
      debug_label:
      poke \attack_wave_radar_pos[index!, i!], \attack_wave_radar_shape![index!, i!]
    endif
  next i!
;poke 53280, 2
endproc
