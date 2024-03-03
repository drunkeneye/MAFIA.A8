
program autorun;


{$define basicoff}
{$librarypath '../../tools/Mad-Pascal/blibs/'}
{$librarypath '../../tools/Mad-Pascal/base/'}
{$librarypath '../../tools/Mad-Pascal/lib/'}

{$r ./resources_title.rc}


uses atari, joystick, pmg, xbapLib, xbios, crt, cio, aplib, b_utils, rmt, b_pmg, sysutils, b_system, b_crt;

const 
    baseAddress =   $BE80;
    e7adr =   $e700;

var  // for sprites 
    stick :   byte absolute $278;
    PCOLR0:   byte absolute $D012;
    PCOLR1:   byte absolute $D013;
    PCOLR2:   byte absolute $D014;
    PCOLR3:   byte absolute $D015;
    playerPos_X:   byte absolute e7adr + 936+16;
    // not used 
    loccolbk:            Byte absolute baseAddress + $2B0 + 41 * $28;
    loccolpf0:            Byte absolute baseAddress + $2B0 + 41 * $28 + 1;
    loccolpf1:            Byte absolute baseAddress + $2B0 + 41 * $28 + 2;
    loccolpf2:            Byte absolute baseAddress + $2B0 + 41 * $28 + 3;


const 
{$i const.inc}

{$I interrupts.inc}
{$i console.pas}
 
const 
   D_LOGO           =   'LOGO    APL';

    ADR_LOGO         =   $8036;
    // DL GR.8 $8036; GFX $8150
    ADR_LOGO_DL      =   ADR_LOGO;
    ADR_LOGO_GFX     =   $8150;

    L_COLOR1         =   $9c;
    L_COLOR2         =   $12;
    L_COLOR4         =   $12;
 
 

procedure show_logo;
begin
    xbunAPL(D_LOGO, pointer(ADR_LOGO));
    COLOR1 := L_COLOR1;
    COLOR2 := L_COLOR2;
    COLOR4 := L_COLOR4;
    SDLSTL := ADR_LOGO_DL;
    SAVMSC := ADR_LOGO_GFX;
end;


var 
    cs:   word;
    finalfname:   String[16];
begin 
    DMACTL := $22;
    asm;
    pha
    jsr xbios.xBIOS_SET_DEFAULT_DEVICE
    lda #$00
    sta xbios.xIRQEN
    pla
end;

// check xbios from StarVagrant
cs := dPeek($0800);
if (char(Lo(cs)) <> 'x') or (char(Hi(cs)) <> 'B') then
    // make it crash if no xbios is there
    repeat;
        CRT_Write('NO XBIOS!'~);
    until false;

show_logo();
// waitframes somehow do not work whatever
// just load logo again, fin.
Delay(3000);
asm
  jsr $5000
end;

finalfname := 'MAIN    XEX';
xBiosLoadFile (finalfname);
end.
