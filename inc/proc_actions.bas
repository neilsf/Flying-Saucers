rem -----------------------
rem -- routines that handle
rem -- take off, landing, 
rem -- refueling, etc
rem -----------------------

proc actions

  dim anim_counter!
  dim altitude_delta
  
  on \aircraft_mode! goto taxi, refuel, take_off, landing, nosediving, scrolling_to_ufo
  
  taxi:
    if \fuel! > 0 and \distance_taken > 400 then
      rem -- decrease fuel
      dec \fuel!
      gosub erase_fuel
      \distance_taken = 0
    endif
    rem -- check if autopilot should take over
    if \aircraft_altitude >= 780 and \aircraft_altitude <= 848 then
      if \speed! < 72 then
        if \dir! = 1 then
          if \aircraft_xpos >= 2368 and \aircraft_xpos <= 2432 then goto start_landing
        else
          if \aircraft_xpos >= 2688 and \aircraft_xpos <= 2752 then goto start_landing
        endif
      endif
    endif
    
    return
    
  start_landing:
    anim_counter! = 0
    \aircraft_mode! = \AIRCRAFT_MODE_LANDING!
    textat 14, 12, " on autopilot "
    return
    
  refuel:
    spr_setshape 7, 194 + \dir! * 27
    spr_enable 7
    if \frame_count! & %00000111 = 0 then
      inc \fuel!
      gosub draw_fuel
      if \fuel! >= 36 then
        ''poke \SID_CTRL2, %00100000
        \speed! = 48
        anim_counter! = 0
        \aircraft_mode! = \AIRCRAFT_MODE_TAKE_OFF!
        textat 14, 12, " on autopilot "
        \distance_taken = 0
      endif
    endif
    return
    
  take_off:
    inc anim_counter!
    \speed! = rshift!(anim_counter!, 2) + 48 
    if anim_counter! = 30 then spr_setshape 7, 193 + \dir! * 27
    if anim_counter! = 50 then spr_setshape 7, 192 + \dir! * 27
    if anim_counter! > 30 then
      \lifting! = 1
      dec \aircraft_altitude : dec \aircraft_altitude
    endif
    if anim_counter! >= 70 then
      memset $05ed, 14, 32
      rem -- clear collision registers
      x! = peek!(\SPR_DATA_COLL)
      x! = peek!(\SPR_SPR_COLL)
      \aircraft_mode! = \AIRCRAFT_MODE_TAXI!
    endif
    return
    
  landing:
    if abs(\aircraft_xpos - 2560) > 8 then
      spr_setshape 7, 193 + \dir! * 27
      if \speed! > 48 then dec \speed!
      if \aircraft_altitude < 848 then inc \aircraft_altitude : inc \aircraft_altitude else spr_setshape 7, 194 + \dir! * 27
    else
      \speed! = 0 : \score = \score + 2
      if \ufo_count! = 0 then
        \score = \score + 5
        if \fleet_at_start! = \fleet! then \score = \score + 5
        textat 14, 12, "  well done   "
        \level_done! = 1
      else
        \aircraft_mode! = \AIRCRAFT_MODE_REFUEL!
        sfx_start 1
        textat 14, 12, "  refueling   "
      endif
    endif
    return
  
  nosediving:
    if \frame_count! & %00000011 = 1 then
      spr_setshape 7, \turn_phase!
      inc \turn_phase! : inc \turn_phase_count!
      if \turn_phase_count! = 6 then
        spr_disable 7
        \speed! = 0
      endif
      if \turn_phase_count! = 24 then
        \level_done! = 2
        textat 12, 12, "    crashed    "
      endif
    endif
    \aircraft_altitude = \aircraft_altitude + 4
    return
    
  scrolling_to_ufo:
    if \speed! < 128 then inc \speed!
    if abs(\aircraft_xpos - \sav_ufo_xpos) < 8 then \level_done! = 3
    return
  
  draw_fuel:
    offset! = rshift!(\fuel!, 2)
    if offset! = 0 then return
    poke 1065 + offset!, $a0
    return
    
  erase_fuel:
    offset! = rshift!(\fuel!, 2)
    poke 1066 + offset!, $20
    return
endproc