
.enum	@@dmactl
	blank	= %00
	narrow	= %01
	standard= %10
	wide	= %11
	missiles= %100
	players	= %1000
	lineX1	= %10000
	lineX2	= %00000
	dma	= %100000
.ende

scr48	= @@dmactl(wide|dma|players|missiles|lineX1)		;screen 48b
scr40	= @@dmactl(standard|dma|players|missiles|lineX1)	;screen 40b
scr32	= @@dmactl(narrow|dma|players|missiles|lineX1)		;screen 32b

.enum	@@pmcntl
	missiles= %1
	players	= %10
	trigs	= %100
.ende

.enum	@@gtictl
	prior0	= %0
	prior1	= %1
	prior2	= %10
	prior4	= %100
	prior8	= %1000
	ply5	= %10000	; Fifth Player Enable
	mlc	= %100000	; Multiple Color Player Enable
	mode9	= %01000000
	mode10	= %10000000
	mode11	= %11000000
.ende

* ---------------------------------------------------------------------------------------------
* ---	GTIA
* ---------------------------------------------------------------------------------------------
hposp0	=	$D000		; pozioma pozycja gracza 0 (Z)
hposp1	=	$D001		; pozioma pozycja gracza 1 (Z)
hposp2	=	$D002		; pozioma pozycja gracza 2 (Z)
hposp3	=	$D003		; pozioma pozycja gracza 3 (Z)
hposm0	=	$D004		; pozioma pozycja pocisku 0 (Z)
hposm1	=	$D005		; pozioma pozycja pocisku 1 (Z)
hposm2	=	$D006		; pozioma pozycja pocisku 2 (Z)
hposm3	=	$D007		; pozioma pozycja pocisku 3 (Z)
sizep0	=	$D008		; poziomy rozmiar gracza 0 (Z)
sizep1	=	$D009		; poziomy rozmiar gracza 1 (Z)
sizep2	=	$D00A		; poziomy rozmiar gracza 2 (Z)
sizep3	=	$D00B		; poziomy rozmiar gracza 3 (Z)
sizem	=	$D00C		; poziomy rozmiar pocisk�w (Z)
grafp0	=	$D00D		; rejestr grafiki gracza 0 (Z)
grafp1	=	$D00E		; rejestr grafiki gracza 1 (Z)
grafp2	=	$D00F		; rejestr grafiki gracza 2 (Z)
grafp3	=	$D010		; rejestr grafiki gracza 3 (Z)
grafm	=	$D011		; rejestr grafiki pocisk�w (Z)
colpm0	=	$D012		; rejestr koloru gracza i pocisku 0 (Z)
colpm1	=	$D013		; rejestr koloru gracza i pocisku 1 (Z)
colpm2	=	$D014		; rejestr koloru gracza i pocisku 2 (Z)
colpm3	=	$D015		; rejestr koloru gracza i pocisku 3 (Z)
colpf0	=	$D016		; rejestr koloru pola gry 0 (Z)
colpf1	=	$D017		; rejestr koloru pola gry 1 (Z)
colpf2	=	$D018		; rejestr koloru pola gry 2 (Z)
colpf3	=	$D019		; rejestr koloru pola gry 3 (Z)
colbak	=	$D01A		; rejestr koloru t�a (Z)

color0	=	colpf0
color1	=	colpf1
color2	=	colpf2
color3	=	colpf3

kolm0pf	=	$D000		; kolizja pocisku 0 z polem gry (O)
kolm1pf	=	$D001		; kolizja pocisku 1 z polem gry (O)
kolm2pf	=	$D002		; kolizja pocisku 2 z polem gry (O)
kolm3pf	=	$D003		; kolizja pocisku 3 z polem gry (O)
kolp0pf	=	$D004		; kolizja gracza 0 z polem gry (O)
kolp1pf	=	$D005		; kolizja gracza 1 z polem gry (O)
kolp2pf	=	$D006		; kolizja gracza 2 z polem gry (O)
kolp3pf	=	$D007		; kolizja gracza 3 z polem gry (O)
kolm0p	=	$D008		; kolizja pocisku 0 z graczem (O)
kolm1p	=	$D009		; kolizja pocisku 1 z graczem (O)
kolm2p	=	$D00A		; kolizja pocisku 2 z graczem (O)
kolm3p	=	$D00B		; kolizja pocisku 3 z graczem (O)
kolp0p	=	$D00C		; kolizja gracza 0 z innym graczem (O)
kolp1p	=	$D00D		; kolizja gracza 1 z innym graczem (O)
kolp2p	=	$D00E		; kolizja gracza 2 z innym graczem (O)
kolp3p	=	$D00F		; kolizja gracza 3 z innym graczem (O)
trig0	=	$D010		; stan przycisku joysticka 0 (O)
trig1	=	$D011		; stan przycisku joysticka 1 (O)
trig3	=	$D013		; znacznik do��czenia cartridge-a (O)
pal	=	$D014		; znacznik systemu TV (O)

