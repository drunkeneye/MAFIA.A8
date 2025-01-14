/*-------------------------------*
*       cmc player	             *
*                                *
* v 2.0 by Janusz Pelc           *
* v 2.1 by Marcin Lewandowski    *
* v 2.2 by Martin Simecek        *
*-------------------------------*/
; 2.10.2020 - v 2.2 - added double mode based on SDCMC (Datri)
;                     https://sourceforge.net/p/mdcmc

;MDCMC = 1	;mono double mode
CMR = 1		;rzog bass table
CM3 = 0		;3/4 pattern length

	org $b000
	OPT h-

;--- zero page

addr	equ $fc
word0	equ $fe

;--- jumps

	jmp basic
	jmp init
	jmp play
;--- data

volume	dta d'   '
czest	dta d'   '
numins	dta d'   '

		    dta c' cmc player v 2.2 '*

frq	dta d'    '
znieks	dta d'    '
audc	dta b(0)

czest1	dta d'   '
czest2	dta d'   '
czest3	dta d'   '
zniek	dta d'   '
count1	dta b($ff),b($ff),b($ff)
count2	dta d'   '
lopad	dta d'   '
numptr	dta d'   '
poswpt	dta d'   '
ilewol	dta d'   '
czygrx	dta b($80),b($80),b($80)
czygrc	dta b($80)

dana0	dta d'   '
dana1	dta d'   '
dana2	dta d'   '
dana3	dta d'   '
dana4	dta d'   '
dana5	dta d'   '
ladr	dta d'   '
hadr	dta d'   '

posptr	dta b(0)
possng	dta b(0)
pocrep	dta b(0)
konrep	dta b(0)
ilrep	dta b(0)
tmpo	dta b(0)
ltemp	dta b(0)
b1	dta b(0)
b2	dta b(0)
b3	dta b(0)
czygr	dta b(0)

adrmus	dta a(0)
adradr	dta a(0)
adrsng	dta a(0)

;--- init

init	sta b1
	stx b2
	sty b3
	and #$70
	lsr @
	lsr @
	lsr @
	tax
	lda tab1,x
	sta zm1+1
	lda tab1+1,x
	sta zm1+2
	lda #3
	sta $d20f
	cld
	lda word0
	pha
	lda word0+1
	pha
	ldy b3
	ldx b2
	lda b1
zm1	jsr graj
	pla
	sta word0+1
	pla
	sta word0
	rts

graj	lda adrsng
	sta word0
	lda adrsng+1
	sta word0+1
	ldy #0
	txa
	beq grajx
l1	lda (word0),y
	cmp #$8f
	beq l2
	cmp #$ef
	bne l3
l2	dex
	bne l3
	iny
	cpy #$54
	bcs l4
	tya
	tax
	bpl grajx
l3	iny
	cpy #$54
	bcc l1
l4	rts

grajx	stx possng
	jsr skoncz
	lda #0
	ldx #9
l5	sta poswpt,x
	dex
	bpl l5
	sta posptr
	lda #1
	sta czygr
	lda #$ff
	sta konrep
	lda adrmus
	sta word0
	lda adrmus+1
	sta word0+1
	ldy #$13
	lda (word0),y
	tax
	lda adrsng
	sta word0
	lda adrsng+1
	sta word0+1
	ldy possng
l6	lda (word0),y
	cmp #$cf
	bne l7
	tya
	clc
	adc #$55
	tay
	lda (word0),y
	bmi l8
	tax
	jmp l8
l7	cmp #$8f
	beq l8
	cmp #$ef
	beq l8
	dey
	bpl l6
l8	stx tmpo
	stx ltemp
	rts

tempo	and #$f
	beq l8
	stx d0+1
	stx d1+1
	stx d2+1
	sty d0+2
	sty d1+2
	sty d2+2
	rts

