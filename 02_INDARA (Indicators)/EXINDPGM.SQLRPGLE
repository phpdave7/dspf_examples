**free
// Example program showing how to use INDARA indicators
// to control field attributes in the display file.

ctl-opt  option(*srcstmt: *nodebugio) actgrp('EXAMPLES');


// Display file uses INFDS for the AID byte and INDDS for indicators
//   INDDS ties a DS of indicators to the INDARA display file
dcl-f  EXINDDSPF   workstn
                   infds(dspf_info)
                   indds(dspf_inds);

// AID byte from the display file
dcl-ds  dspf_info;
  keyPressed    char(1)  pos(369);
end-ds;

// Indicator data structure for field colors
dcl-ds  dspf_inds;
  colors  char(3)  pos(1);      // 3 bytes of indicators as a block
                                 // overlays the INDARA area
    red       ind  pos(1);
    white     ind  pos(2);
    blue      ind  pos(3);
end-ds;

/include EXFKEY


// Exit when F3 is pressed
dou keyPressed = F3;       // loop until the F3 AID value arrives

    // Show the screen
    exfmt R01;        // EXFMT writes then reads the display

    // Clear indicator values before setting them
    clear colors;

    // Turn on the indicator that matches the color typed
    select;
        when R1MSG = 'WHITE';
            white = *ON;
        when R1MSG = 'RED';
            red = *ON;
        when R1MSG = 'BLUE';
            blue = *ON;
    endsl;

enddo;  // loop until F3

*inlr = *on;
return;  // end of program

