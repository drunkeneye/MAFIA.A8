%.xex: ./output.png
	# cp ../output.png* .
	mads no_name.asq -o:output.xex 2>&1 | tee mads.log
	cp output.xex $@
	cp output.png.rp.ini $*.rp.ini
	cp output.png.rp $*.rp
	cp output.png.pmg $*.pmg
	cp output.png.mic $*.mic

%.show: %.xex
	atari800.x11 $<; xset r on

.PRECIOUS: %.xex