inic	stx adrmus
	stx word0
	sty adrmus+1
	sty word0+1
	clc
	txa
	adc #$14
	sta adradr
	tya
	adc #0
	sta adradr+1
	stx adrsng
	iny
	iny
	sty adrsng+1
	ldy #$13
	lda (word0),y
	sta tmpo
	sta ltemp

skoncz	ldx #8
l9	lda #0
	sta czygr
	sta $d200,x
	cpx #3
	bcs l10
	sta volume,x
	lda #$ff
	sta count1,x
l10	dex
	bpl l9

przer	lda #$80
l11	ldx #3
l12	sta czygrx,x
	dex
	bpl l12
l13	rts

kont	lda #1
	sta czygr
	lda #0
	beq l11

instr	and #3
	cmp #3
	beq l13
	cpx #$40
	bcs l13
	cpy #26
	bcs l13
	tax
	lda #$80
	sta czygrx,x

inst	lda #0
	sta count1,x
	sta count2,x
	sta lopad,x
	lda b2
	sta czest,x

	lda b3
	asl @
	asl @
	asl @
	sta word0
	clc
	lda adrmus
	adc #$30
	pha
	lda adrmus+1
	adc #1
	tay
	pla
	clc
	adc word0
	sta ladr,x
	tya
	adc #0
	sta hadr,x

	clc
	lda adrmus
	adc #$94
	sta word0
	lda adrmus+1
	adc #0
	sta word0+1
	lda b3
	asl @
	adc b3
	asl @
	tay
	lda (word0),y
	sta dana0,x
	iny
	lda (word0),y
	sta dana1,x
	and #7
	sta b1
	iny
	lda (word0),y
	sta dana2,x
	iny
	lda (word0),y
	sta dana3,x
	iny
	lda (word0),y
	sta dana4,x
	iny
	lda (word0),y
	sta dana5,x

	ldy #0
	lda b1
	cmp #3
	bne l14
	ldy #2
l14	cmp #7
	bne l15
	ldy #4
l15	lda tab3,y
	sta word0
	lda tab3+1,y
	sta word0+1
	lda dana2,x
	lsr @
	lsr @
	lsr @
	lsr @
	clc
	adc b2
	sta b2
	sta zm2+1
	tay
	lda b1
	cmp #7
	bne l16
	tya
	asl @
	tay
	lda (word0),y
	sta czest1,x
	iny
	sty b2
	jmp l17
l16	lda (word0),y
	sta czest1,x
	lda dana2,x
	and #$f
	clc
	adc b2
	sta b2
l17	ldy b2
	lda b1
	cmp #5
	php
	lda (word0),y
	plp
	beq l18
	cmp czest1,x
	bne l18
	sec
	sbc #1
l18	sta czest2,x
	lda dana0,x
	pha
	and #3
	tay
	lda tab4,y
	sta zniek,x
	pla
	lsr @
	lsr @
	lsr @
	lsr @
	ldy #$3e
	cmp #$f
	beq l19
	ldy #$37
	cmp #$e
	beq l19
	ldy #$30
	cmp #$d
	beq l19
	clc
zm2	adc #0
	tay
l19	lda tab5,y
	sta czest3,x
	rts

;--- play

play	cld
	lda addr
	pha
	lda addr+1
	pha
	lda word0
	pha
	lda word0+1
	pha
	lda czygr
	bne g1
	jmp finish
g1	lda czygrc
	beq g2
	jmp dal3
g2	lda tmpo
	cmp ltemp
	beq g3
	jmp dal2
g3	lda posptr
	beq g4
	jmp dal1
g4	ldx #2
g5	ldy czygrx,x
	bmi g6
	sta czygrx,x
g6	sta poswpt,x
	dex
	bpl g5

	lda adrsng
	sta addr
	lda adrsng+1
	sta addr+1
	ldy possng
	sty word0
g7	cpy konrep
	bne g8
	lda ilrep
	beq g8
	lda possng
	ldy pocrep
	sty possng
	dec ilrep
	bne g7
	sta possng
	tay
	bpl g7
