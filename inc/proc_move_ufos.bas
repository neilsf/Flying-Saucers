proc move_ufos
  rem --- check if any ufos have landed
    ufo_landed! = 0
    ''for i! = 0 to 12
    ''  if \ufo_on![i!] = 1 and \ufo_path![i!] >= 150 then ufo_landed! = 1
    ''next i!
    if ufo_landed! = 1 then print "game over" : end
    
endproc