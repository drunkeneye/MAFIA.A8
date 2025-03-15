
var 
    nPlayers:   byte absolute VARBLOCK2;
    lastLocationStrings: byte absolute VARBLOCK2 + $1;
    currentChoice: byte absolute VARBLOCK2 + $2;
    showWeapons: byte absolute VARBLOCK2 + $3;
    plStuff: array[0..3] of byte absolute VARBLOCK2 + $4;
    plMoneyTransporter: array[0..3] of byte absolute VARBLOCK2 + $8;
    plKilledMajor: array[0..3] of byte absolute VARBLOCK2 + $C;
    plMoney:   array[0..3] of integer absolute VARBLOCK2 + $10;
    plFakeMoney:   array[0..3] of byte absolute VARBLOCK2 + $20;
    plAlcohol:   array[0..3] of byte absolute VARBLOCK2 + $24;
    plForgedID:   array[0..3] of byte absolute VARBLOCK2 + $28;
    plCar:   array[0..3] of byte absolute VARBLOCK2 + $2C;
    plSteps:   array[0..3] of shortint absolute VARBLOCK2 + $30;
    plMapPosX:   array[0..3] of byte absolute VARBLOCK2 + $34;
    plMapPosY:   array[0..3] of byte absolute VARBLOCK2 + $38;
    plCurrentMap:   array[0..3] of byte absolute VARBLOCK2 + $3C;
    plOpportunity:   array[0..3] of byte absolute VARBLOCK2 + $40;
    plLoan:   array[0..3] of SMALLINT absolute VARBLOCK2 + $44;
    plLoanTime:   array[0..3] of byte absolute VARBLOCK2 + $4C;
    plLoanShark:   array[0..3] of byte absolute VARBLOCK2 + $50;
    plRentMonths:   array[0..3] of byte absolute VARBLOCK2 + $54;
    plRentCost:   array[0..3] of byte absolute VARBLOCK2 + $58;
    plBribe:   array[0..3] of byte absolute VARBLOCK2 + $5C;
    plJob:   array[0..3] of byte absolute VARBLOCK2 + $60;
    plJobWage:   array[0..3] of word absolute VARBLOCK2 + $64;
    plJobLocation:   array[0..3] of word absolute VARBLOCK2 + $6C;
    plPrison:   array[0..3] of byte absolute VARBLOCK2 + $74;
    plRank:   array[0..3] of byte absolute VARBLOCK2 + $78;
    plPoints:   array[0..3] of byte absolute VARBLOCK2 + $7C;
    plNewPoints:   array[0..3] of shortint absolute VARBLOCK2 + $80;
    plLoanInvest: array[0..3] of word absolute VARBLOCK2 + $84;
    plFreed: array[0..3] of byte absolute VARBLOCK2 + $8C;


