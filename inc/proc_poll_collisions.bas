proc poll_collisions

  if \aircraft_mode! <> \AIRCRAFT_MODE_TAXI! then return

  aircraft_coll_state! = peek!(\SPR_DATA_COLL)
  
  if aircraft_coll_state! & %10000000 = %10000000 then goto aircraft_hit

  spr_hit! = peek!(\SPR_SPR_COLL)
  
  rem -- check if aircraft or bullet hit a ufo
  if spr_hit! & %11000000 <> 0 then
    i! = 0
    repeat
      if \ufo_hit![i!] = 0 and spr_hit! & %00111111 = bits![i!] then
        if \ufo_has_shield![i!]= 0 then
          \ufo_hit![i!] = 1
          \ufo_animphase![i!] = 163
          \bullet_on! = 0
          spr_disable 6
          sfx_start 2
          inc \score : dec \ufo_count! : inc \ufos_killed : dec \no_of_ufos_in_this_wave! : call update_scoretable
          if \no_of_ufos_in_this_wave! = 0 then \wave_countdown! = 2
          if \ufo_count! = 0 then textat 12, 0, "return 2 carrier"
        else
          \ufo_has_shield![i!] = 0
          \bullet_on! = 0
          spr_disable 6
          sfx_start 3
        endif
        i! = 3
      endif
      inc i!
    until i! = 4
    
    rem -- was it the aircraft?
    if spr_hit! & %11000000 = %10000000 then goto aircraft_hit
  endif
  
  return
  
  aircraft_hit:
    \aircraft_mode! = \AIRCRAFT_MODE_NOSEDIVING!
    \turn_phase! = 242 + \dir! * 8
    \turn_phase_count! = 0
    \turning! = 0
    poke \SID_CTRL3, %10000000
    sfx_start 5
    return
    
  data bits![] = 1, 2, 4, 8, 16, 32, 64, 128
  
endproc
