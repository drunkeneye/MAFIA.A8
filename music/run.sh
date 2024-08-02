#!/bin/bash

# split first
python3 ./splitter.py ./Night.sap
python3 ./splitter.py ./Paczka_TNQ_3.sap

python3 ./splitter.py Kernaw_Ingame.sap

# fix stereo bug
#sed 's/\xA2\x03\x8E\x1F\xD2/\xA2\x03\x8E\x0F\xD2/g' Kernaw_Ingame_block_2.bin > Kernaw_Ingame_block_2_fixed.bin
perl -pe 's/\xA2\x03\x8E\x1F\xD2/\xA2\x03\x8E\x0F\xD2/g' Kernaw_Ingame_block_2.bin > /tmp/X.bin
perl -pe 's/\xA9\x03\x8D\x1F\xD2/\xA9\x03\x8D\x0F\xD2/g' /tmp/X.bin > Kernaw_Ingame_block_2_fixed.bin


# copy over player
cp ./Kernaw_Ingame_block_2_fixed.bin ../assets/playb000.gfx

../../bin/mads ./cmcplayer.asm
cp cmcplayer.obx ../assets/playb0rz.gfx


# copy music
cp ./Night_block_1.bin ../assets/tmusb800.gfx
cp ./Paczka_TNQ_3_block_1.bin ../assets/fmusb800.gfx


 