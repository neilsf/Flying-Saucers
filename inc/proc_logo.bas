proc logo
  
  poke \VIC_CONTROL2, %11001100
  
  memset \SCREEN, 1000, 32
  memset \COLOR, 1000, 15
  
  rem -- Pages 2 and 3 are unused
  rem -- so we copy the logo sprites
  rem -- to $0200 - $03c0
  memcpy $6400, $0200, 448
  
  spr_setshape 0, 8
  spr_sethires 0
  spr_setpos 0, 130, 124
  spr_setcolor 0, 1
  
  spr_setshape 1, 9
  spr_sethires 1
  spr_setpos 1, 154, 124
  spr_setcolor 1, 1
  
  spr_setshape 2, 13
  spr_sethires 2
  spr_setpos 2, 184, 124
  spr_setcolor 2, 1
  
  spr_setshape 3, 10
  spr_sethires 3
  spr_setpos 3, 194, 124
  spr_setcolor 3, 6
  
  spr_setshape 4, 11
  spr_sethires 4
  spr_setpos 4, 194, 124
  spr_setcolor 4, 1
  
  spr_setshape 5, 12
  spr_sethires 5
  spr_setpos 5, 194, 124
  spr_setcolor 5, 14
  
  spr_setshape 6, 14
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
  
  for i = 0 to 600 : rem 200
    watch \RASTER_POS, 0
  next i
  
  for j! = 0 to 6
    spr_disable j!
  next j!
  
  poke \VIC_CONTROL2, %11001000
  
  textat 16, 13, "       "
  textat 14, 10, "their first"
  textat 16, 12, "release"
  
  for i = 0 to 530 : rem 530
    watch \RASTER_POS, 0
  next i
  
  return
  
endproc