proc update_scoretable
  if \fleet! < 10 then
    poke 1175, 48
    textat 31, 3, \fleet!
  else
    textat 30, 3, \fleet!
  endif
  if \ufo_count! < 10 then
    poke 1180, 48
    textat 35, 3, \ufo_count!
  else
    textat 34, 3, \ufo_count!
  endif
endproc