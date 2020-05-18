proc poll_collisions

  if \aircraft_mode! <> \AIRCRAFT_MODE_TAXI! then return

  if \sound_counter! < 2 then poke \SID_CTRL3, %10000000

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
    for i! = 0 to 2
      if spr_hit! & %00111111 = bits![i!] then
        ufo_num! = \spr_to_ufo![i!]
        \ufo_hit![ufo_num!] = 1
        \ufo_animphase![ufo_num!] = 163
        \bullet_on! = 0
        poke \SID_CTRL2, %00010000
        poke \SID_CTRL3, %10000001
        \sound_counter! = 25
        spr_disable 6
      endif
    next i!
  endif
  
  data bits![] = 1, 2, 4, 8, 16, 32, 64, 128
  
endproc
