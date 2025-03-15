{$DEFINE ROMOFF}    // http://mads.atari8.info/doc/en/syntax/#romoff
{$DEFINE NOROMFONT}

program autorun;


{$define basicoff}
{$librarypath '../../tools/Mad-Pascal-1.7.2/blibs/'}
{$librarypath '../../tools/Mad-Pascal-1.7.2/base/'}
{$librarypath '../../tools/Mad-Pascal-1.7.2/lib/'}

{$r ./resources_car.rc}


uses atari, pmg, xbios, crt, cio, aplib, b_utils, rmt, b_pmg, sysutils, b_system, b_crt;

const
{$i const_car.inc}

// these are mainly needed to allow inclusion of files
// that are part of the game. else we get undefined variables etc.

type
    XString =   String[15];
    YString =   String[40];

var
    stick :   byte absolute $278;
    PCOLR0:   byte absolute $D012;
    PCOLR1:   byte absolute $D013;
    PCOLR2:   byte absolute $D014;
    PCOLR3:   byte absolute $D015;
    playerPos_X:   byte;
    spriteMoveDir: shortint;
    joystickused: byte;

    mapColorA: byte;
    mapColorB: byte;
    acolpf0, acolpf1, acolpf2, acolpf3, acolbk: byte;

    playMusic: byte absolute $e0a1;
	msx: TRMT;


procedure musicproxy();
begin;
    if playMusic = 1 then
        msx.play();
end;


{$I interrupts.inc}
{$I xbaplib.pas}
{$i console.pas}
{$i helpers_input.pas}


var
    D_LOGO: TString = 'LOGO    APL';
    D_TITLE: TString = 'TITLEPICAPL';
    D_MPLAY: TString = 'PLAYB000APL';
    D_MUS: TString = 'TMUSB800APL';
    locfname:   TString;
    e7fname: TString = 'E700PAGEAPL';

const
    e7adrm6 = $e600-6;
    ADR_LOGO         =   $9036;
    // DL GR.8 $9036; GFX $9150
    ADR_LOGO_DL      =   ADR_LOGO;
    ADR_LOGO_GFX     =   $9150;
    DL_LOGO_ADR      =   $fc80;
    L_COLOR1         =   $9c;
    L_COLOR2         =   $12;


var
    loccolbk:             Byte absolute LOCATION_ADR + $2B0 + 41 * $28; 
    loccolpf0:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 1;
    loccolpf1:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 2;
    loccolpf2:            Byte absolute LOCATION_ADR + $2B0 + 41 * $28 + 3; // $c91b




var
    cpos, tmpcol, tmpDMACTL: byte;
    cs:   word;
    finalfname:   String[16];
    flags_fname: TString = 'FLAGSBMPAPL';
    ch:char;
    tmpch:char;
begin;
    playMusic := 0;

    // force inclusion of musciproxy, wont be executed here, but needed for DLIs
    if playMusic = 99 then
        musicproxy();

    DMACTL := $22;
    asm;
        pha
        jsr xbios.xBIOS_SET_DEFAULT_DEVICE
        lda #$00
        sta xbios.xIRQEN
        pla
    end;

    // needed else__DLIVEC is not defined (and DLI wont work as well i think)
    SystemOff;

    enableConsole();
    msx.player:=pointer(rmt_player);
    msx.modul:=pointer(rmt_modul);
    //msx.init(0); // $b for pacmad=silence
    msx.play();
    playMusic := 1;
    // waitFrames (120);

    repeat;
        for cpos := 0 to 55 do 
        begin;
            msx.sfx(cpos, 2, 5);
            waitFrames (30);
            msx.sfx(cpos, 2, 55);
            waitFrames (30);
            msx.sfx(cpos, 2, 155);
            waitFrames (30);
        end;
    until false;
    repeat; until false;
end.
