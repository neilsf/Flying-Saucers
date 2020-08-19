  poke VIC_CONTROL2, %11001000
  print "{14}{8}"
  print " Welcome to FLYING SAUCERS!"
  print " =========================={13}"
  
  print " In this game you'll control a fighter"
  print " aircraft and your mission is to save"
  print " the city from an alien invasion. The"
  print " command is simple:{13}"
  print " ** Prevent the enemy from landing! **{13}"
  
  print " Gameplay"
  print " --------{13}"
  
  print " The game involves several attack waves"
  print " that slowly get more and more diffi-"
  print " cult. When you destroyed all UFOs in"
  print " an attack wave, you have to return to"
  print " the carrier and prepare for the next"
  print " wave. You'll get one extra aircraft in"
  print " the beginning of each attack wave.{13}"
  
  print " press a key to continue..."
  
  gosub wait_key
  
  print "{147}{13} Controls"
  print " --------{13}"
  
  print " Use joystick in port 1. The take-off"
  print " and landing procedures are done by the"
  print " auto-pilot. After taking off, pull up"
  print " to lift or down to descend. Pull left"
  print " or right to increase or decrease speed"
  print " or make a u-turn. Press fire to launch"
  print " projectile or down + fire to bomb.{13}"
  
  print " To avoid losing the aircraft{13}"
  print " * Do not crash into any objects."
  print " * Return to the carrier when you're"
  print "   low on fuel.{13}"

  print " The game is over when{13}"
  print " * 3 or more UFOs reach the ground, or"
  print " * You lose all your fleet{13}"
  
  print " press a key to continue..."

  gosub wait_key
  
  print "{147}{13} Landing"
  print " -------{13}"
  
  print " Approach the aircraft carrier with low"
  print " speed and on low altitude to initiate"
  print " the landing procedure. If your speed"
  print " and altitude are low enough, the auto-"
  print " pilot will do the landing for you.{13}"
  print " Scoring"
  print " -------{13}"
  print "  1 pt  for each enemy aircraft down"
  print "  2 pts for each successful landing"
  print "  5 pts for each completed level"
  print " +5 pts if level completed without loss{13}"
  print " GOOD LUCK!{13}"
  print " ----------"
  print " SID's used in this title are Black"
  print " Hawk by Creative Sparks and Noice"
  print " Anthem by Jesper Varn (DECODER)"
 

  gosub wait_key
  return
  
  wait_key:
    if inkey!() = 0 then goto wait_key
    return