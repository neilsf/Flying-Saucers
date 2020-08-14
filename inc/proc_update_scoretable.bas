proc update_scoretable
  if \fleet! < 10 then
    poke 1175, 48
    textat 31, 3, \fleet!
  else
    textat 30, 3, \fleet!
  endif
  if \ufo_count! < 10 then
    poke 1179, 48
    textat 35, 3, \ufo_count!
  else
    textat 34, 3, \ufo_count!
  endif
  
  if \hiscore < \score then \hiscore = \score
  
  textat 2, 3, \score
  rem curpos 2, 3 : print "{GREEN}";
  rem if \score < 10   then print "000", \score; : poke 53280, 2 : goto print_hi
  rem if \score < 100  then print "00", \score; : goto print_hi
  rem if \score < 1000 then print "0", \score; : goto print_hi
  rem print \score;
  
  print_hi:
  
  textat 7, 3, \hiscore
  rem curpos 7, 3: print "{RED}";
  rem if \hiscore < 10   then print "000", \hiscore; : poke 53280, 0 : return
  rem if \hiscore < 100  then print "00", \hiscore;: return
  rem if \hiscore < 1000 then print "0", \hiscore; : return
  rem print \hiscore;
  

endproc