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
'let aircraft_relxpos = 160
rem -- these are actual sprite y positions
dim ufo_altitude![13]
dim ufo_xpos[13]
dim ufo_on![13]
dim ufo_hit![13]
dim ufo_animphase![13]
dim ufo_path![13]
dim ufo_wave![13]

dim attack_wave_y![150,13]
dim attack_wave_x[150,13]
dim attack_wave_radar_pos[10,13]
dim attack_wave_radar_shape![10,13]

dim spr_to_ufo![3]

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

dim attack_wave_index
dim ufo_timer
dim nxt_attack_wave_pos!
; ufo count per attack wave
; [timing, attack_wave_position (0-12)]*

data attack_wave_1[] = 2,   150, 3,   250, 6
data attack_wave_2[] = 3,   150, 3,   250, 6,   250, 4