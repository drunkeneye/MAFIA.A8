
const 
    varAdresse = $e000;

type 
    XString =   String[15];
    YString =   String[40];


var 
    // bits: 0=mail train robbed, 1=killed major, 2=forged ID, 3=fake money,
    // 4=safe tutorial, 5=...
    
    nPlayers:   byte absolute varAdresse;
    lastLocationStrings: byte absolute varAdresse + 1;
    plStuff: array[0..3] of byte absolute $e004;
    plMoneyTransporter: array[0..3] of byte absolute $e008;
    plKilledMajor: array[0..3] of byte absolute $e00c;
    plMoney:   array[0..3] of integer absolute $e010; // this is 4 bytes = 16 bytes
    plFakeMoney:   array[0..3] of byte absolute $e020;
    plAlcohol:   array[0..3] of byte absolute $e024;
    plForgedID:   array[0..3] of byte absolute $e028;
    plCar:   array[0..3] of byte absolute $e02C;
    plSteps:   array[0..3] of shortint absolute $e030;
    plMapPosX:   array[0..3] of byte absolute $e034;
    plMapPosY:   array[0..3] of byte absolute $e038;
    plCurrentMap:   array[0..3] of byte absolute $e03C;
    plOpportunity:   array[0..3] of byte absolute $e040; // for extra money
    plLoan:   array[0..3] of SMALLINT absolute $e044;
    // 2 bytes * 4 = 8 bytes
    plLoanTime:   array[0..3] of byte absolute $e04C;
    plLoanShark:   array[0..3] of byte absolute $e050;
    plRentMonths:   array[0..3] of byte absolute $e054;
    plRentCost:   array[0..3] of byte absolute $e058;
    plBribe:   array[0..3] of byte absolute $e05C;

    plJob:   array[0..3] of byte absolute $e060;
    plJobWage:   array[0..3] of word absolute $e064;
    plJobLocation:   array[0..3] of word absolute $e06C;

    plPrison:   array[0..3] of byte absolute $e074;
    plRank:   array[0..3] of byte absolute $e078;
    plPoints:   array[0..3] of byte absolute $e07C;
    plNewPoints:   array[0..3] of shortint absolute $e080;
    plLoanInvest: array[0..3] of word absolute $e084;
    plFreed: array[0..3] of byte absolute $e08c;
    // 1 byte * 16 = 16 bytes
 
 const 
    e7adr = $e700;

var 
    carPrices:   array[0..5] of byte  absolute e7adr;
    carCargo:   array[0..5] of byte absolute e7adr + 6;
    carRange:   array[0..5] of byte absolute e7adr + 12;
    weaponPrices:   array[0..8] of word absolute e7adr + 18;
    weaponReach:   array[0..8] of byte absolute e7adr + 36;
    weaponPrecision:   array[0..8] of byte absolute e7adr + 45;
    weaponEffect:   array[0..8] of byte absolute e7adr + 54; // how much damage will the hit do
    weaponSound:   array[0..8] of byte absolute e7adr + 63;

    fntname:   TString  absolute e7adr + 72;
    wanted_m_mfname:   TString  absolute e7adr + 88;
    wanted_m_msname:   TString absolute e7adr + 104;
    wanted_f_mfname:   TString absolute e7adr + 120;
    wanted_f_msname:   TString absolute e7adr + 136;
    fightscrname:   TString absolute e7adr + 152;
    fightfntname:   TString absolute e7adr + 168;
    gangsterFilename: TString absolute e7adr + 184;
    
    LOCABANKfname: TString absolute e7adr + 200;
    LOCAFORGfname: TString absolute e7adr + 216;
    LOCAMONYfname: TString absolute e7adr + 232;
    LOCALOANfname: TString absolute e7adr + 248;
    LOCAPOLIfname: TString absolute e7adr + 264;
    LOCACARSfname: TString absolute e7adr + 280;
    LOCAPUBBfname: TString absolute e7adr + 296;
    LOCAPUBCfname: TString absolute e7adr + 312;
    LOCASTORfname: TString absolute e7adr + 328;
    LOCAHIDEfname: TString absolute e7adr + 344;
    LOCAGAMBfname: TString absolute e7adr + 360;
    LOCASUBWfname: TString absolute e7adr + 376;
    LOCAARMSfname: TString absolute e7adr + 392;
    LOCAMAINfname: TString absolute e7adr + 408;
    LOCAJOBBfname: TString absolute e7adr + 424;
    LOCMAJOfname: TString absolute e7adr + 440;
    LOCACOURfname: TString absolute e7adr + 456;
    LOCACAUGfname: TString absolute e7adr + 472;
    LOCAROADfname: TString absolute e7adr + 488;
    LOCAUPDTfname: TString absolute e7adr + 504;
    LOCASETUfname: TString absolute e7adr + 520;

    rank_1: TString absolute e7adr + 536;
    rank_2: TString absolute e7adr + 552;
    rank_3: TString absolute e7adr + 568;
    rank_4: TString absolute e7adr + 584;
    rank_5: TString absolute e7adr + 600;
    rank_6: TString absolute e7adr + 616;
    rank_7: TString absolute e7adr + 632;
    rank_8: TString absolute e7adr + 648;
    rank_9: TString absolute e7adr + 664;
    rank_10: TString absolute e7adr + 680;
    rank_11: TString absolute e7adr + 696;

    weaponName_1: TString absolute e7adr + 712;
    weaponName_2: TString absolute e7adr + 728;
    weaponName_3: TString absolute e7adr + 744;
    weaponName_4: TString absolute e7adr + 760;
    weaponName_5: TString absolute e7adr + 776;
    weaponName_6: TString absolute e7adr + 792;
    weaponName_7: TString absolute e7adr + 808;
    weaponName_8: TString absolute e7adr + 824;
    weaponName_9: TString absolute e7adr + 840;

    carNames_1: TString absolute e7adr + 856;
    carNames_2: TString absolute e7adr + 872;
    carNames_3: TString absolute e7adr + 888;
    carNames_4: TString absolute e7adr + 904;
    carNames_5: TString absolute e7adr + 920;
    carNames_6: TString absolute e7adr + 936;

