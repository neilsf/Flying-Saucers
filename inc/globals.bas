const CITY_MAP = $4000

const CITY_MAP_DEFAULT_PTR_LEFT = $517f
const CITY_MAP_DEFAULT_PTR_RIGHT = $52b8

const CITY_MAP_FIRST_PTR_LEFT = $4007
const CITY_MAP_FIRST_PTR_RIGHT = $4138

const CITY_MAP_LAST_PTR_LEFT = $3ec7
const CITY_MAP_LAST_PTR_RIGHT = $4000

const CITY_MAP_PTR_RIGHT_END = $5530
const CITY_MAP_PTR_LEFT_END  = $53ff

rem -- turning points where pointers must
rem -- be reset
const CITY_MAP_PTR_TP_RIGHT = $5400
const CITY_MAP_PTR_TP_LEFT  = $3fff

const CITY_MAP_RIGHT_TP_LEFT = $3ff8

const CITY_MAP_PTR_TP_LAST_R = $53f8

const VIC_CTR_DEFAULT! = %11010000
const VIC_CTR_HIRES!   = %11000000
const VIC_CONTROL1 = $d011
const VIC_CONTROL2 = $d016
const RASTER_POS = $d012
const VIC_MEMSETUP = $d018
const VIC_BORDER = $d020
const VIC_BACKGR = $d021

const CIA2_PRA = $dd00

const SCROLL_AREA_TOP = 1664

const SCROLL_SHIFT_START = 1665
const SCROLL_AREA_BOTTOM = 1983
const SCROLL_AREA_SIZE = 319
const RIGHT_COLUMN_TOP = 1703
const RIGHT_COLUMN_BOTTOM = 1983

const LEFT_COLUMN_BOTTOM = 1944

const SCREEN = $0400
const COLOR = $d800

first_run! = 1

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
let aircraft_xpos = 4640
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
dim attack_wave_radar_pos[4,13]

dim spr_to_ufo![3]

let bullet_on! = 0
let bullet_xpos = 0
let bullet_ypos! = 0
let bullet_dy! = 0
let bullet_dir! = 1

const AIRCRAFT_MODE_TAXI! = 0
const AIRCRAFT_MODE_REFUEL! = 1
const AIRCRAFT_MODE_TAKE_OFF! = 2
const AIRCRAFT_MODE_LANDING! = 3
const AIRCRAFT_MODE_NOSEDIVING! = 4

aircraft_mode! = AIRCRAFT_MODE_TAXI!
fuel! = 0
