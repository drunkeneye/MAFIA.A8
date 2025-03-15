
// memory map
// 0000-0c00 is xbios

// 0c00-b000 is program+data


// be80-c800 is own data/loading area
// load a single byte there and hope that madpascal
// will detect overlap with music then
DUMMY_BE80 = $be80;

LOCATION_ADR = $c000; // $c000-c91c

TXT_ADDRESS = $c800;
MAINFONT_ADR = $cc00;

// D000-D800 is chipset

PMG_BASE_ADR = $d800;

// is here some space?

// $e000-$f000 is own variables

MAP_FNT_ADDRESS = $f000;
MAP_SCR_ADDRESS = $f400;
LOC_MAP_ADR = $f800; // could be used as second font

DL_BITMAP_ADR = $ff00; //not used
DL_CONSOLE_ADR = $ff80; // $1f bytes as is
DL_MAP_ADR = $ffa0; // $1f bytes as is
DL_BLACK_CONSOLE_ADR = $ffc8; //$7 bytes as is


 // to load graphics
XEX_ADDRESS = $2000-6; //?


// new: sap
SAP_PLAYER = $b000;
SAP_PLAYER_3 = $b003;
SAP_PLAYER_6 = $b006;
