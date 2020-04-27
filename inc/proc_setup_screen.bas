rem -------------------
rem -- Sets up the main screen
rem --
rem -- @param byte draw_background!
rem -- Sets whether the background is to be drawn
rem ------------------.

proc setup_screen(draw_background!)
  memset \SCREEN, 1000, 32
  memset \SCREEN + 24 * 40, 40, 32 + 128

  memset \COLOR, 200, 5
  
  poke 55338, 2 : poke 55378, 2 : poke 55418, 2
  poke 55339, 7 : poke 55379, 7 : poke 55419, 7
  poke 55340, 7 : poke 55380, 7 : poke 55420, 7

  length = 200 + draw_background! * 440
  memcpy @dashboard!, \SCREEN, length
  
  if draw_background! = 1 then
    memset \COLOR + 200, 440, 9
  endif
  
  for i! = 0 to 199
    poke \SCREEN + i!, dashboard![i!]
  next i!
  
  for n = \SCROLL_AREA_TOP to \SCROLL_AREA_BOTTOM
    poke n, 90
  next n

  loc = \CITY_MAP_DEFAULT_PTR_LEFT + 1
  for col! = 0 to 39
    for i! = 16 to 23
      poke 1024 + i! * 40 + col!, peek!(loc)
      inc loc
    next i!
  next col!
  
  data dashboard![] = ~
    32, 200,201, 61,184,185,186,195, 62,201,203,200,201,201,201,201,201, 61,187,188,189,190, 62,201,201,201,201,201,203,200,201, 61,191,192,193,194, 62,201,203, 32, ~
    32, 199, 32, 32, 32, 32, 32, 32, 32, 32,206,199, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,206,199,182,176, 32, 32, 32, 32, 32, 32,206, 32, ~
    32, 199, 32, 32, 32, 32, 32, 32, 32, 32,206,199, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,206,199,183,177,163,164,150,151,166,167,206, 32, ~
    32, 199, 32, 32, 32, 32, 32, 32, 32, 32,206,199, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, $3b, 32,206,199, 32, 48, 48, 32, 32, 48, 48, 32,206, 32, ~
    32, 205,204,204,204,204,204,204,204,204,207,205,204,204,204,204,204,204,204,204,204,204,204,204,204,204,204,204,207,205,204,204,204,204,204,204,204,204,207, 32

  data background_graphics![] = ~
    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,211, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,210, 32, 32, 32, 32, ~
    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,211, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, ~
    32,211, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,227,228,229,231, 32, ~
    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 210, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,243,244,245,246, 32, ~
    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,152,153,154,158, 32, ~
    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,238,239,254,255, 32, ~
    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, ~
    32, 32, 32, 32, 32, 32, 32,211, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,210, 32, 32, 32, 32, 32, 32, 32, 32, ~
    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,210, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,211, 32, 32, 32, ~
    32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 211,32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, ~
    32, 32, 32,210, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32
    
endproc
