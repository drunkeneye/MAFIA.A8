
function fightPolice ():   byte;
begin;
    CRT_NewLine;
    CRT_Write(police_string_1);
    waitForKey();
    prepareFightAgainstPolice();
    if doFight() = 1 then
    begin;
        gotCaught();
        result := END_TURN_;
        exit;
    end;
    addPoints(1); // fight won 
end;
