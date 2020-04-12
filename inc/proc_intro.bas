proc intro

  if \first_run! = 1 and \debug! = 0 then
    call logo
  endif

  \first_run! = 0
  
  poke \VIC_CONTROL1, peek!(\VIC_CONTROL1) & %11101111
  
  poke \VIC_CONTROL2, \VIC_CTR_DEFAULT!
  call setup_screen(0)
  
  textat 13, 6, "flying saucers"

  textat 7,  9, "code & sfx    csaba fekete"
  textat 7, 11, "graphics     daniel fekete"
  textat 7, 14, "press fire button to start"
  textat 14,21, "  "
  textat 12,19, " "
  textat  6,20, " "

  memset \COLOR + 240, 40, 2
  memset \COLOR + 360, 160, 5
  memset \COLOR + 560, 40, 2
  memset \COLOR + 640, 360, 14
  
  poke \VIC_CONTROL1, peek!(\VIC_CONTROL1) | %00010000
  
  animphase! = 0
  landing_bacon_animphase! = 0
  helicopter_animphase! = 0
  aircraft_posx = 134
  aircraft_posy! = 222
  aircraft_dir = 0
  helicopter_posx = 160
  
  rem -- helicopter
  
  spr_setmulti 2
  spr_setcolor 2, 5
  spr_setshape 2, 236
  spr_enable 2
  spr_setpos 2, helicopter_posx, 166
  
  rem -- guy with beacon
  
  spr_setmulti 6
  spr_setcolor 6, 5
  spr_setshape 6, 232
  spr_enable 6
  spr_setpos 6, 196, 205
  
  rem -- aircraft
  
  spr_setshape 7, 221
  spr_setposx 7, aircraft_posx
  spr_setposy 7, aircraft_posy!
  spr_behindbg 7
  spr_enable 7
  
  rem -- radars
  
  spr_setmulti 0
  spr_setcolor 0, 5
  spr_setshape 0, 234
  spr_enable 0
  spr_setpos 0, 120, 189
  
  spr_setmulti 1
  spr_setcolor 1, 5
  spr_setshape 1, 234
  spr_enable 1
  spr_setpos 1, 72, 197
  
  wait_loop:
    watch \RASTER_POS, 0
    
    spr_setshape 2, helicopter_anim![helicopter_animphase!]
    inc helicopter_animphase!
    if helicopter_animphase! = 6 then helicopter_animphase! = 0
    
    
    if animphase! & %00000001 = 0 then
      dec helicopter_posx
      if helicopter_posx < 30 then helicopter_posx = 380
      spr_setposx 2, helicopter_posx 
    endif
    
    if animphase! & %00000011 = 0 then
      spr_setshape 0, radar_anim![landing_bacon_animphase!]
      spr_setshape 1, radar_anim![landing_bacon_animphase!]
      
      inc landing_bacon_animphase!
      if landing_bacon_animphase! = 8 then landing_bacon_animphase! = 0
      
      ''if aircraft_dir = 2 then
      spr_setshape 6, landing_bacon_anim![landing_bacon_animphase!]
    
    endif
  
    if animphase! = 250 and aircraft_dir = 0 then aircraft_dir = 1
  
    if animphase! & %00000111 = 0 and aircraft_dir > 0 then
      if aircraft_dir = 1 then
        dec aircraft_posy!
        spr_setposy 7, aircraft_posy!
        if aircraft_posy! = 212 then inc aircraft_dir
      else  
        if aircraft_dir = 2 then
          if aircraft_posx < 173 then inc aircraft_posx else inc aircraft_dir
          spr_setposx 7, aircraft_posx
        endif
      endif
    endif
    
    inc animphase!
    if joy_1_fire!() = 0 then goto wait_loop
    
  
  exit_intro:
    ri_off
    spr_disable 1
    spr_disable 2
    spr_disable 6
    call configure_sprites
    return
      
  data title_line1![] = $ed, $ea, $e7, $20, $eb, $ec, $20, $e8, $e5, $e6, $e5, $ea, $20, $20, $ed, $ef, $ed, $ee, $e7, $e8, $e5, $ea, $ed, $ea, $e5, $ea, $ed, $ef
  data title_line2![] = $fb, $20, $f5, $fa, $20, $fc, $20, $f8, $f7, $f8, $f5, $f6, $20, $20, $ff, $fe, $fb, $fc, $f5, $f6, $f5, $fa, $fd, $fa, $f7, $20, $ff, $fe
  
  data helicopter_anim![] = 236, 237, 238, 239, 240, 241
  data landing_bacon_anim![] = 229, 230, 231, 232, 233, 232, 231, 230
  data radar_anim![] = 234, 235, 234, 235, 234, 235, 234, 235, 234
  
endproc
