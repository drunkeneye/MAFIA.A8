
// memory map
// 0000-0c00 is xbios

// 0c00-b000 is program+data


// b000-c000 these should not be loaded, but stay 'fixed', 
// hopefully avoiding crashing while loading from CAR
TXT_ADDRESS = $b000;
MAINFONT_ADR = $b400;
PMG_BASE_ADR = $b800;

// c000-c91f is own data/loading area
LOCATION_ADR = $c000; // $c000-c91c

// rearrange block1/2 to ensure that block2 is at $c920
// and gets written first. so the first byte in a save game 
// must be 1-4 (number of players)
VARBLOCK2 = $c920; // $c920-c9b0 or so
VARBLOCK1 = $ca00; // $c920-ce80


// VARBLOCK1 = $c920; // $c920-ce80
// VARBLOCK2 = $cf00; // $cf00-cf90

// D000-D800 is chipset

MAP_FNT_ADDRESS = $d800;
MAP_SCR_ADDRESS = $dc00;
LOC_MAP_ADR = $e000; // could be used as second font, but we dont.


// $e400-$f000 is own variables
VARFIGHT = $e400; // around $300, end is less then $e700
E7_ADR = $e700;


// f000-ff00 is for sfx/music
RMT_PLAYER = $f000;
RMT_MODUL = $f700;

DL_CONSOLE_ADR = $ff70; // $1f bytes as is
DL_MAP_ADR = $ff90; // $1f bytes as is
DL_BLACK_CONSOLE_ADR = $ffb0; //$7 bytes as is
DL_BITMAP_ADR = $ffb8; //$7 bytes as is

 // to load graphics
XEX_ADDRESS = $2000-6; //?


// new: sap
SAP_PLAYER = $b000;
SAP_PLAYER_3 = $b003;
SAP_PLAYER_6 = $b006;


