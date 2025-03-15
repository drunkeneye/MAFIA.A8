
# LOCATION=EN

# tools
MP=../../bin/mp1.7.2
MADS=../../bin/mads
BASE=../../tools/Mad-Pascal-1.7.2/base
ATR_BIN=../../bin/atr
dir2atr=../../bin/dir2atr
APULTRA_BIN=../../bin/apultra
DIR2CAR_BIN=../../bin/dir2car
DIR2CAR_BANK=../../bin/bank_xEMU.bin

# output
RELEASE_DIR=../release
OUTPUT_DIR=$(RELEASE_DIR)/output/
CAR_OUTPUT_DIR=$(RELEASE_DIR)/car.assets
ATR_DIR=../atr/
ASM=$(OUTPUT_DIR)/main.a65
XEX=$(OUTPUT_DIR)/main.xex
BLANK_ATR=$(ATR_DIR)/180k_empty.atr
XBOOT=$(ATR_DIR)/xboot.obx
ATR=$(OUTPUT_DIR)/output.atr
ATR_ASSETS=../release/atr.assets/$(LOCATION)/

EXOMIZER_BIN=../../bin/exomizer
AUTOXEX=$(OUTPUT_DIR)/autorun.xex
EXO=$(OUTPUT_DIR)/exomized
AUTOEXO=$(OUTPUT_DIR)/exomizedauto

FREE_SPACE = $(shell $(ATR_BIN) $(ATR) ls -l | grep free)


# Only check LOCATION if the 'atr' target is being built
ifeq ($(filter atr,$(MAKECMDGOALS)),atr)
  ifeq ($(LOCATION),)
    $(error You must specify a location!)
  endif
endif


all:
	rm -rf $(RELEASE_DIR)
	$(MAKE) atr LOCATION=DE
	$(MAKE) atr LOCATION=PL
	$(MAKE) atr LOCATION=EN
	$(MAKE) car 

atr: clean prepare_atr_folder\
	compress_assets \
	compress_locassets \
	compile_title  \
	compile_main  \
	build_atr info save \
	run


cartest: compile_title_car \
	create_car
	echo "CAR target build completed"


car: clean_car \
	nocompress_assets \
	nocompress_bitmaps \
	nocompress_locassets_EN \
	nocompress_locassets_DE \
	nocompress_locassets_PL \
	car_prepare_assets \
	compile_title_car \
	create_car
	echo "CAR target build completed"

nocompress_locassets_EN: 
	$(MAKE) nocompress_locassets LOCATION=EN

nocompress_locassets_DE: 
	$(MAKE) nocompress_locassets LOCATION=DE

nocompress_locassets_PL: 
	$(MAKE) nocompress_locassets LOCATION=PL




clean_car:
	rm -rf $(CAR_OUTPUT_DIR)
	mkdir -p $(CAR_OUTPUT_DIR)

car_prepare_assets: compile_main_car_EN compile_main_car_DE compile_main_car_PL
	#cp -u $(RELEASE_DIR)/atr.assets/EN/* $(CAR_OUTPUT_DIR)
	#rm -f $(CAR_OUTPUT_DIR)/MAIN.XEX
	#cp -u $(RELEASE_DIR)/atr.assets/PL/* $(CAR_OUTPUT_DIR)
	#rm -f $(CAR_OUTPUT_DIR)/MAIN.XEX
	#cp -u $(RELEASE_DIR)/atr.assets/DE/* $(CAR_OUTPUT_DIR)
	#rm -f $(CAR_OUTPUT_DIR)/MAIN.XEX
	cp $(OUTPUT_DIR)/MAINEN.XEX $(CAR_OUTPUT_DIR)/MAINEN.XEX
	cp $(OUTPUT_DIR)/MAINDE.XEX $(CAR_OUTPUT_DIR)/MAINDE.XEX
	cp $(OUTPUT_DIR)/MAINPL.XEX $(CAR_OUTPUT_DIR)/MAINPL.XEX

compile_main_car_%:
	echo "Compiling main car for location" $(LOCATION)
	mkdir -p $(RELEASE_DIR)/output
	$(MP) main.pas -code:0c00 -o $(OUTPUT_DIR)/main_$*.a65 -define:CART -define:LOCATION_$* -define:CHEAT
	$(MADS) $(OUTPUT_DIR)/main_$*.a65 -x -i:$(BASE) -o:$(OUTPUT_DIR)/MAIN$*.XEX -d:CART


compile_title_car:
	$(MP) title.pas -code:0c00 -o $(OUTPUT_DIR)/title.a65 -define:CART
	$(MADS) $(OUTPUT_DIR)/title.a65 -x -i:$(BASE) -o:$(OUTPUT_DIR)/title.xex -d:CART
	cp $(OUTPUT_DIR)/title.xex $(CAR_OUTPUT_DIR)/AUTORUN.COM

create_car:
	$(DIR2CAR_BIN) $(DIR2CAR_BANK) ../release/MAFIA.CAR $(CAR_OUTPUT_DIR)

clean:
	# rm -rf $(RELEASE_DIR)
	mkdir -p $(RELEASE_DIR)
	rm -rf $(OUTPUT_DIR)
	mkdir -p $(OUTPUT_DIR)
	rm -f $(AUTOXEX)
	rm -f $(XEX)
	rm -f $(AUTOEXO)
	rm -f $(EXO)
	rm -f $(ATR)
	cp $(BLANK_ATR) $(ATR)

