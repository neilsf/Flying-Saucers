rem *****************************************
rem * XC=BASIC Raster interrput extension
rem *
rem * by Csaba Fekete
rem *
rem * Compatible with XC=BASIC v2.2.04 and up
rem * Namespace: ri_
rem *****************************************

const RI_CIA1_ICR	  = $dc0d
const RI_CIA2_ICR	  = $dd0d
const RI_VIC_CTR	  = $d011
const RI_VIC_RASTER = $d012
const RI_VIC_IRQ_R  = $d019
const RI_VIC_IRQ_EN = $d01a

data ri_isr_addr_lo![] = 0, 0, 0, 0, 0, 0, 0, 0
data ri_isr_addr_hi![] = 0, 0, 0, 0, 0, 0, 0, 0
data ri_ras_lo![]      = 0, 0, 0, 0, 0, 0, 0, 0
data ri_ras_hi![]      = 0, 0, 0, 0, 0, 0, 0, 0

ri_isr_count!   = 0
ri_current_isr! = 0
ri_syshandler = $ea31

proc ri_isr_launcher

  asm "
    ldx     _ri_current_isr
    lda.wx  _ri_isr_addr_lo
    sta     .ri_isr_addr + 1
    lda.wx  _ri_isr_addr_hi
    sta     .ri_isr_addr + 2

.ri_isr_addr
    jsr $0000

    ldx     _ri_current_isr
    inx
    cpx     _ri_isr_count
    bne     .set_line
    ldx     #$00

.set_line
  	stx     _ri_current_isr
    ; Set next interrupt line

	  lda.wx  _ri_ras_lo
	  sta     _RI_VIC_RASTER
    lda.wx  _ri_ras_hi
    beq     .clear
    lda     _RI_VIC_CTR
    ora     #%10000000
	  sta     _RI_VIC_CTR
    jmp     .ack
.clear
    lda     _RI_VIC_CTR
    and     #%01111111
	  sta     _RI_VIC_CTR

.ack
	; Acknowledge and let sys handler finish
  	asl _RI_VIC_IRQ_R
    lda _ri_current_isr
    beq .syshandler
    jmp $ea81
.syshandler
    jmp (_ri_syshandler)
  "
endproc

rem ******************************
rem * Command
rem * ri_on
rem *
rem * No args
rem ******************************

proc ri_on
  \ri_current_isr! = 0
  asm "
    sei
    ; disable CIA irqs
	  lda #$7f
	  sta _RI_CIA1_ICR
	  sta _RI_CIA2_ICR
	  lda _RI_CIA1_ICR
	  lda _RI_CIA2_ICR

	  ; Set initial raster line
	  lda _ri_ras_lo
	  sta _RI_VIC_RASTER
    lda _ri_ras_hi
    beq     .clear
    lda     _RI_VIC_CTR
    ora     #%10000000
	  sta     _RI_VIC_CTR
    jmp     .skip
.clear
    lda     _RI_VIC_CTR
    and     #%01111111
	  sta     _RI_VIC_CTR
.skip
	  lda #<_Pri_isr_launcher
	  sta $0314
	  lda #>_Pri_isr_launcher
	  sta $0315

	  ; enable VIC raster interrupts
	  lda #$01
	  sta _RI_VIC_IRQ_EN

	  cli
  "
endproc

rem ******************************
rem * Command
rem * ri_off
rem *
rem * No args
rem ******************************

proc ri_off
  asm "
    sei

    ; disable VIC raster interrupts
	  lda #$00
	  sta _RI_VIC_IRQ_EN

	  ; enable CIA irqs
	  lda #$ff
	  sta _RI_CIA1_ICR
	  sta _RI_CIA2_ICR

    ; reset handler ptr
    lda #$31
	  sta $0314
	  lda #$ea
	  sta $0315

	  cli
  "
endproc

rem ******************************
rem * Command
rem * ri_set_isr
rem *
rem * Args:
rem * handler_no!
rem * handler_addr
rem * raster_line
rem ******************************

proc ri_set_isr(isr_no!, isr_addr, raster_line)
  asm "
    ldx     {self}.isr_no
    lda     {self}.isr_addr
    sta.wx  _ri_isr_addr_lo
    lda     {self}.isr_addr + 1
    sta.wx  _ri_isr_addr_hi
    lda     {self}.raster_line
    sta.wx  _ri_ras_lo
    lda     {self}.raster_line + 1
    sta.wx  _ri_ras_hi
  "
endproc

rem ******************************
rem * Command
rem * ri_syshandler_on
rem *
rem * No args
rem ******************************

proc ri_syshandler_on
   \ri_syshandler = $ea31
endproc

rem ******************************
rem * Command
rem * ri_syshandler_off
rem *
rem * No args
rem ******************************

proc ri_syshandler_off
   \ri_syshandler = $ea81
endproc
