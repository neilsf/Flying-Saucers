rem **************************************
rem * XC=BASIC Sprite extension
rem *
rem * by Csaba Fekete
rem *
rem * Namespace: spr_
rem **************************************

const SPR_ENABLE        = $d015 
const SPR_X_COORD0      = $d000
const SPR_Y_COORD0      = $d001
const SPR_X_COORD1      = $d002
const SPR_Y_COORD1      = $d003
const SPR_X_COORD2      = $d004
const SPR_Y_COORD2      = $d005
const SPR_X_COORD3      = $d006
const SPR_Y_COORD3      = $d007
const SPR_X_COORD4      = $d008
const SPR_Y_COORD4      = $d009
const SPR_X_COORD5      = $d00a
const SPR_Y_COORD5      = $d00b
const SPR_X_COORD6      = $d00c
const SPR_Y_COORD6      = $d00d
const SPR_X_COORD7      = $d00e
const SPR_Y_COORD7      = $d00f
const SPR_X_COORD_MSB   = $d010
const SPR_MULTICOLOR    = $d01c
const SPR_MCOLOR1       = $d025
const SPR_MCOLOR2       = $d026
const SPR_EXP_X         = $d01d
const SPR_EXP_Y         = $d017
const SPR_DATA_PRIO     = $d01b
const SPR_SPR_COLL      = $d01e
const SPR_DATA_COLL     = $d01f
const SPR_COLOR0        = $d027
const SPR_COLOR1        = $d028
const SPR_COLOR2        = $d029
const SPR_COLOR3        = $d02a
const SPR_COLOR4        = $d02b
const SPR_COLOR5        = $d02c
const SPR_COLOR6        = $d02d
const SPR_COLOR7        = $d02e
rem !! change this when VIC bank switching is supported !!
const SPR_PTR           = $07f8       

data spr_enable_bits![]  = %00000001, %00000010, %00000100, %00001000, %00010000, %00100000, %01000000, %10000000
data spr_disable_bits![] = %11111110, %11111101, %11111011, %11110111, %11101111, %11011111, %10111111, %01111111

dim spr_multicolor1! @ SPR_MCOLOR1
dim spr_multicolor2! @ SPR_MCOLOR2

rem ******************************
rem * Command
rem * spr_enable
rem * 
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_enable(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_ENABLE
    ora.wx  _spr_enable_bits
    sta     _SPR_ENABLE
  "
endproc

rem ******************************
rem * Command
rem * spr_disable
rem * 
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_disable(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_ENABLE
    and.wx  _spr_disable_bits
    sta     _SPR_ENABLE
  "
endproc

rem ******************************
rem * Command
rem * spr_setposy
rem * 
rem * Arguments:
rem * spr_no! - No of sprite
rem * Y!      - Y coordinate
rem ******************************

proc spr_setposy(spr_no!, y!)
  asm "
    asl     {self}.spr_no
    ldx     {self}.spr_no
    lda     {self}.y
    sta.wx  _SPR_Y_COORD0
  "
endproc

rem ******************************
rem * Command
rem * spr_setposx
rem * 
rem * Arguments:
rem * spr_no! - No of sprite
rem * x       - X coordinate
rem ******************************

proc spr_setposx(spr_no!, x)
  asm "
    lda     {self}.spr_no
    asl
    tax
    lda     {self}.x
    sta.wx  _SPR_X_COORD0
    txa
    lsr
    tax
    lda     {self}.x + 1
    beq     .off
.on
    lda     _SPR_X_COORD_MSB
    ora.wx  _spr_enable_bits
    jmp     .quit
.off
    lda     _SPR_X_COORD_MSB
    and.wx  _spr_disable_bits
.quit
    sta     _SPR_X_COORD_MSB
  "
endproc

rem ******************************
rem * Command
rem * spr_setpos
rem * 
rem * Arguments:
rem * spr_no! - No of sprite
rem * x        - X coordinate
rem * y!       - Y coordinate
rem ******************************

proc spr_setpos(spr_no!, x, y!)
  spr_setposx spr_no!, x
  spr_setposy spr_no!, y!
endproc

rem ******************************
rem * Command
rem * spr_setshape
rem * 
rem * Arguments:
rem * spr_no!  - No of sprite
rem * shape!   - Shape location in RAM
rem ******************************

proc spr_setshape(spr_no!, shape!)
  asm "
    lda     {self}.shape
    ldx     {self}.spr_no
    sta.wx  _SPR_PTR
  "
endproc

rem ******************************
rem * Command
rem * spr_setmulti
rem * 
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_setmulti(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_MULTICOLOR
    ora.wx  _spr_enable_bits
    sta     _SPR_MULTICOLOR
  "
endproc

rem ******************************
rem * Command
rem * spr_sethires
rem * 
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_sethires(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_MULTICOLOR
    and.wx  _spr_disable_bits
    sta     _SPR_MULTICOLOR
  "
endproc

rem ******************************
rem * Command
rem * spr_setcolor
rem * 
rem * Arguments:
rem * spr_no! - No of sprite
rem * color!  - Color
rem ******************************

proc spr_setcolor(spr_no!, color!)
  asm "
    lda     {self}.color
    ldx     {self}.spr_no
    sta.wx  _SPR_COLOR0
  "
endproc

rem ******************************
rem * Command
rem * spr_setdblwidth
rem *
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_setdblwidth(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_EXP_X
    ora.wx  _spr_enable_bits
    sta     _SPR_EXP_X
  "
endproc

rem ******************************
rem * Command
rem * spr_cleardblwidth
rem *
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_cleardblwidth(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_EXP_X
    and.wx  _spr_disable_bits
    sta     _SPR_EXP_X
  "
endproc

rem ******************************
rem * Command
rem * spr_setdblheight
rem *
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_setdblheight(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_EXP_Y
    ora.wx  _spr_enable_bits
    sta     _SPR_EXP_Y
  "
endproc

rem ******************************
rem * Command
rem * spr_cleardblheight
rem *
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_cleardblheight(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_EXP_Y
    and.wx  _spr_disable_bits
    sta     _SPR_EXP_Y
  "
endproc

rem ******************************
rem * Command
rem * spr_behindbg
rem *
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_behindbg(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_DATA_PRIO
    ora.wx  _spr_enable_bits
    sta     _SPR_DATA_PRIO
  "
endproc

rem ******************************
rem * Command
rem * overbg
rem *
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

proc spr_overbg(spr_no!)
  asm "
    ldx     {self}.spr_no
    lda     _SPR_DATA_PRIO
    and.wx  _spr_disable_bits
    sta     _SPR_DATA_PRIO
  "
endproc

rem ******************************
rem * Function
rem * spr_spr_collision
rem *
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

fun spr_spr_collision!(spr_no!)
  result! = 0
  asm "
    lda     _SPR_SPR_COLL
    ldx     {self}.spr_no
    and.wx  _spr_enable_bits
    beq     .1
    lda     #$01
    sta     {self}.result
.1
  "
  return result!
endfun

rem ******************************
rem * Function
rem * spr_data_collision
rem *
rem * Arguments:
rem * spr_no! - No of sprite
rem ******************************

fun spr_data_collision!(spr_no!)
  result! = 0
  asm "
    lda     _SPR_DATA_COLL
    ldx     {self}.spr_no
    and.wx  _spr_enable_bits
    beq     .1
    lda     #$01
    sta     {self}.result
.1
  "
  return result!
endfun