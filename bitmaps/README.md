- copy the png images into ./images
- convert them to 320x200 in size and maybe 8-bit palette
  [~/dropbox/atarixe/mafia/bitmaps/images]..$ convert ./an_end_screen_for_an_atari_game_depicting_a_maf.jpg +dither -colors 256 -background black -resize 320x200\! ./final.png


- start batchRun.py
- will generate in outputs/ a .xex for each png in ./images
- call prepare_bitmaps.py to copy the things over to ./src
- this will prepare ../assets/<ID>mic/pmg/asm.gfx that can be loaded/used
