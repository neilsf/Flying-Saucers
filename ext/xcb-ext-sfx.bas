rem **************************************
rem * XC=BASIC SFX extension
rem *
rem * by Csaba Fekete
rem *
rem * Namespace: sfx_
rem *
rem * The assembly routines in the work are
rem * taken from Martin Piper's SFX routine
rem * found at
rem *
rem * https://github.com/martinpiper/C64Public/tree/master/SFX
rem *
rem * with slight modifications
rem **************************************

const SFX_SID       				      = $D400
const SFX_SIDVOICE1FREQLO			    = $D400
const SFX_SIDVOICE1FREQHI			    = $D401
const SFX_SIDVOICE1PULSEWIDTHLO	  = $D402
const SFX_SIDVOICE1PULSEWIDTHHI	  = $D403
const SFX_SIDVOICE1CONTROL		    = $D404
const SFX_SIDVOICE1ATTACKDECAY	  = $D405
const SFX_SIDVOICE1SUSTAINRELEASE = $D406
const SFX_SIDVOICE2FREQLO			    = $D407
const SFX_SIDVOICE2FREQHI			    = $D408
const SFX_SIDVOICE2PULSEWIDTHLO	  = $D409
const SFX_SIDVOICE2PULSEWIDTHHI	  = $D40A
const SFX_SIDVOICE2CONTROL		    = $D40B
const SFX_SIDVOICE2ATTACKDECAY	  = $D40C
const SFX_SIDVOICE2SUSTAINRELEASE	= $D40D
const SFX_SIDVOICE3FREQLO			    = $D40E
const SFX_SIDVOICE3FREQHI			    = $D40F
const SFX_SIDVOICE3PULSEWIDTHLO	  = $D410
const SFX_SIDVOICE3PULSEWIDTHHI	  = $D411
const SFX_SIDVOICE3CONTROL		    = $D412
const SFX_SIDVOICE3ATTACKDECAY	  = $D413
const SFX_SIDVOICE3SUSTAINRELEASE	= $D414
const SFX_SIDFILTERCUTOFFFREQLO	  = $D415
const SFX_SIDFILTERCUTOFFFREQHI	  = $D416
const SFX_SIDFILTERCONTROL		    = $D417
const SFX_SIDVOLUMEFILTER			    = $D418
const SFX_SIDVOICE3WAVEFORMOUTPUT	= $D41B
const SFX_SIDVOICE3ADSROUTPUT		  = $D41C
const SFX_VOICEWORKSIZE!		      = 13

proc sfx_init(addr, reserve_voice3!)

  asm "  
    lda {self}.addr
    sta sfx_table_inst + 1
    lda {self}.addr + 1
    sta sfx_table_inst + 2
    lda {self}.reserve_voice3
    sta SFX_LimitVoice3

    jmp .init
    ; Variables
    
SFX_CurrentVoice      DC.B 0	
  ; Define the first voice
SFX_VoiceControl 		  DC.B 0
SFX_VoiceAttackDecay 	DC.B 0
SFX_VoiceFreqLo 			DC.B 0
SFX_VoiceFreqHi 			DC.B 0
SFX_VoiceFreqLoSpeed 	DC.B 0
SFX_VoiceFreqHiSpeed2 DC.B 0
SFX_VoiceFreqDecay 		DC.B 0
SFX_VoiceFreqLoSpeed2 DC.B 0
SFX_VoiceFreqHiSpeed 	DC.B 0
SFX_VoiceFreqHiCountInit DC.B 0
SFX_VoiceFreqDirection 	DC.B 0
SFX_VoiceFreqHiCount 	DC.B 0
SFX_VoiceTotalCount 	DC.B 0
  ; Use filled space for the other two voices
SFX_Voice23				    DS.B 26
SFX_TempVar 				  DC.B 0
SFX_MulBy7Tab 			  HEX 00 07 0E
SFX_tmp					      SET 0
SFX_MulBy10Tab			  REPEAT 24
                      DC.B SFX_tmp
SFX_tmp					      SET SFX_tmp + 10
                      REPEND
SFX_IndexToWorkVoiceTab
                      HEX 00 0D 1A
; Flag set to 1 if channel 3 should be reserved
SFX_LimitVoice3			  DC.B 0
    
    ; ----------------------------------
    ; -- INITIALIZE SID
    ; ----------------------------------
