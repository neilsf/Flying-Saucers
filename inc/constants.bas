rem -- Hardware I/O stuff
rem --

const VIC_CTR_DEFAULT! = %11010000
const VIC_CTR_HIRES!   = %11000000
const VIC_CONTROL1 = $d011
const VIC_CONTROL2 = $d016
const RASTER_POS = $d012
const VIC_MEMSETUP = $d018
const VIC_BORDER = $d020
const VIC_BACKGR = $d021

const CIA2_PRA = $dd00

const SID_VOLUME = $d418

const SID_CTRL1 = $d404
const SID_AD1 = $d405
const SID_SR1 = $d406

const SID_CTRL2 = $d40b
const SID_AD2 = $d40c
const SID_SR2 = $d40d
const SID_FREQ2 = $d407

const SID_CTRL3 = $d412
const SID_AD3 = $d413
const SID_SR3 = $d414
const SID_FREQ3 = $d40e

const SCREEN = $0400
const COLOR = $d800

rem -- The following constants are
rem -- are pointers to memory locations
rem -- required when drawing the city map

const CITY_MAP = $4000

''const CITY_MAP_DEFAULT_PTR_LEFT = $517f
''const CITY_MAP_DEFAULT_PTR_RIGHT = $52b8

const CITY_MAP_DEFAULT_PTR_LEFT = $495f
const CITY_MAP_DEFAULT_PTR_RIGHT = $4a98

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

const SCROLL_AREA_TOP = 1664

const SCROLL_SHIFT_START = 1665
const SCROLL_AREA_BOTTOM = 1983
const SCROLL_AREA_SIZE = 319
const RIGHT_COLUMN_TOP = 1703
const RIGHT_COLUMN_BOTTOM = 1983

const LEFT_COLUMN_BOTTOM = 1944

rem -- Aircraft statuses

const AIRCRAFT_MODE_TAXI! = 0
const AIRCRAFT_MODE_REFUEL! = 1
const AIRCRAFT_MODE_TAKE_OFF! = 2
const AIRCRAFT_MODE_LANDING! = 3
const AIRCRAFT_MODE_NOSEDIVING! = 4
const AIRCRAFT_MODE_SCROLLING_TO_UFO! = 5
