proc poll_collisions

  if \aircraft_mode! <> \AIRCRAFT_MODE_TAXI! then return

  aircraft_coll_state! = peek!(\SPR_DATA_COLL)
  
  if aircraft_coll_state! & %10000000 = %10000000 then
    \aircraft_mode! = \AIRCRAFT_MODE_NOSEDIVING!
    \turn_phase! = 242 + \dir! * 8
    \turn_phase_count! = 0
    poke \SID_CTRL3, %10000000
    sfx_start 1
    return
  endif

  spr_hit! = peek!(\SPR_SPR_COLL)
  
  rem -- check if aircraft or bullet hit a ufo
  if spr_hit! & %11000000 <> 0 then
    for i! = 0 to 3
      if \ufo_hit![i!] = 0 and spr_hit! & %00111111 = bits![i!] then
        \ufo_hit![i!] = 1
        \ufo_animphase![i!] = 163
        \bullet_on! = 0
        spr_disable 6
        sfx_start 9
        inc \score : dec \ufo_count! : inc \ufos_killed : dec \no_of_ufos_in_this_wave! : call update_scoretable
      endif
    next i!
    
    rem -- was it the aircraft?
    if spr_hit! & %10000000 <> 0 then
      \aircraft_mode! = \AIRCRAFT_MODE_NOSEDIVING!
      \turn_phase! = 242 + \dir! * 8
      \turn_phase_count! = 0
      poke \SID_CTRL3, %10000000
      sfx_start 1
    endif
    
  endif
    
  data bits![] = 1, 2, 4, 8, 16, 32, 64, 128
  
endproc
