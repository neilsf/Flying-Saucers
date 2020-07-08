proc poll_collisions

  if \aircraft_mode! <> \AIRCRAFT_MODE_TAXI! then return

  aircraft_coll_state! = peek!(\SPR_DATA_COLL)
  
  if aircraft_coll_state! & %10000000 = %10000000 then
    \aircraft_mode! = \AIRCRAFT_MODE_NOSEDIVING!
    \turn_phase! = 242 + \dir! * 8
    \turn_phase_count! = 0
    return
  endif

  rem -- check if bullet hit a ufo
  spr_hit! = peek!(\SPR_SPR_COLL)
  if spr_hit! & %01000000 > 0 then
    for i! = 0 to 3
      if spr_hit! & %00111111 = bits![i!] then
        \ufo_hit![i!] = 1
        \ufo_animphase![i!] = 163
        \bullet_on! = 0
        spr_disable 6
        sfx_start 9
      endif
    next i!
  endif
  
  data bits![] = 1, 2, 4, 8, 16, 32, 64, 128
  
endproc
