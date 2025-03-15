DL_BLANK8 = %01110000;
DL_DLI = %10000000;
DL_LMS = %01000000;
DL_MODE_40x24T2 = 2; // Antic Modes
DL_MODE_40x24T5 = 4;
DL_MODE_40x12T5 = 5;
DL_JVB = %01000001;


.ifdef CART 
    icl 'const_car.inc'
.else 
    icl 'const_car.inc'
.endif


dl_start
    dta DL_BLANK8
    dta DL_BLANK8
    dta DL_DLI + DL_BLANK8
    dta DL_MODE_40x24T5 + DL_LMS, a(MAP_SCR_ADDRESS)
    :23-6 dta DL_MODE_40x24T5
    dta DL_MODE_40x24T5 + DL_DLI
    dta DL_MODE_40x24T2
    dta DL_MODE_40x24T2 + DL_DLI
    dta DL_MODE_40x24T2
    dta DL_MODE_40x24T2
    dta DL_MODE_40x24T2 + DL_DLI
    dta DL_JVB, a(dl_start)
