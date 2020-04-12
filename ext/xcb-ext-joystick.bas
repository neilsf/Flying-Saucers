rem **************************************
rem * XC=BASIC Joystick extension
rem *
rem * by Csaba Fekete
rem *
rem * Namespace: joy_
rem **************************************

rem ************************************
rem * Global constants                 *
rem ************************************
const JOY_PORT2 = $dc00
const JOY_PORT1 = $dc01

rem ***************************************
rem * Helper macros to quickly save/restore
rem * function return address
rem ***************************************

asm "
    MAC joy_saveaddr
    pla
    tax
    pla
    tay
    ENDM

    MAC joy_restoreaddr
    tya
    pha
    txa
    pha
    ENDM
"

rem ******************************
rem * Function
rem * joy_1_up!
rem *
rem ******************************

fun joy_1_up!()
  asm "
    joy_saveaddr
    lda #%00000001
    bit _JOY_PORT1
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_1_down!
rem *
rem ******************************

fun joy_1_down!()
  asm "
    joy_saveaddr
    lda #%00000010
    bit _JOY_PORT1
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_1_left!
rem *
rem ******************************

fun joy_1_left!()
  asm "
    joy_saveaddr
    lda #%00000100
    bit _JOY_PORT1
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_1_right!
rem *
rem ******************************

fun joy_1_right!()
  asm "
    joy_saveaddr
    lda #%00001000
    bit _JOY_PORT1
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_1_fire!
rem *
rem ******************************

fun joy_1_fire!()
  asm "
    joy_saveaddr
    lda #%00010000
    bit _JOY_PORT1
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_2_up!
rem *
rem ******************************

fun joy_2_up!()
  asm "
    joy_saveaddr
    lda #%00000001
    bit _JOY_PORT2
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_2_down!
rem *
rem ******************************

fun joy_2_down!()
  asm "
    joy_saveaddr
    lda #%00000010
    bit _JOY_PORT2
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_2_left!
rem *
rem ******************************

fun joy_2_left!()
  asm "
    joy_saveaddr
    lda #%00000100
    bit _JOY_PORT2
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_2_right!
rem *
rem ******************************

fun joy_2_right!()
  asm "
    joy_saveaddr
    lda #%00001000
    bit _JOY_PORT2
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

rem ******************************
rem * Function
rem * joy_2_fire!
rem *
rem ******************************

fun joy_2_fire!()
  asm "
    joy_saveaddr
    lda #%00010000
    bit _JOY_PORT2
    bne .false
    pone
    jmp .ret
.false
    pzero
.ret
    joy_restoreaddr
    rts
    "
endfun

