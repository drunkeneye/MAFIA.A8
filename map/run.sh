#!/bin/bash

# magick -size 256x1 gradient:gray -colorspace Gray -normalize -fill "gray(0,0,0)" -draw "rectangle 0,0 127,1" -fill "gray(91,91,91)" -draw "rectangle 128,0 192,1" -fill "gray(169,169,169)" -draw "rectangle 192,0 224,1" -fill "gray(255,255,255)" -draw "rectangle 224,0 255,1"  clut.png
# for z in *.jpeg; do magick $z -interpolate Nearest -filter point  -resize 50x100! -colorspace Gray -normalize -colors 5 -normalize -colors 5  -remap clut.png  PNG8:"../${z%.jpeg}.png"; done

python3 ./convertSprites.py
python3 ./convertMap.py
python3 ./generateFightmaps.py
python3 ./generateMapBitmaps.py