.init
    ldx #$16
    lda #$00
    sta SFX_CurrentVoice
.l1
    sta _SFX_SID,x
    dex
    bpl .l1
    ldx #(_SFX_VOICEWORKSIZE * 3) - 1
.l2
    sta SFX_VoiceControl,x
    dex
    bpl .l2

    lda #$08
    sta _SFX_SIDVOICE1CONTROL
    sta _SFX_SIDVOICE2CONTROL
    sta _SFX_SIDVOICE3CONTROL
    lda #$07
    sta _SFX_SIDVOICE1PULSEWIDTHHI
    sta _SFX_SIDVOICE2PULSEWIDTHHI
    sta _SFX_SIDVOICE3PULSEWIDTHHI
    lda #$0f
    sta _SFX_SIDVOLUMEFILTER
    lda #0
    sta _SFX_SIDFILTERCONTROL
    rts
  "
endproc

proc sfx_start(effect_no!)

  asm "
    	stx .xTemp
      sty .yTemp
      ; Convert the index into an offset
      lda {self}.effect_no
      tax
      ldy SFX_MulBy10Tab,x
      ; Find a new SID voice by picking the voice with the lowest remaining SFXVoiceTotalCount
      ldx #0
      lda SFX_VoiceTotalCount
      cmp SFX_VoiceTotalCount + _SFX_VOICEWORKSIZE
      bcc .not2
      ldx #1
      lda SFX_VoiceTotalCount + _SFX_VOICEWORKSIZE
.not2
      ;lda SFX_LimitVoice3
      ;beq .not3
      ;cmp SFX_VoiceTotalCount + [_SFX_VOICEWORKSIZE * 2]
      ;bcc .not3
      ;ldx #2
.not3
      ; Store what we have chosen
      stx SFX_CurrentVoice

      ; Now retire the values by one ready for next time
      lda SFX_VoiceTotalCount
      beq .no1
      dec SFX_VoiceTotalCount
.no1
      lda SFX_VoiceTotalCount + _SFX_VOICEWORKSIZE
      beq .no2
      dec SFX_VoiceTotalCount + _SFX_VOICEWORKSIZE
.no2
      lda SFX_VoiceTotalCount + [_SFX_VOICEWORKSIZE * 2]
      beq .no3
      dec SFX_VoiceTotalCount + [_SFX_VOICEWORKSIZE * 2]
.no3
      ; Fetch the SID voice offset adjustment
      lda SFX_MulBy7Tab,x
      tax
      ; Initialise the SID voice
      lda #$00
      sta _SFX_SIDVOICE1ATTACKDECAY,x
      sta _SFX_SIDVOICE1SUSTAINRELEASE,x
      sta _SFX_SIDVOICE1CONTROL,x
      ; Copy the SFX from the table to our work space for the voice
      ldx SFX_CurrentVoice
      ; Multiply by 12, convert the index to an offset
      lda SFX_IndexToWorkVoiceTab,x
      tax
      ; Copy the ten bytes of SFX table data
      lda #$0A
      sta SFX_TempVar
.l1
sfx_table_inst
      ; Self modified
      lda $0000,y
      sta SFX_VoiceControl,x
      inx
      iny
      dec SFX_TempVar
      bne .l1
      lda #$00
      ; All of these use -10 because X has just copied 10 bytes
      sta SFX_VoiceFreqDirection-10,x
      ; Copy the initial values to higher up
      lda SFX_VoiceFreqDecay-10,x
      sta SFX_VoiceFreqHiCount-10,x
      bne .noMoreUpdates
      lda SFX_VoiceFreqHiCountInit-10,x
      sta SFX_VoiceFreqHiCount-10,x
      inc SFX_VoiceFreqDirection-10,x
.noMoreUpdates
      ; Work out roughly how long the effect will last for priority evaluation by summing the
      ; attack and decay.
      lda SFX_VoiceAttackDecay-10,x
      lsr
      lsr
      lsr
      lsr
      sta SFX_TempVar
      lda SFX_VoiceAttackDecay-10,x
      and #15
      clc
      adc SFX_TempVar
      ; Slightly longer delay, carry will always be clear here
      asl
      ; Always add three so that the priority picks the next one if the attack/decay is really tiny.
      adc #3
      sta SFX_VoiceTotalCount-10,x
      ldx .xTemp
      ldy .yTemp
      rts
	
