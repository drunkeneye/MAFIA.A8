
// memory map
// 0000-0c00 is xbios

// 0c00-c000 is program+data

// c000-c800 is own data/loading area

TXT_ADDRESS = $c800;
MAINFONT_ADR = $cc00;

// D000-D800 is chipset

PMG_BASE_ADR = $d800;

// is here some space?

// $e000-$f000 is own variables

MAP_FNT_ADDRESS = $f000;
MAP_SCR_ADDRESS = $f400;
LOC_MAP_ADR = $f800; // could be used as second font 
DL_CONSOLE_ADR = $fc00; // $1f bytes as is
DL_BLACK_CONSOLE_ADR = $fc40; //$6 bytes as is
DL_MAP_ADR = $fc80; // $1f bytes as is 

 // to load graphics
XEX_ADDRESS = $2000-6; //?