gtictl	=	$D01B		; rejestr kontroli uk�adu GTIA
gtiactl	=	gtictl

vdelay	=	$D01C		; licznik op��nienia pionowego P/MG
pmcntl	=	$D01D		; rejestr kontroli graczy i pocisk�w
hitclr	=	$D01E		; rejestr kasowania rejestr�w kolizji
consol	=	$D01F		; rejestr stanu klawiszy konsoli

* ---------------------------------------------------------------------------------------------
* ---	POKEY
* ---------------------------------------------------------------------------------------------

irqens	=	$0010		; rejestr-cie� IRQEN
irqstat	=	$0011		; rejestr-cie� IRQST

audf1	=	$d200		; cz�stotliwo�� pracy generatora 1 (Z)
audc1	=	$d201		; rejestr kontroli d�wi�ku generatora 1 (Z)
audf2	=	$d202		; cz�stotliwo�� pracy generatora 2 (Z)
audc2	=	$d203		; rejestr kontroli d�wi�ku generatora 2 (Z)
audf3	=	$d204		; cz�stotliwo�� pracy generatora 3 (Z)
audc3	=	$d205		; rejestr kontroli d�wi�ku generatora 3 (Z)
audf4	=	$d206		; cz�stotliwo�� pracy generatora 4 (Z)
audc4	=	$d207		; rejestr kontroli d�wi�ku generatora 4 (Z)

audctl	=	$D208		; rejestr kontroli generator�w d�wi�ku (Z)
stimer	=	$D209		; rejestr zerowania licznik�w (Z)
kbcode	=	$D209		; kod ostatnio naci�ni�tego klawisza (O)
skstres	=	$D20A		; rejestr statusu z��cza szeregowego (Z)
random	=	$D20A		; rejestr liczby losowej (O)
serout	=	$D20D		; szeregowy rejestr wyj�ciowy (Z)
serin	=	$D20D		; szeregowy rejestr wej�ciowy (O)
irqen	=	$D20E		; zezwolenie przerwa� IRQ (Z)
irqst	=	$D20E		; status przerwa� IRQ (O)
skctl	=	$D20F		; rejestr kontroli z��cza szeregowego (Z)
skstat	=	$D20F		; rejestr statusu z��cza szeregowego (O)

* ---------------------------------------------------------------------------------------------
* ---	PIA
* ---------------------------------------------------------------------------------------------
porta	=	$D300		; port A uk�adu PIA
portb	=	$D301		; port B uk�adu PIA
pactl	=	$D302		; rejestr kontroli portu A
pbctl	=	$D303		; rejestr kontroli portu B

* ---------------------------------------------------------------------------------------------
* ---	ANTIC
* ---------------------------------------------------------------------------------------------
dmactl	=	$D400		; rejestr kontroli dost�pu do pami�ci
chrctl	=	$D401		; rejestr kontroli wy�wietlania znak�w
dlptr	=	$D402		; adres programu ANTIC-a
hscrol	=	$D404		; znacznik poziomego przesuwu obrazu
vscrol	=	$D405		; znacznik pionowego przesuwu obrazu
pmbase	=	$D407		; adres pami�ci graczy i pocisk�w
chbase	=	$D409		; adres zestawu znak�w
wsync	=	$D40A		; znacznik oczekiwania na synchronizacj� poziom�
vcount	=	$D40B		; licznik linii obrazu
lpenh	=	$D40C		; poziome po�o�enie pi�ra �wietlengo
lpenv	=	$D40D		; pionowe po�o�enie pi�ra �wietlnego
nmien	=	$D40E		; rejestr zezwole� na przerwania NMI
nmist	=	$D40F		; rejestr statusu przerwa� NMI