g8	ldx #0
g9	lda (addr),y
	cmp #$fe
	bne g10
	ldy possng
	iny
	cpy word0
	beq g11
	sty possng
	jmp g7
g10	sta numptr,x
	clc
	tya
	adc #$55
	tay
	inx
	cpx #3
	bcc g9
	ldy possng
	lda (addr),y
	bpl dal1
	cmp #$ff
	beq dal1
	lsr @
	lsr @
	lsr @
	and #$e
	tax
	lda tab2,x
	sta zm3+1
	lda tab2+1,x
	sta zm3+2
	lda numptr+1
	sta word0+1
zm3	jsr stop
	sty possng
	cpy #$55
	bcs g11
	cpy word0
	bne g7
g11	ldy word0
	sty possng
	jmp finish

stop	jsr przer
g12	ldy #$ff
	rts
jump	bmi g12
	tay
	rts
up	bmi g12
	sec
	tya
	sbc word0+1
	tay
	rts
down	bmi g12
	clc
	tya
	adc word0+1
	tay
	rts
temp	bmi g12
	sta tmpo
	sta ltemp
	iny
	rts
repeat	bmi g12
	lda numptr+2
	bmi g12
	sta ilrep
	iny
	sty pocrep
	clc
	tya
	adc word0+1
	sta konrep
	rts
break	dey
	bmi g13
	lda (addr),y
	cmp #$8f
	beq g13
	cmp #$ef
	bne break
g13	iny
	rts

dal1	ldx #2
v1	lda ilewol,x
	beq v2
	dec ilewol,x
	bpl v7
v2	lda czygrx,x
	bne v7
	ldy numptr,x
	cpy #$40
	bcs v7
	lda adradr
	sta addr
	lda adradr+1
	sta addr+1
	lda (addr),y
	sta word0
	clc
	tya
	adc #$40
	tay
	lda (addr),y
	sta word0+1
	and word0
	cmp #$ff
	beq v7
v3	ldy poswpt,x
	lda (word0),y
	and #$c0
	bne v4
	lda (word0),y
	and #$3f
	sta numins,x
	inc poswpt,x
	bpl v3
v4	cmp #$40
	bne v5
	lda (word0),y
	and #$3f
	sta b2
	lda numins,x
	sta b3
	jsr inst
	jmp v6
v5	cmp #$80
	bne v7
	lda (word0),y
	and #$3f
	sta ilewol,x
v6	inc poswpt,x
v7	dex
	bpl v1

	ldx posptr
	inx
	ift CM3
		cpx #$30
		scc:ldx #0
		stx posptr
	els
		txa
		and #$3f
		sta posptr
	eif

dal2	dec ltemp
	bne dal3
	lda tmpo
	sta ltemp
	lda posptr
	bne dal3
	inc possng

dal3	ldy czest2
	lda dana1
	and #7
	cmp #5
	beq a1
	cmp #6
	bne a2
a1	dey
a2	sty frq+3
	ldy #0
	cmp #5
	beq a3
	cmp #6
	bne a4
a3	ldy #2
a4	cmp #7
	bne a5
	ldy #$28
a5	sty audc

	ldx #2
loop	lda dana1,x
	and #$e0
	sta znieks,x
	lda ladr,x
	sta addr
	lda hadr,x
	sta addr+1
	lda count1,x
	cmp #$ff
	beq y4
	cmp #$f
	bne y2
	lda lopad,x
	beq y4
	dec lopad,x
	lda lopad,x
	bne y4
	ldy volume,x
	beq y1
	dey
y1	tya
	sta volume,x
	lda dana3,x
	sta lopad,x
	jmp y4
y2	lda count1,x
	lsr @
	tay
	lda (addr),y
	bcc y3
	lsr @
	lsr @
	lsr @
	lsr @
y3	and #$f
	sta volume,x
