// $e090 is the first empty location after vars.pas


var
    gangsterMap: array[0..8] of byte absolute VARBLOCK1;
    gangsterCount: byte absolute VARBLOCK1+$0A;
    tmpOpportunity: byte absolute VARBLOCK1+$0B; // stupid place
    plWinners: array[0..4] of byte absolute VARBLOCK1+$0C;
    plNWinners: byte absolute VARBLOCK1+$10;
    playMusic: byte absolute VARBLOCK1+$11;
    currentLocation: byte absolute VARBLOCK1+$12;


var
    plGang_1: XString absolute VARBLOCK1+$44;
    plGang_2: XString absolute VARBLOCK1+$54;
    plGang_3: XString absolute VARBLOCK1+$64;
    plGang_4: XString absolute VARBLOCK1+$74;
    plGang: array[0..3] of ^XString = (@plGang_1, @plGang_2, @plGang_3, @plGang_4);

    currentMonth: byte absolute VARBLOCK1+$C2;
    currentYear: byte absolute VARBLOCK1+$C3;
    gameLength: byte absolute VARBLOCK1+$C4;
    gamePoints: word absolute VARBLOCK1+$C5;
    lastAction: byte absolute VARBLOCK1+$C7;

    gangsterName_1: XString absolute VARBLOCK1+$C8;
    gangsterName_2: XString absolute VARBLOCK1+$D8;
    gangsterName_3: XString absolute VARBLOCK1+$E8;
    gangsterName_4: XString absolute VARBLOCK1+$F8;
    gangsterName_5: XString absolute VARBLOCK1+$108;
    gangsterName_6: XString absolute VARBLOCK1+$118;
    gangsterName_7: XString absolute VARBLOCK1+$128;
    gangsterName_8: XString absolute VARBLOCK1+$138;
    gangsterName_9: XString absolute VARBLOCK1+$148;
    gangsterName_10: XString absolute VARBLOCK1+$158;
    gangsterName_11: XString absolute VARBLOCK1+$168;
    gangsterName_12: XString absolute VARBLOCK1+$178;
    gangsterName_13: XString absolute VARBLOCK1+$188;
    gangsterName_14: XString absolute VARBLOCK1+$198;
    gangsterName_15: XString absolute VARBLOCK1+$1A8;
    gangsterName_16: XString absolute VARBLOCK1+$1B8;
    gangsterName_17: XString absolute VARBLOCK1+$1C8;
    gangsterName_18: XString absolute VARBLOCK1+$1D8;
    gangsterName_19: XString absolute VARBLOCK1+$1E8;
    gangsterName_20: XString absolute VARBLOCK1+$1F8;
    gangsterName_21: XString absolute VARBLOCK1+$208;
    gangsterName_22: XString absolute VARBLOCK1+$218;
    gangsterName_23: XString absolute VARBLOCK1+$228;
    gangsterName_24: XString absolute VARBLOCK1+$238;
    gangsterName_25: XString absolute VARBLOCK1+$248;
    gangsterName_26: XString absolute VARBLOCK1+$258;
    gangsterName_27: XString absolute VARBLOCK1+$268;
    gangsterName_28: XString absolute VARBLOCK1+$278;
    gangsterName_29: XString absolute VARBLOCK1+$288;
    gangsterName_30: XString absolute VARBLOCK1+$298;
    gangsterName_31: XString absolute VARBLOCK1+$2A8;
    gangsterName_32: XString absolute VARBLOCK1+$2B8;

    gangsterStr: array[0..31] of byte absolute VARBLOCK1+$2C8;
    gangsterInt: array[0..31] of byte absolute VARBLOCK1+$2E8;
    gangsterBrut: array[0..31] of byte absolute VARBLOCK1+$308;
    gangsterHealth: array[0..31] of byte absolute VARBLOCK1+$328;
    gangsterWeapon: array[0..31] of byte absolute VARBLOCK1+$348;
    gangsterSex: array[0..31] of byte absolute VARBLOCK1+$368;

    currentGangster: byte absolute VARBLOCK1+$388;
    gameEnds: byte absolute VARBLOCK1+$389;
    currentPlayer: byte absolute VARBLOCK1+$38A;
    locCol: byte absolute VARBLOCK1+$38B;
    plRent: array[0..3] of byte absolute VARBLOCK1+$38C;
    currentMap: Byte absolute VARBLOCK1+$390;

    plGangsters: array[0..31] of byte absolute VARBLOCK1+$391;
    plNGangsters: array[0..3] of byte absolute VARBLOCK1+$3B1;
    didFight: byte absolute VARBLOCK1+$3B5;

    // is here really a gap of around $a0 bytes or so??
    saveGameMagic: word absolute VARBLOCK1+$3C0;

    // load this from disk, and copy over. 
    // could also preload sex/str/brut, but no real saving
    // THIS CAN BE OVERLAPPED WITH OTHER DATA 
    // THAT IS ONLY NEEDED WHEN NO GANGSTER IS SELECTED..

    buf_gangsterText1: YString absolute VARBLOCK1+$470;
    buf_gangsterText2: YString absolute VARBLOCK1+$498;
    buf_gangsterText3: YString absolute VARBLOCK1+$4C0;
    buf_gangsterText4: YString absolute VARBLOCK1+$4E8;
    buf_gangsterText5: YString absolute VARBLOCK1+$510;
    buf_gangsterAnrede: XString absolute VARBLOCK1+$538;
    buf_gangsterSex: byte absolute VARBLOCK1+$548;
    buf_gangsterStr: byte absolute VARBLOCK1+$549;
    buf_gangsterBrut: byte absolute VARBLOCK1+$54A;
    buf_gangsterInt: byte absolute VARBLOCK1+$54B;
    buf_gangsterWeapon: byte absolute VARBLOCK1+$54C;
    buf_gangsterName: XString absolute VARBLOCK1+$54D;
    buf_gangsterPrice: word absolute VARBLOCK1+$55D;


    gangsterNames: array[0..31] of ^XString = (
        @gangsterName_1, @gangsterName_2, @gangsterName_3, @gangsterName_4,
        @gangsterName_5, @gangsterName_6, @gangsterName_7, @gangsterName_8,
        @gangsterName_9, @gangsterName_10, @gangsterName_11, @gangsterName_12,
        @gangsterName_13, @gangsterName_14, @gangsterName_15, @gangsterName_16,
        @gangsterName_17, @gangsterName_18, @gangsterName_19, @gangsterName_20,
        @gangsterName_21, @gangsterName_22, @gangsterName_23, @gangsterName_24,
        @gangsterName_25, @gangsterName_26, @gangsterName_27, @gangsterName_28,
        @gangsterName_29, @gangsterName_30, @gangsterName_31, @gangsterName_32
    );
