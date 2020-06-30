rem --------------------------------------
rem -- Screen shifting routines
rem --
rem -- These routines shift the
rem -- screen left or right by one column
rem --------------------------------------

proc shift_left
    
  loc = \RIGHT_COLUMN_TOP
  
  for i! = 0 to 7
    poke loc, peek!(\city_map_ptr_right)
    loc = loc + 40
    inc \city_map_ptr_right
    inc \city_map_ptr_left
  next i!
  
  memcpy \SCROLL_SHIFT_START, \SCROLL_AREA_TOP, \SCROLL_AREA_SIZE
  
  if \city_map_ptr_right = \CITY_MAP_PTR_TP_RIGHT then
    \city_map_ptr_right = \CITY_MAP
  endif
  
  if \city_map_ptr_left = \CITY_MAP_PTR_LEFT_END then
    \city_map_ptr_left = \CITY_MAP_FIRST_PTR_LEFT
  endif

endproc

proc shift_right
    
  memshift \SCROLL_AREA_TOP, \SCROLL_SHIFT_START, \SCROLL_AREA_SIZE
  loc = \LEFT_COLUMN_BOTTOM
  
  for i! = 0 to 7
    poke loc, peek!(\city_map_ptr_left)
    loc = loc - 40
    dec \city_map_ptr_left
    dec \city_map_ptr_right
  next i!
  
  if \city_map_ptr_left = \CITY_MAP_PTR_TP_LEFT then
    \city_map_ptr_left  = \CITY_MAP_PTR_LEFT_END
  endif
  
  if \city_map_ptr_right = \CITY_MAP_RIGHT_TP_LEFT then
    \city_map_ptr_right = \CITY_MAP_PTR_TP_LAST_R 
  endif
    
endproc
