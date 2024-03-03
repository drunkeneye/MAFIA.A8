
  icl 'const_title.inc'
	icl "title.h"


  org IMAGE_ASM_ADR


entry_pt

  .zpvar byt2 .byte=$80


	mva >PMG_BASE pmbase		;missiles and players data address
	mva #$03 pmcntl		;enable players and missiles

	lda:cmp:req $14		;wait 1 frame

	sei			;stop interrups
	mva #$00 nmien		;stop all interrupts
//	mva #$fe portb		;switch off ROM to get 16k more ram
	jmp raster_program_end

LOOP	lda vcount		;synchronization for the first screen line
	cmp #$02
	bne LOOP

	mva #%00111110 dmactl	;set new screen width
	mva <DL_BITMAP_ADR dlptr
	mva >DL_BITMAP_ADR dlptr+1

  icl "title.rp.ini"

;--- wait 18 cycles
	jsr _rts
	inc byt3

;--- set global offset (23 cycles)
	jsr _rts
	cmp byt3\ pha:pla

;--- empty line
	jsr wait54cycle
	inc byt2

  icl "title.rp"

raster_program_end

	lda >PMG_ADR+$400*$00
	sta chbase
c0	lda #$00
	sta colbak
c1	lda #$00
	sta color0
c2	lda #$00
	sta color1
c3	lda #$00
	sta color2
c4	lda #$00
	sta color3
s0	lda #$03
	sta sizep0
	sta sizep1
	sta sizep2
	sta sizep3
	mva #$ff sizem
	sta grafm
	mva #$20 hposm0
	mva #$28 hposm1
	mva #$d0 hposm2
	mva #$d8 hposm3
	mva #$02 pmcntl
	lda #$14
	sta gtictl


//--------------------
//	EXIT
//--------------------

	lda trig0		; FIRE #0
	beq stop

	lda trig1		; FIRE #1
	beq stop

	lda consol		; START
	and #1
	beq stop

	lda skctl		; ANY KEY
	and #$04
	bne skp

stop	mva #$00 pmcntl		;PMG disabled
	tax
	sta:rne hposp0,x+

//	mva #$ff portb		;ROM switch on
	mva #$40 nmien		;only NMI interrupts, DLI disabled
	//cli			;IRQ enabled
  // our return adresse is at 0082
	rts			;return to ... DOS
skp

//--------------------

	jmp LOOP

;---

wait54cycle
	:2 inc byt2
wait44cycle
	inc byt3
	nop
wait36cycle
	inc byt3
	jsr _rts
wait18cycle
	inc byt3
_rts	rts

byt3	brk
