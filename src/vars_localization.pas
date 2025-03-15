
var
    carPrices: array[0..5] of word absolute E7_ADR;
    carCargo: array[0..5] of byte absolute E7_ADR + $C;
    carRange: array[0..5] of byte absolute E7_ADR + $12;
    weaponPrices: array[0..8] of word absolute E7_ADR + $18;
    weaponReach: array[0..8] of byte absolute E7_ADR + $2a;
    weaponPrecision: array[0..8] of byte absolute E7_ADR + $33;
    weaponEffect: array[0..8] of byte absolute E7_ADR + $3c;
    weaponSound: array[0..8] of byte absolute E7_ADR + $45;

    fntname: TString absolute E7_ADR + $4e;
    wanted_m_fname: TString absolute E7_ADR + $5e;
    wanted_f_fname: TString absolute E7_ADR + $6e;
    fight_map_fname: TString absolute E7_ADR + $7e;
    gangsterFilename: TString absolute E7_ADR + $8e;

    LOCABANKfname: TString absolute E7_ADR + $9e;
    LOCAFORGfname: TString absolute E7_ADR + $Ae;
    LOCAMONYfname: TString absolute E7_ADR + $Be;
    LOCALOANfname: TString absolute E7_ADR + $Ce;
    LOCAPOLIfname: TString absolute E7_ADR + $De;
    LOCACARSfname: TString absolute E7_ADR + $Ee;
    LOCAPUBBfname: TString absolute E7_ADR + $Fe;
    LOCAPUBCfname: TString absolute E7_ADR + $10e;
    LOCASTORfname: TString absolute E7_ADR + $11e;
    LOCAHIDEfname: TString absolute E7_ADR + $12e;
    LOCAGAMBfname: TString absolute E7_ADR + $13e;
    LOCASUBWfname: TString absolute E7_ADR + $14e;
    LOCAARMSfname: TString absolute E7_ADR + $15e;
    LOCAMAINfname: TString absolute E7_ADR + $16e;
    LOCAJOBBfname: TString absolute E7_ADR + $17e;
    LOCAMAJOfname: TString absolute E7_ADR + $18e;
    LOCACOURfname: TString absolute E7_ADR + $19e;
    LOCACAUGfname: TString absolute E7_ADR + $1Ae;
    LOCAROADfname: TString absolute E7_ADR + $1Be;
    LOCAUPDTfname: TString absolute E7_ADR + $1Ce;
    LOCASETUfname: TString absolute E7_ADR + $1De;
    LOCACENTfname: TString absolute E7_ADR + $1Ee;
    LOCACREDfname: TString absolute E7_ADR + $1Fe;

    rank_1: TString absolute E7_ADR + $20e;
    rank_2: TString absolute E7_ADR + $21e;
    rank_3: TString absolute E7_ADR + $22e;
    rank_4: TString absolute E7_ADR + $23e;
    rank_5: TString absolute E7_ADR + $24e;
    rank_6: TString absolute E7_ADR + $25e;
    rank_7: TString absolute E7_ADR + $26e;
    rank_8: TString absolute E7_ADR + $27e;
    rank_9: TString absolute E7_ADR + $28e;
    rank_10: TString absolute E7_ADR + $29e;
    rank_11: TString absolute E7_ADR + $2Ae;

    weaponName_1: TString absolute E7_ADR + $2Be;
    weaponName_2: TString absolute E7_ADR + $2Ce;
    weaponName_3: TString absolute E7_ADR + $2De;
    weaponName_4: TString absolute E7_ADR + $2Ee;
    weaponName_5: TString absolute E7_ADR + $2Fe;
    weaponName_6: TString absolute E7_ADR + $30e;
    weaponName_7: TString absolute E7_ADR + $31e;
    weaponName_8: TString absolute E7_ADR + $32e;
    weaponName_9: TString absolute E7_ADR + $33e;

    carNames_1: TString absolute E7_ADR + $34e;
    carNames_2: TString absolute E7_ADR + $35e;
    carNames_3: TString absolute E7_ADR + $36e;
    carNames_4: TString absolute E7_ADR + $37e;
    carNames_5: TString absolute E7_ADR + $38e;
    carNames_6: TString absolute E7_ADR + $39e;

    playerPos_X: byte absolute E7_ADR + $3Ae;
    playerPos_Y: byte absolute E7_ADR + $3Af;
    mapPos_X: byte absolute E7_ADR + $3B0;
    mapPos_Y: byte absolute E7_ADR + $3B1;
    oldMapPos_X: byte absolute E7_ADR + $3B2;
    oldMapPos_Y: byte absolute E7_ADR + $3B3;
    oldPlayerPos_X: byte absolute E7_ADR + $3B4;
    oldPlayerPos_Y: byte absolute E7_ADR + $3B5;

    fpPosStart: array[0..16*2-1] of word absolute E7_ADR + $3B6;
    mapColorA: byte absolute E7_ADR + $3F6;
    mapColorB: byte absolute E7_ADR + $3F7;
    spriteMoveDir: shortint absolute E7_ADR + $3F8;
    joystickused: byte absolute E7_ADR + $3F9;

    fight_string_1: XString absolute E7_ADR + $3Fa;
    fight_string_2: XString absolute E7_ADR + $40a;
    fight_string_3: XString absolute E7_ADR + $41a;
    fight_string_4: XString absolute E7_ADR + $42a;
    fight_string_5: XString absolute E7_ADR + $43a;
    fight_string_6: XString absolute E7_ADR + $44a;
    waitKey_String: YString absolute E7_ADR + $45a;
    map_string_weapon: XString absolute E7_ADR + $482;
    map_string_gangster: XString absolute E7_ADR + $492;
    map_string_rent: XString absolute E7_ADR + $4a2;
    map_string_bribe: XString absolute E7_ADR + $4b2;
    map_string_car: XString absolute E7_ADR + $4c2;
    map_string_steps: XString absolute E7_ADR + $4d2;
    map_string_cargo: XString absolute E7_ADR + $4e2;
    map_string_money: XString absolute E7_ADR + $4f2;
    map_string_credit: XString absolute E7_ADR + $502;
    fight_police_string_1: XString absolute E7_ADR + $512;
    fight_police_string_2: XString absolute E7_ADR + $522;
    not_enough_money_string: YString absolute E7_ADR + $532;
    your_choice_string: XString absolute E7_ADR + $55a;
    police_string_1: YString absolute E7_ADR + $56a;
    len_string_bribe: byte absolute E7_ADR + $592;
    fight_string_7: XString absolute E7_ADR + $593;
    // 5a3 is the next string
	

