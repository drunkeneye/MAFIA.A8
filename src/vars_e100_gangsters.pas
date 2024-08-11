// $e090 is the first empty location after vars.pas


var
    gangsterMap: array[0..8] of byte absolute $e090;
    gangsterCount: byte absolute $e09a;
    tmpOpportunity: byte absolute $e09b; // stupid place
    plWinners: array[0..4] of byte absolute $e09c;
    plNWinners: byte absolute $e0a0;
    playMusic: byte absolute $e0a1;
    currentLocation:   byte absolute $e0a2;


 var
    plGang_1:   XString absolute $e0d4;
    plGang_2:   XString absolute $e0e4;
    plGang_3:   XString absolute $e0F4;
    plGang_4:   XString absolute $e104;
    plGang:   array[0..3] of ^XString =   (@plGang_1, @plGang_2, @plGang_3, @plGang_4);

    currentMonth: byte absolute $e152;
    currentYear: byte absolute $e153;
    gameLength:   byte absolute $e154;
    gamePoints:   word absolute $e155;
    lastAction: byte absolute $e157;

    gangsterName_1:   XString absolute $e158;
    gangsterName_2:   XString absolute $e168;
    gangsterName_3:   XString absolute $e178;
    gangsterName_4:   XString absolute $e188;
    gangsterName_5:   XString absolute $e198;
    gangsterName_6:   XString absolute $e1a8;
    gangsterName_7:   XString absolute $e1b8;
    gangsterName_8:   XString absolute $e1c8;
    gangsterName_9:   XString absolute $e1d8;
    gangsterName_10:   XString absolute $e1e8;
    gangsterName_11:   XString absolute $e1f8;
    gangsterName_12:   XString absolute $e208;
    gangsterName_13:   XString absolute $e218;
    gangsterName_14:   XString absolute $e228;
    gangsterName_15:   XString absolute $e238;
    gangsterName_16:   XString absolute $e248;
    gangsterName_17:   XString absolute $e258;
    gangsterName_18:   XString absolute $e268;
    gangsterName_19:   XString absolute $e278;
    gangsterName_20:   XString absolute $e288;
    gangsterName_21:   XString absolute $e298;
    gangsterName_22:   XString absolute $e2a8;
    gangsterName_23:   XString absolute $e2b8;
    gangsterName_24:   XString absolute $e2c8;
    gangsterName_25:   XString absolute $e2d8;
    gangsterName_26:   XString absolute $e2e8;
    gangsterName_27:   XString absolute $e2f8;
    gangsterName_28:   XString absolute $e308;
    gangsterName_29:   XString absolute $e318;
    gangsterName_30:   XString absolute $e328;
    gangsterName_31:   XString absolute $e338;
    gangsterName_32:   XString absolute $e348;
    

    gangsterStr:   array[0..31] of byte absolute $e358;
    gangsterInt:   array[0..31] of byte absolute $e378;
    gangsterBrut:   array[0..31] of byte absolute $e398;
    gangsterHealth:   array[0..31] of byte absolute $e3b8;
    gangsterWeapon:   array[0..31] of byte absolute $e3d8;
    gangsterSex: array[0..31] of byte absolute $e3f8;

    currentGangster:   byte absolute $e418;
    gameEnds:   byte absolute $e419;
    currentPlayer:   byte absolute $e41a;
    locCol:   byte absolute $e41b;
    plRent:   array[0..3] of byte absolute $e41c;
    currentMap:   Byte absolute $e420;

    plGangsters:   array[0..31] of byte absolute $e421; // denotes by byte the player to which they belong
    plNGangsters:   array[0..3] of byte absolute $e441; // is just the sum of the plGangsters == currentPlayers
    didFight: byte absolute $e445;
     



    // load this from disk, and copy over. 
    // could also preload sex/str/brut, but no real saving
    // THIS CAN BE OVERLAPPED WITH OTHER DATA 
    // THAT IS ONLY NEEDED WHEN NO GANGSTER IS SELECTED..
    buf_gangsterText1: YString absolute $e500;
    buf_gangsterText2: YString absolute $e528;
    buf_gangsterText3: YString absolute $e550;
    buf_gangsterText4: YString absolute $e578;
    buf_gangsterText5: YString absolute $e5a0;
    buf_gangsterAnrede: XString absolute $e5c8;
    buf_gangsterSex: byte absolute $e5d8;
    buf_gangsterStr: byte absolute $e5d9;
    buf_gangsterBrut: byte absolute $e5da;
    buf_gangsterInt: byte absolute $e5db;
    buf_gangsterWeapon: byte absolute $e5dc;
    buf_gangsterName: XString absolute $e5dd;
    buf_gangsterPrice: word absolute $e5ed;


    // $e700 
    // can put some normal variables here 

    // ea00-ec00 free 
    gangsterNames:   array[0..31] of ^XString =   (
                                                   @gangsterName_1, @gangsterName_2, @gangsterName_3, @gangsterName_4,
                                                   @gangsterName_5, @gangsterName_6, @gangsterName_7, @gangsterName_8,
                                                   @gangsterName_9, @gangsterName_10, @gangsterName_11, @gangsterName_12,
                                                   @gangsterName_13, @gangsterName_14, @gangsterName_15, @gangsterName_16,
                                                   @gangsterName_17, @gangsterName_18, @gangsterName_19, @gangsterName_20,
                                                   @gangsterName_21, @gangsterName_22, @gangsterName_23, @gangsterName_24,
                                                   @gangsterName_25, @gangsterName_26, @gangsterName_27, @gangsterName_28,
                                                   @gangsterName_29, @gangsterName_30, @gangsterName_31, @gangsterName_32
                                                  );
 
    //
