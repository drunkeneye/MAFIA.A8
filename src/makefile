
# LOCATION=EN

# tools
MP=../../bin/mp
MADS=../../bin/mads
BASE=../../tools/Mad-Pascal/base
ATR_BIN=../../bin/atr
dir2atr=../../bin/dir2atr
APULTRA_BIN=../../bin/apultra


# output
ASM=./output/main.a65
XEX=./output/main.xex
BLANK_ATR=./atr/180k_empty.atr
XBOOT=./atr/xboot.obx
ATR=./output/output.atr
ATR_ASSETS=atr.assets

EXOMIZER_BIN=../../bin/exomizer
AUTOXEX=./output/autorun.xex
EXO=./output/exomized
AUTOEXO=./output/exomizedauto

FREE_SPACE = $(shell $(ATR_BIN) $(ATR) ls -l | grep free)


all: clean prepare_atr_folder\
	compress_assets \
	compress_locassets \
	compile_title  \
	compile_main  \
	build_atr info save \
	run


compile_title:
	$(MP) title.pas -code:0c00 -o ./output/title.a65
	$(MADS) ./output/title.a65 -x -i:$(BASE) -o:./output/title.xex
	cp ./output/title.xex ./atr.assets/XAUTORUN
	cp ../assets/logo.apl ./atr.assets


compile_main:
	$(MP) main.pas -code:0c00 -o $(ASM)  -define:LOCATION_$(LOCATION) -define:CHEAT
	$(MADS) $(ASM) -x -i:$(BASE) -o:$(XEX)
	cp $(XEX) ./atr.assets/MAIN.XEX


build_atr:
	$(dir2atr) -B $(XBOOT) -D $(ATR) $(ATR_ASSETS) # needs XAUTORUN

clean:
	rm -rf ./output
	mkdir ./output
	rm -f $(AUTOXEX)
	rm -f $(XEX)
	rm -f $(AUTOEXO)
	rm -f $(EXO)
	rm -f $(ATR)
	cp $(BLANK_ATR) $(ATR)

prepare_atr_folder:
	rm -rf atr.assets
	mkdir -p atr.assets
	cp atr/xbios.com $(ATR_ASSETS)
	cp ../assets/gangstas.dat_$(LOCATION) $(ATR_ASSETS)/gangstas.dat
	echo cp ../assets/final.xex $(ATR_ASSETS)/final.xex
	dd if=/dev/zero of=./atr.assets/SAVEGAME.DAT bs=256 count=4


ASSET_FILES := acombmap.gfx \
	bcombmap.gfx \
	ccombmap.gfx \
	dcombmap.gfx \
	ecombmap.gfx \
	fcombmap.gfx \
	gcombmap.gfx \
	hcombmap.gfx \
	icombmap.gfx \
	jcombmap.gfx \
	wantemmf.gfx  wantemms.gfx\
	wantefmf.gfx  wantefms.gfx\
	afmapfnt.gfx  afmapscr.gfx \
	safeclmf.gfx   safeclms.gfx \
	finampic.gfx finawpic.gfx finagpic.gfx \
	fmusb800.gfx tmusb800.gfx \
	playb000.gfx \
	playb0rz.gfx \
	titlepic.gfx

LOC_FILES := LOCAARMS.gfx_$(LOCATION)  \
	LOCABANK.gfx_$(LOCATION)  \
	LOCACARS.gfx_$(LOCATION)  \
	LOCAFORG.gfx_$(LOCATION)   \
	LOCAGAMB.gfx_$(LOCATION)  \
	LOCAHIDE.gfx_$(LOCATION)  \
	LOCALOAN.gfx_$(LOCATION)  \
	LOCAPOLI.gfx_$(LOCATION)  \
	LOCAPUBB.gfx_$(LOCATION)  \
	LOCAPUBC.gfx_$(LOCATION)  \
	LOCASTOR.gfx_$(LOCATION)  \
	LOCASUBW.gfx_$(LOCATION)  \
	LOCAJOBB.gfx_$(LOCATION)  \
	LOCAMAIN.gfx_$(LOCATION)  \
	LOCAMAJO.gfx_$(LOCATION)  \
	LOCACAUG.gfx_$(LOCATION)  \
	LOCACOUR.gfx_$(LOCATION)  \
	LOCAROAD.gfx_$(LOCATION)  \
	LOCACENT.gfx_$(LOCATION)  \
	LOCASETU.gfx_$(LOCATION)  \
	LOCAUPDT.gfx_$(LOCATION)  \
	LOCACENT.gfx_$(LOCATION)  \
	LOCAMONY.gfx_$(LOCATION)  \
	LOCACRED.gfx_$(LOCATION) \
	E700PAGE.gfx_$(LOCATION)

compress_locassets: $(addprefix put_, $(LOC_FILES:.gfx_$(LOCATION)=.apl))
put_%.apl: ../assets/%.gfx_$(LOCATION)
	$(APULTRA_BIN) $< $(ATR_ASSETS)/$*.apl

compress_assets: $(addprefix put_, $(ASSET_FILES:.gfx=.apl))
put_%.apl: ../assets/%.gfx
	$(APULTRA_BIN) $< $(ATR_ASSETS)/$*.apl


# put_exo_main:
# 	$(EXOMIZER_BIN) sfx sys -n -t 168 -Di_table_addr=0x0400 -P0 -o $(EXO) $(XEX)
# 	atr $(ATR) put $(EXO) AUTO
#
# put_%.zx0: ../assets/%.gfx
# 	$(ZX0_BIN) $< $(ATR_ASSETS)/$*.zx0


info:
	@echo $(FREE_SPACE)

run:
	echo /Applications/Atari800MacX.app/Contents/MacOS/Atari800MacX $(ATR)

save:
	cp $(ATR) ../release/mafia_$(LOCATION).atr
