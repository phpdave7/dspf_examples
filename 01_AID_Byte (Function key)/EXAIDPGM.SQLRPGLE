**free
// Demonstrates how to read the AID byte to determine which
// function key the user pressed.

ctl-opt  option(*srcstmt: *nodebugio) actgrp('EXAMPLES');


// Display file with INFDS so we can access the AID byte
dcl-f  EXAIDDSPF   workstn
                   infds(dspf_info);

// File information data structure where the AID byte lives
// Manual states the AID value is returned in INFDS position 369
dcl-ds  dspf_info;
  keyPressed    char(1)  pos(369);   // AID byte (position 369 in INFDS)
end-ds;
// Holds the numeric index of the function key that was pressed
dcl-s  fkey     zoned(2);

// Hex values for each function key (from IBM i Workstation Ref)
dcl-ds  *n;
    F1   char(1)  inz(x'31');
    F2   char(1)  inz(x'32');
    F3   char(1)  inz(x'33');
    F4   char(1)  inz(x'34');
    F5   char(1)  inz(x'35');
    F6   char(1)  inz(x'36');
    F7   char(1)  inz(x'37');
    F8   char(1)  inz(x'38');
    F9   char(1)  inz(x'39');
    F10  char(1)  inz(x'3A');
    F11  char(1)  inz(x'3B');
    F12  char(1)  inz(x'3C');
    F13  char(1)  inz(x'B1');
    F14  char(1)  inz(x'B2');
    F15  char(1)  inz(x'B3');
    F16  char(1)  inz(x'B4');
    F17  char(1)  inz(x'B5');
    F18  char(1)  inz(x'B6');
    F19  char(1)  inz(x'B7');
    F20  char(1)  inz(x'B8');
    F21  char(1)  inz(x'B9');
    F22  char(1)  inz(x'BA');
    F23  char(1)  inz(x'BB');
    F24  char(1)  inz(x'BC');
    functionKeys  char(1)  dim(24)  pos(1);   // overlay constants so index=F key
                                               // %LOOKUP result = F key number
end-ds;


// Keep prompting the user until they type EXIT
dou R1MSG = 'EXIT';        // DOU evaluates after each loop
                           // loop ends when message field contains EXIT

    // Show the screen and wait for the user
    exfmt R01;            // EXFMT = write/read combined

    // allow the user to exit by typing EXIT
    if R1MSG = 'EXIT';
        leave;
    endif;

    // Translate the AID byte into a function key number
    fkey = %lookup(keyPressed : functionKeys);  // array index is F key number
    if fkey > 0;
        // Tell the user which F key was pressed
        R1MSG = 'You pressed F' + %char(fkey);
    else;
        // Some other AID value was returned
        R1MSG = 'You pressed something other than F1 - F24';
    endif;

enddo;

*inlr = *on;
return;
