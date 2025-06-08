**free
// Example program that demonstrates loading and displaying
// a simple subfile.

ctl-opt  option(*srcstmt: *nodebugio) dftactgrp(*no) actgrp('EXAMPLES');

// Display file with subfile, INFDS for AID and INDDS for indicators
dcl-f  EXSFLDSPF   workstn
                   infds(dspf_info)  indds(dspf_inds)
                   sfile( sfl1 : rrn1 );  // associates SFL1 with RRN variable

// AID byte
dcl-ds  dspf_info;
  keyPressed    char(1)  pos(369);
end-ds;

// Indicators controlling the subfile
dcl-ds  dspf_inds;
    S1_Dsp      ind  pos(1);    // indicator 01 controls SFLDSP
    S1_DspCtl   ind  pos(2);    // indicator 02 controls SFLDSPCTL/SFLCLR
    S1_End      ind  pos(3);    // indicator 03 drives SFLEND(*MORE)
end-ds;

// relative record number for subfile
dcl-s rrn1      uns(5);

/include EXFKEY

LoadSubfile();  // build the subfile before display
// Main loop - exit on F3
dou keyPressed = F3;       // wait for F3 AID

    // Clear position to field
    clear C1POSITION;

    write KEY1;  // display function key line
    exfmt CTL1;  // show subfile control (write/read)

    // Process function keys
    select;

        when keyPressed = F3;
            leave;

        when keyPressed = F17;
            // Go to top of subfile
            S1RCDNBR = 1;

        when keyPressed = F18;
            // Go to bottom of subfile
            S1RCDNBR = RRN1;

        when C1POSITION > 0;
            // Position to specific record
            S1RCDNBR = C1POSITION;  // sets top record displayed

    endsl;

enddo;  // loop until F3 pressed

*inlr = *on;
return;  // end of program


//=========================================================
dcl-proc  LoadSubfile;

    // Clear existing subfile records
    s1_dsp = *off;
    s1_dspCtl = *off;      // erase existing subfile
    write  CTL1;
    s1_dspCtl = *on;
    s1_dsp = *on;

    // Load demo data into the subfile
    for rrn1 = 1 to 713;     // 713 rows to illustrate paging
        S1_ROWKEY = %char(rrn1);
        S1_DATFLD = %date + %days(rrn1);
        S1_NBRFLD = rrn1 + (rrn1 / 1000);
        S1_TXTFLD = 'This is row #' + %char(rrn1);
        write  SFL1;
    endfor;

    rrn1 -= 1;          // adjust for final increment
                        // rrn1 now equals highest RRN
    S1RCDNBR = 1;       // start display at first record

end-proc  LoadSubfile;

// end of program