prepare_atr_folder:
	rm -rf $(ATR_ASSETS)
	mkdir -p $(ATR_ASSETS)
	cp $(ATR_DIR)/xbios.com $(ATR_ASSETS)
	cp ../assets/gangstas.gfx_$(LOCATION) $(ATR_ASSETS)/gangstas.a$(LOCATION)
	echo cp ../assets/final.xex $(ATR_ASSETS)/final.xex
	dd if=/dev/zero of=./$(ATR_ASSETS)/SAVEGAME.DAT bs=2591 count=1
# the 2592=$ea20. this is where the strings start, so by saving up to this point
# it should be possible to save in german and load in polish without language changes.





BITMAPS_FILES := ARMSBOCA.gfx \
	BANKBOCA.gfx \
	CARSBOCA.gfx \
	FORGBOCA.gfx \
	GAMBBOCA.gfx \
	HIDEBOCA.gfx \
	LOANBOCA.gfx \
	MAJOBOCA.gfx \
	MONYBOCA.gfx \
	POLIBOCA.gfx \
	PUBBBOCA.gfx \
	STORBOCA.gfx \
	SUBWBOCA.gfx 

nocompress_bitmaps: $(addprefix put_nocompress_, $(BITMAPS_FILES:.gfx=.apl))
put_nocompress_%.apl: ../assets/%.gfx
	cp $< $(CAR_OUTPUT_DIR)/$*.apl




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
	wantmbmp.gfx \
	wantfbmp.gfx \
	logo.gfx \
	afmapbmp.gfx \
	safecbmp.gfx \
	finagpic.gfx \
	fmusb800.gfx tmusb800.gfx \
	playb000.gfx \
	playb0rz.gfx \
	flagsbmp.gfx \
	titlepic.gfx

compress_assets: $(addprefix put_, $(ASSET_FILES:.gfx=.apl))
put_%.apl: ../assets/%.gfx
	$(APULTRA_BIN) $< $(ATR_ASSETS)/$*.apl

nocompress_assets: $(addprefix put_nocompress_, $(ASSET_FILES:.gfx=.apl))
put_nocompress_%.apl: ../assets/%.gfx
	cp $< $(CAR_OUTPUT_DIR)/$*.apl



LOC_FILES := ARMSLOCA.gfx_$(LOCATION)  \
	BANKLOCA.gfx_$(LOCATION)  \
	CARSLOCA.gfx_$(LOCATION)  \
	FORGLOCA.gfx_$(LOCATION)   \
	GAMBLOCA.gfx_$(LOCATION)  \
	HIDELOCA.gfx_$(LOCATION)  \
	LOANLOCA.gfx_$(LOCATION)  \
	POLILOCA.gfx_$(LOCATION)  \
	PUBBLOCA.gfx_$(LOCATION)  \
	PUBCLOCA.gfx_$(LOCATION)  \
	STORLOCA.gfx_$(LOCATION)  \
	SUBWLOCA.gfx_$(LOCATION)  \
	JOBBLOCA.gfx_$(LOCATION)  \
	MAINLOCA.gfx_$(LOCATION)  \
	MAJOLOCA.gfx_$(LOCATION)  \
	CAUGLOCA.gfx_$(LOCATION)  \
	COURLOCA.gfx_$(LOCATION)  \
	ROADLOCA.gfx_$(LOCATION)  \
	CENTLOCA.gfx_$(LOCATION)  \
	SETULOCA.gfx_$(LOCATION)  \
	UPDTLOCA.gfx_$(LOCATION)  \
	CENTLOCA.gfx_$(LOCATION)  \
	MONYLOCA.gfx_$(LOCATION)  \
	CREDLOCA.gfx_$(LOCATION) \
	gangstas.gfx_$(LOCATION) \
	E700PAGE.gfx_$(LOCATION)


compress_locassets: $(addprefix put_, $(LOC_FILES:.gfx_$(LOCATION)=.A$(LOCATION)))
put_%.A$(LOCATION): ../assets/%.gfx_$(LOCATION)
	$(APULTRA_BIN) $< $(ATR_ASSETS)/$*.A$(LOCATION)

nocompress_locassets: $(addprefix put_nocompress_, $(LOC_FILES:.gfx_$(LOCATION)=.A$(LOCATION)))
put_nocompress_%.A$(LOCATION): ../assets/%.gfx_$(LOCATION)
	cp $< $(CAR_OUTPUT_DIR)/$*.A$(LOCATION)



compile_title:
	$(MP) title.pas -code:0c00 -o $(OUTPUT_DIR)/title.a65
	$(MADS) $(OUTPUT_DIR)/title.a65 -x -i:$(BASE) -o:$(OUTPUT_DIR)/title.xex -xp -x
	cp $(OUTPUT_DIR)/title.xex $(ATR_ASSETS)/XAUTORUN


compile_main:
	$(MP) main.pas -code:0c00 -o $(ASM)  -define:LOCATION_$(LOCATION) -define:CHEAT
	$(MADS) $(ASM) -x -i:$(BASE) -o:$(XEX)
	cp $(XEX) $(ATR_ASSETS)/MAIN.XEX


build_atr:
	$(dir2atr) -B $(XBOOT) -D $(ATR) $(ATR_ASSETS) # needs XAUTORUN


info:
	@echo $(FREE_SPACE)

run:
	echo /Applications/Atari800MacX.app/Contents/MacOS/Atari800MacX $(ATR)

save:
	cp $(ATR) ../release/mafia_$(LOCATION).atr