// const 
//     // weaponStrength:   array[0..8] of TString =   ('mies'~, 'ganz gut'~, 'todsicher'~, 'laecherlich'~,
//     //                                                  'maessig'~, 'schlimm!'~, 'brutal'~, 'erschreckend!'~, 'bombastisch!'~);
//     rankNames:   array[0..10] of TString =   ('Anfaenger'~, 'Schlaeger'~, 'Kleiner Fisch'~,
//                                                 'Langfinger'~, 'Ganove'~, 'Mafiosi'~, 'Bullenschreck'~, 'Meuchelmoerder'~,
//                                                 'Gangsterboss', 'Rechte Hand'~,  'Der Pate'~);
//     weaponNames:   array[0..8] of TString =   ('Haende'~, 'Messer'~, 'Knueppel'~,
//                                                   'Schlagkette'~, 'Wurfsterne'~, 'Revolver'~,
//                                                   'Gewehr'~, 'Maschinengewehr'~, 'Handgranaten'~);
//     carNames:   array[0..5] of TString =   ('Fuesse'~, 'Talbot 90'~, 'Chevy Roadster'~, 'Buick Century'~, 'Auburn 120'~, 'Citroen t.a.'~);

    rankNames: array[0..10] of ^TString = (@rank_1, @rank_2, @rank_3, @rank_4, @rank_5, @rank_6, @rank_7,
                                @rank_8, @rank_9, @rank_10, @rank_11);

    weaponNames: array[0..8] of ^TString = (@weaponName_1, @weaponName_2, @weaponName_3, @weaponName_4,
                                @weaponName_5, @weaponName_6, @weaponName_7, @weaponName_8, @weaponName_9);
    carNames:   array[0..5] of ^TString =   (@carNames_1, @carNames_2,@carNames_3,@carNames_4,@carNames_5,@carNames_6);


    playerPos_X: byte absolute e7adr + 936+16;
    playerPos_Y:   byte absolute e7adr + 937+16;
    mapPos_X:   byte absolute e7adr + 938+16;
    mapPos_Y:   byte absolute e7adr + 939+16;
    oldMapPos_X:   byte absolute e7adr + 940+16;
    oldMapPos_Y:   byte absolute e7adr + 941+16;
    oldPlayerPos_X:   byte absolute e7adr + 942+16;
    oldPlayerPos_Y:   byte absolute e7adr + 943+16;
    
    fpPosStart:   array[0..16*2-1] of word absolute e7adr+944+16; 
    LOCACENTfname: TString absolute e7adr + 944+16+64;


var 
    e7fname: TString = 'E700PAGEAPL';
    saveFname: TString = 'SAVEGAMEDAT';
    //finalfname: TString = 'FINAL   XEX';
    //finalfname: TString = 'XAUTORUN   ';
    finalfname: TString = 'FINALMAPAPL';
    mapReloaded: Byte;

var  // for sprites 
    stick :   byte absolute $278;
    PCOLR0:   byte absolute $D012;
    PCOLR1:   byte absolute $D013;
    PCOLR2:   byte absolute $D014; 
    PCOLR3:   byte absolute $D015;


// COLPF2 is for background and text luminosity
// COLPF1 is for text color/brightness