proc logo
  
  poke \VIC_CONTROL2, \VIC_CTR_HIRES!
  
  memset \SCREEN, 1000, 32
  memset \COLOR, 1000, 15
  
  spr_setshape 0, 242
  spr_sethires 0
  spr_setpos 0, 130, 124
  spr_setcolor 0, 1
  
  spr_setshape 1, 243
  spr_sethires 1
  spr_setpos 1, 154, 124
  spr_setcolor 1, 1
  
  spr_setshape 2, 247
  spr_sethires 2
  spr_setpos 2, 184, 124
  spr_setcolor 2, 1
  
  spr_setshape 3, 244
  spr_sethires 3
  spr_setpos 3, 194, 124
  spr_setcolor 3, 6
  
  spr_setshape 4, 245
  spr_sethires 4
  spr_setpos 4, 194, 124
  spr_setcolor 4, 1
  
  spr_setshape 5, 246
  spr_sethires 5
  spr_setpos 5, 194, 124
  spr_setcolor 5, 14
  
  spr_setshape 6, 248
  spr_sethires 6
  spr_setpos 6, 219, 124
  spr_setcolor 6, 1
  
  for j! = 0 to 6
    spr_enable j!
  next j!
    
  textat 16, 13, "present"
  
  \ri_isr_count! = 1
  ri_set_isr 0, @music_player, 250
  sys $5443
  ri_on
  
  gosub calculate_ufo_paths
  
  for i = 0 to 250
    watch \RASTER_POS, 0
  next i
  
  for j! = 0 to 6
    spr_disable j!
  next j!
  
  textat 16, 13, "       "
  textat 14, 10, "their first"
  textat 16, 12, "release"
  
  for i = 0 to 530
    watch \RASTER_POS, 0
  next i
  
  return
  
  calculate_ufo_paths:
    radar_pos = 1076
    for path_no! = 0 to 12
      x = path_start[path_no!]
      index! = 0
      for y! = 84 to 120
        x = x - 3
        gosub add_to_attack_wave
      next y!
      for y! = 121 to 157
        x = x + 3
        gosub add_to_attack_wave
      next y!
      for y! = 158 to 194
        x = x - 3
        gosub add_to_attack_wave
      next y!
      for y! = 195 to 232
        x = x + 3
        gosub add_to_attack_wave
      next y!
      for j! = 0 to 3
        \attack_wave_radar_pos[j!, path_no!] = radar_pos
        radar_pos = radar_pos + 40
      next j!
      radar_pos = radar_pos + 79
    next path_no!
    return
    
    add_to_attack_wave:
      \attack_wave_x[index!, path_no!] = x
      \attack_wave_y![index!, path_no!] = y!
      inc index!
      return
  
  data path_start[] = 172, 492, 812, 1132, 1452, 1772, 2092, 2412, 2732, 3052, 3372, 3692, 4012
endproc