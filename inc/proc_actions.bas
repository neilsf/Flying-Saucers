rem -----------------------
rem -- routines that handle
rem -- take off, landing, 
rem -- refueling
rem -----------------------

proc actions

  dim anim_counter!
  dim altitude_delta
  
  on \aircraft_mode! goto taxi, refuel, take_off, landing, nosediving
  
  taxi:
    rem -- decrease fuel
    if \frame_count! & %01111111 = 0 then
      dec \fuel!
      gosub erase_fuel
    endif
    rem -- check if autopilot should take over
    if \aircraft_altitude >= 780 and \aircraft_altitude <= 848 then
      if \speed! < 72 then
        if \dir! = 1 then
          if \aircraft_xpos >= 4448 and \aircraft_xpos <= 4512 then goto start_landing
        else
          if \aircraft_xpos >= 4768 and \aircraft_xpos <= 4832 then goto start_landing
        endif
      endif
    endif
    rem -- check if time for an ufo to come
    if \ufo_timer <= 0 then
      \ufo_on![\nxt_attack_wave_pos!] = 1
      \ufo_hit![\nxt_attack_wave_pos!] = 0
      \ufo_path![\nxt_attack_wave_pos!] = 0
      rem get next ufo
      \ufo_timer = \attack_wave_1[\attack_wave_index]
      inc \attack_wave_index
      \nxt_attack_wave_pos! = cast!(\attack_wave_1[\attack_wave_index])
      inc \attack_wave_index
    endif
    return
    
  start_landing:
    anim_counter! = 0
    \aircraft_mode! = \AIRCRAFT_MODE_LANDING!
    textat 14, 12, " on autopilot "
    return
    
  refuel:
    spr_setshape 7, 194 + \dir! * 27
    if \frame_count! & %00000111 = 0 then
      inc \fuel!
      gosub draw_fuel
      if \fuel! >= 32 then
        ''poke \SID_CTRL2, %00100000
        \speed! = 48
        anim_counter! = 0
        \aircraft_mode! = \AIRCRAFT_MODE_TAKE_OFF!
        textat 14, 12, " on autopilot "
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
      \aircraft_mode! = \AIRCRAFT_MODE_TAXI!
    endif
    return
    
  landing:
    if abs(\aircraft_xpos - 4640) > 8 then
      spr_setshape 7, 193 + \dir! * 27
      if \speed! > 48 then dec \speed!
      if \aircraft_altitude < 848 then inc \aircraft_altitude : inc \aircraft_altitude else spr_setshape 7, 194 + \dir! * 27
    else
      \speed! = 0
      if \ufo_count! = 0 then
        textat 14, 12, "  well done   "
        \level_done! = 1
      else
        \aircraft_mode! = \AIRCRAFT_MODE_REFUEL!
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
        \level_done! = 2
        if \fleet! > 1 then
          textat 12, 12, "    crashed    "
        else
          textat 12, 12, "   game over   "
        endif
      endif
    endif
    \aircraft_altitude = \aircraft_altitude + 4
    return
  
  draw_fuel:
    
    
    offset! = rshift!(\fuel!, 2)
    if offset! = 0 then return
    poke 1065 + offset!, $3b
    poke 1105 + offset!, $a0
    poke 1145 + offset!, $3c
    return
    
  erase_fuel:
    offset! = rshift!(\fuel!, 2)
    poke 1066 + offset!, $20
    poke 1106 + offset!, $20
    poke 1146 + offset!, $20
    return
endproc