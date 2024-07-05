#!/bin/bash

# split first
python3 ./splitter.py ./Night.sap
python3 ./splitter.py ./Paczka_TNQ_3.sap

# two players, Outer_1 not needed right now, because too low in memory
python3 ./splitter.py ./Robin_Wojownik_Czasu.sap
python3 ./splitter.py ./Outer_1.sap
python3 ./splitter.py Demologicus_4.sap
python3 ./splitter.py Dual_Yellow_Energy.sap
python3 ./splitter.py Kernaw_Ingame.sap


# copy over player
cp ./Robin_Wojownik_Czasu_block_2.bin ../assets/playe140.gfx
cp ./Demologicus_4_block_2.bin ../assets/playb700.gfx
cp ./Dual_Yellow_Energy_block_3.bin ../assets/playb200.gfx
cp ./Kernaw_Ingame_block_2.bin ../assets/playb000.gfx

# copy music
cp ./Night_block_1.bin ../assets/tmusb800.gfx
cp ./Paczka_TNQ_3_block_1.bin ../assets/fmusb800.gfx

