**free
// Demonstrates conditional fields using indicators

ctl-opt  option(*srcstmt: *nodebugio) actgrp('EXAMPLES');

// Display file uses INDARA for conditional logic
dcl-f  EXCNDDSPF   workstn
                   infds(dspf_info)
                   indds(dspf_inds);

// AID byte
dcl-ds  dspf_info;
  keyPressed    char(1)  pos(369);
end-ds;
// Indicator used to show or hide fields
dcl-ds  dspf_inds;
  showFields    ind   pos(1);
end-ds;

// Constant values for F3 and F11
dcl-c  F3            x'33';
dcl-c  F11           x'3B';

// Loop until F3 is pressed
dou keyPressed = F3;

    // Display the screen
    exfmt R01;

    // Toggle the indicator when F11 is pressed
    if keyPressed = F11;
        showFields = not showFields;
    endif;

enddo;  // keep looping until F3

*inlr = *on;
return;  // end of program
