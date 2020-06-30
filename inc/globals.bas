rem -- Global variables

first_run! = 1

dim city_map_ptr_left fast
dim city_map_ptr_right fast

let city_map_ptr_right = CITY_MAP_DEFAULT_PTR_RIGHT
let city_map_ptr_left  = CITY_MAP_DEFAULT_PTR_LEFT

let speed! = 1
let dir! = 1
let frame_count! = 0
let scroll! = 0

rem -- aircraft status
rem -- 0: flying
rem -- 1: turning R-L
rem -- 2: turning L-R
rem -- 3: take off
rem -- 4: landing
rem --

let turning! = 0

rem -- 0: no turning, 1: lifting, 2: falling
let lifting! = 0

let turn_phase! = 0
let turn_phase_count! = 0

rem -- always divided by 4 to get sprite y pos
let aircraft_altitude = 848
let aircraft_xpos = 2560
let aircraft_zone! = 14

rem -- these are actual sprite y positions
dim ufo_altitude![4]
dim ufo_xpos[4]
dim ufo_on![4]
dim ufo_hit![4]
dim ufo_animphase![4]

let bullet_on! = 0
let bullet_xpos = 0
let bullet_ypos! = 0
let bullet_dy! = 0
let bullet_speed! = 0
dim bullet_sound_freq
dim bullet_sound_step
dim sound_counter!
rem -- 0 = left 1 = right 2 = left bomb 3 = right bomb
let bullet_dir! = 1

aircraft_mode! = AIRCRAFT_MODE_TAXI!
fuel! = 0

let wave! = 1

dim fleet! : dim ufo_count! : dim ufos_killed : dim level_done!
dim microspeed!