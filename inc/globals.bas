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
let score = 0

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

rem -- predefined attack waves: 8 patterns x 8 speed changes
dim ufo_attack_wave_xspeed[8,8]
dim ufo_attack_wave_yspeed![8,8]
rem -- ufos appear at this x positions
data initial_ufo_posx[] = 160, 480, 800, 1120, 1440, 1760, 2080, 2400, 2720, 3040, 3360, 3680, 4000, 4320, 4640, 4960


data ufo_radar_posx[] = 128, 128, 124, 124, 127, 128, 125, 124, ~
                        136, 136, 132, 132, 135, 136, 133, 132

data ufo_radar_posy![]= 76, 72, 71, 67, 67, 62, 62, 58, ~
                        76, 72, 71, 67, 67, 62, 62, 58

let wave_countdown! = 8

rem -- the current wave pattern of visible ufos
dim ufo_wave_select![4]
rem -- the current speed of visible ufos
dim ufo_current_xspeed[4]
dim ufo_current_yspeed![4]


const LEVEL_COUNT = 1
rem -- 1st number: no of waves in a level
rem -- 2nd number: no of ufos in a level
rem -- consecutive numbers (group of 4): no of attack wave
rem -- pattern for each ufos (255: no ufo)
data levels![] = 3, 3,   255, 255, 255, 0,    255, 255, 255, 3 ,   255, 255, 255, 5

rem -- pointer to the elements of the above array
dim attack_wave_index
rem -- wave counter within a level
dim no_of_waves!
rem -- ufo counter within a wave
dim no_of_ufos_in_this_wave!
                 
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

dim fleet! : dim ufo_count! : dim ufos_killed : dim level_done! : dim wave!
dim microspeed!