y4	ldy czest1,x
	lda dana1,x
	and #7
	cmp #1
	bne y6
	dey
	tya
	iny
	cmp czest2,x
	php
	lda #1
	plp
	bne y5
	asl @
	asl @
y5	and count2,x
	beq y6
	ldy czest2,x
	cpy #$ff
	bne y6
	lda #0
	sta volume,x
y6	tya
	sta frq,x
	lda #1
	sta b1
	lda count1,x
	cmp #$f
	beq y9
	and #7
	tay
	lda tab9,y
	sta word0
	lda count1,x
	and #8
	php
	txa
	plp
	clc
	beq y7
	adc #3
y7	tay
	lda dana4,y
	and word0
	beq y9
	lda czest3,x
	sta frq,x
	stx b1
	dex
	bpl y8
	sta frq+3
	lda #0
	sta audc
y8	inx
	lda zniek,x
	sta znieks,x
y9	lda count1,x
	and #$f
	cmp #$f
	beq y10
	inc count1,x
	lda count1,x
	cmp #$f
	bne y10
	lda dana3,x
	sta lopad,x
y10	lda czygrx,x
	bpl y11
	lda volume,x
	bne y11
	lda #$40
	sta czygrx,x
y11	inc count2,x
	ldy #0
	lda dana1,x
	lsr @
	lsr @
	lsr @
	lsr @
	bcc y12
	dey
y12	lsr @
	bcc y13
	iny
y13	clc
	tya
	adc czest1,x
	sta czest1,x
	lda czest2,x
	cmp #$ff
	bne y14
	ldy #0
y14	clc
	tya
	adc czest2,x
	sta czest2,x
	dex
	bmi x1
	jmp loop

x1	lda znieks
	sta znieks+3
	lda dana1
	and #7
	tax
	ldy #3
	lda b1
	beq x2
	ldy tab10,x
x2	tya
	pha
	lda tab8,y
	php
	and #$7f
	tax
	tya
	and #3
	asl @
	tay
	lda frq,x
d0	sta $d200,y
	iny
	lda volume,x
	cpx #3
	bne x3
	lda volume
x3	ora znieks,x
	plp
	bpl d1
	lda #0
d1	sta $d200,y
	pla
	tay
	dey
	and #3
	bne x2
	ldy #8
	lda audc
d2	sta $d200,y

	clc
finish	pla
	sta word0+1
	pla
	sta word0
	pla
	sta addr+1
	pla
	sta addr
	rts

;--- basic

basic	pla
	tax
	beq p6
	cmp #2
	beq p2
p1	pla
	pla
	dex
	bne p1
	rts
p2	lda $14
	cmp $14
	beq *-2
	lda $224
	cmp <p8
	bne p3
	lda $225
	cmp >p8
	beq p1
p3	lda $224
	sta p9+1
	lda $225
	sta p9+2
	lda <p8
	sta $224
	lda >p8
	sta $225
	pla
	pla
	beq p4
	sec
	sbc #1
p4	sta p5+1
	pla
	tay
	pla
	tax
	lda #$70
	jsr init
	lda #0
p5	ldx #0
	jmp init
p6	lda $14
	cmp $14
	beq *-2
	lda $224
	cmp <p8
	bne p2-1
	lda $225
	cmp >p8
	bne p2-1
p7	lda p9+1
	sta $224
	lda p9+2
	sta $225
	lda #$40
	jmp init
p8	jsr play
	bcc p9
	jsr p7
p9	jmp $ffff

;--- tables

tab1	dta a(graj)
	dta a(grajx)
	dta a(instr)
	dta a(tempo)
	dta a(skoncz)
	dta a(przer)
	dta a(kont)
	dta a(inic)

tab2	dta a(stop)
	dta a(jump)
	dta a(up)
	dta a(down)
	dta a(temp)
	dta a(repeat)
	dta a(break)

tab3	dta a(tab5)
	dta a(tab6)
	dta a(tab7)