var
    rankNames: array[0..10] of ^TString = (@rank_1, @rank_2, @rank_3, @rank_4, @rank_5, @rank_6, @rank_7,
                                @rank_8, @rank_9, @rank_10, @rank_11);
    weaponNames: array[0..8] of ^TString = (@weaponName_1, @weaponName_2, @weaponName_3, @weaponName_4,
                                @weaponName_5, @weaponName_6, @weaponName_7, @weaponName_8, @weaponName_9);
    carNames:   array[0..5] of ^TString =   (@carNames_1, @carNames_2,@carNames_3,@carNames_4,@carNames_5,@carNames_6);



var 
{$ifdef LOCATION_PL}
    e7fname: TString = 'E700PAGEAPL';
{$endif}
{$ifdef LOCATION_DE}
    e7fname: TString = 'E700PAGEADE';
{$endif}
{$ifdef LOCATION_EN}
    e7fname: TString = 'E700PAGEAEN';
{$endif}


    saveFname: TString = 'SAVEGAMEDAT';
    //finalfname: TString = 'FINAL   XEX';
    //finalfname: TString = 'XAUTORUN   ';
    finalfname: TString;// = 'FINALMAPAPL';
    mapReloaded: Byte;
    spriteOffset: byte;
    showBitmaps: byte;

var  // for sprites 
    stick :   byte absolute $278;
    PCOLR0:   byte absolute $D012;
    PCOLR1:   byte absolute $D013;
    PCOLR2:   byte absolute $D014; 
    PCOLR3:   byte absolute $D015;


// COLPF2 is for background and text luminosity
// COLPF1 is for text color/brightness