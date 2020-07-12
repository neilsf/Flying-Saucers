proc configure_sprites

  ; global
  
  \spr_multicolor1! = 11
  \spr_multicolor2! = 1
  
  ; aircraft

  spr_setmulti 7
  spr_setcolor 7, 5
  spr_setshape 7, 195
  spr_setposx 7, 173
  spr_setposy 7, 212
  spr_disable 7
  spr_overbg 7

  ; ufos

  for i! = 0 to 3
    spr_setmulti i!
    spr_setcolor i!, 2
    spr_setshape i!, 160
    spr_disable i!
  next

  ; bullet

  spr_setmulti 6
  spr_setcolor 6, 3
  spr_setshape 6, 222
  spr_disable 6

  ; radar rule
  
  spr_sethires 5
  spr_setcolor 5, 5
  spr_setshape 5, 228
  spr_setdblheight 5
  spr_setposx 5, 176
  spr_setposy 5, 58
  spr_enable 5
  
  
endproc