tab4	dta b($80),b($a0)
	dta b($20),b($40)

tab5	dta b($ff),b($f1),b($e4),b($d7)
	dta b($cb),b($c0),b($b5),b($aa)
	dta b($a1),b($98),b($8f),b($87)
	dta b($7f),b($78),b($72),b($6b)
	dta b($65),b($5f),b($5a),b($55)
	dta b($50),b($4b),b($47),b($43)
	dta b($3f),b($3c),b($38),b($35)
	dta b($32),b($2f),b($2c),b($2a)
	dta b($27),b($25),b($23),b($21)
	dta b($1f),b($1d),b($1c),b($1a)
	dta b($18),b($17),b($16),b($14)
	dta b($13),b($12),b($11),b($10)
	dta b($0f),b($0e),b($0d),b($0c)
	dta b($0b),b($0a),b($09),b($08)
	dta b($07),b($06),b($05),b($04)
	dta b($03),b($02),b($01),b($00)
	dta b($00)

tab6	dta b($00),b($00),b($00),b($00)
	dta b($f2),b($e9),b($da),b($ce)
	dta b($bf),b($b6),b($aa),b($a1)
	dta b($98),b($8f),b($89),b($80)
	dta b($7a),b($71),b($6b),b($65)
	dta b($5f)
	ift CMR
		dta b($5c),b($56),b($50)
		dta b($4d),b($47),b($44),b($41)
		dta b($3e),b($38),b($35),b($88)
		dta b($7f),b($79),b($73),b($6c)
		dta b($67),b($60),b($5a),b($55)
		dta b($51),b($4c),b($48),b($43)
		dta b($3f),b($3d),b($39),b($34)
		dta b($33),b($30),b($2d),b($2a)
		dta b($28),b($25),b($24),b($21)
		dta b($1f),b($1e)
	els
		dta b($00),b($56),b($50)
		dta b($67),b($60),b($5a),b($55)
		dta b($51),b($4c),b($48),b($43)
		dta b($3f),b($3d),b($39),b($34)
		dta b($33),b($39),b($2d),b($2a)
		dta b($28),b($25),b($24),b($21)
		dta b($1f),b($1e),b($00),b($00)
		dta b($0f),b($0e),b($0d),b($0c)
		dta b($0b),b($0a),b($09),b($08)
		dta b($07),b($06)
	eif
	dta b($05),b($04)
	dta b($03),b($02),b($01),b($00)
	dta b($00)

tab7	dta a($b38),a($a8c),a($a00),a($96a)
	dta a($8e8),a($86a),a($7ef),a($780)
	dta a($708),a($6ae),a($646),a($5e6)
	dta a($595),a($541),a($4f6),a($4b0)
	dta a($46e),a($430),a($3f6),a($3bb)
	dta a($384),a($352),a($322),a($2f4)
	dta a($2c8),a($2a0),a($27a),a($255)
	dta a($234),a($214),a($1f5),a($1d8)
	dta a($1bd),a($1a4),a($18d),a($177)
	dta a($160),a($14e),a($138),a($127)
	dta a($115),a($106),a($0f7),a($0e8)
	dta a($0db),a($0cf),a($0c3),a($0b8)
	dta a($0ac),a($0a2),a($09a),a($090)
	dta a($088),a($07f),a($078),a($070)
	dta a($06a),a($064),a($05e),a($057)
	dta a($052),a($032),a($00a)

tab8	dta b($00),b($01),b($02),b($83)
	dta b($00),b($01),b($02),b($03)
	dta b($01),b($00),b($02),b($83)
	dta b($01),b($00),b($02),b($03)
	dta b($01),b($02),b($80),b($03)

tab9	dta b($80),b($40),b($20),b($10)
	dta b($08),b($04),b($02),b($01)

tab10	dta b(3),b(3),b(3),b(3)
	dta b(7),b($b),b($f),b($13)


tmp01	dta 0
;--- end

	end