.xTemp DC.B 0
.yTemp DC.B 0
  "
endproc

proc sfx_play
  asm "
    ; ----------------------------------
    ; -- THE ACTUAL PLAY ROUTINE
    ; ----------------------------------
    
    ; Update the pulse according to the toggle
    lda .pulseToggle
    bne .doDecPulse
    ; Inc pulse
    lda .pulseWidthLo
    clc
    adc #$50
    sta .pulseWidthLo
    bcc .processVoices
    inc .pulseWidthHi
    lda .pulseWidthHi
    cmp #$05
    bne .processVoices
    lda #$01
    sta .pulseToggle
    bne .processVoices
.doDecPulse
    ; Dec pulse
    lda .pulseWidthLo
    sec
    sbc #$50
    sta .pulseWidthLo
    bcs .processVoices
    dec .pulseWidthHi
    lda .pulseWidthHi
    cmp #$02
    bne .processVoices
    lda #$00
    sta .pulseToggle
.processVoices
    ldy #$00
    ldx #$00
    jsr .processOneVoice
    ldy #$07
    ldx #_SFX_VOICEWORKSIZE
    ;lda SFX_LimitVoice3
    ;beq .skip
    ;jsr .processOneVoice
    ;ldy #$0E
    ;ldx #[_SFX_VOICEWORKSIZE * 2]
.skip
.processOneVoice
    ; Not likely to be any frequency changes so don't run the code, just update the SID voice instead
    lda SFX_VoiceFreqDecay,x
    ora SFX_VoiceFreqHiCountInit,x
    beq .noUpdates
    ; Process the direction
    lda SFX_VoiceFreqDirection,x
    bne .downWibble
    ; Incr
    lda SFX_VoiceFreqLo,x
    clc
    adc SFX_VoiceFreqLoSpeed,x
    sta SFX_VoiceFreqLo,x
    bcc .noCarry1
    inc SFX_VoiceFreqHi,x
.noCarry1
    ; Incr 2
    lda SFX_VoiceFreqHi,x
    clc
    adc SFX_VoiceFreqHiSpeed2,x
    sta SFX_VoiceFreqHi,x
    dec SFX_VoiceFreqHiCount,x
    bne .noUpdates
.freqProcess
    lda SFX_VoiceFreqHiCountInit,x
    sta SFX_VoiceFreqHiCount,x
    beq .freqReset
    ; Swap the direction
    lda #$01
    sta SFX_VoiceFreqDirection,x
    bne .noUpdates
.downWibble
    ; Decr
    lda SFX_VoiceFreqLo,x
    sec
    sbc SFX_VoiceFreqLoSpeed2,x
    sta SFX_VoiceFreqLo,x
    bcs .freqHiAdjust
    dec SFX_VoiceFreqHi,x
.freqHiAdjust
    ; Decr 2
    lda SFX_VoiceFreqHi,x
    sec
    sbc SFX_VoiceFreqHiSpeed,x
    sta SFX_VoiceFreqHi,x
    dec SFX_VoiceFreqHiCount,x
    bne .noUpdates
.freqReset
    lda SFX_VoiceFreqDecay,x
    sta SFX_VoiceFreqHiCount,x
    beq .freqProcess
    ; Swap the direction
    lda #$00
    sta SFX_VoiceFreqDirection,x
.noUpdates
    ; Update SID from our calculated data
    lda SFX_VoiceFreqLo,x
    sta _SFX_SIDVOICE1FREQLO,y
    lda SFX_VoiceFreqHi,x
    sta _SFX_SIDVOICE1FREQHI,y
    lda SFX_VoiceAttackDecay,x
    sta _SFX_SIDVOICE1ATTACKDECAY,y
    lda SFX_VoiceControl,x
    sta _SFX_SIDVOICE1CONTROL,y
    lda .pulseWidthLo
    sta _SFX_SIDVOICE1PULSEWIDTHLO,y
    lda .pulseWidthHi
    sta _SFX_SIDVOICE1PULSEWIDTHHI,y
    rts
	
.pulseWidthLo DC.B 0
.pulseWidthHi DC.B 0
.pulseToggle  DC.B 0
  "
endproc