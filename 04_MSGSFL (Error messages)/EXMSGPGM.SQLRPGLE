**free
// Example showing how to use a message subfile to display
// multiple error messages to the user.

ctl-opt  option(*srcstmt: *nodebugio) dftactgrp(*no) actgrp('EXAMPLES');

// Display file with message subfile
dcl-f  EXMSGDSPF   workstn
                   infds(dspf_info)  indds(dspf_inds);

// AID byte information
dcl-ds  dspf_info;
  keyPressed    char(1)  pos(369);
end-ds;

// Indicator data structure for error highlighting
dcl-ds  dspf_inds;
    R01_Errors     char(1)    pos(50);
       R1Msg_ERR       ind    pos(50);
end-ds;

/include EXFKEY
/include EXPSDS


// Initial message so we can see something in the subfile
SendProgramMessage('Program started...');

// Main loop - exit on F3
dou keyPressed = F3;

    // Clear previous input and display
    clear R1MSG;

    // Display any messages that were sent
    write MSGSFLC;
    exfmt R01;

    // Remove messages after displaying the screen
    ClearProgramMessages();
    clear R01_Errors;


    // Validate user input when Enter is pressed
    if keyPressed = Enter;
        if R1Msg = *blanks;
            SendProgramMessage('Message is required');
            R1Msg_ERR = *on;      // highlight field
        else;
            // Pass the message to a sub procedure
            SendProgramMessage('In main: ' + %trim(R1Msg));
            Process(R1Msg);
        endif;
    endif;

enddo;

*inlr = *on;
return;


 dcl-proc  Process;
     dcl-pi  *n;
         in_message   char(50)  const;
     end-pi;

     // Demonstrate sending messages from a sub procedure
     SendProgramMessage('In Process(): ' + %trim(in_message));
     Process2(in_message);

     return;
 end-proc;


 dcl-proc  Process2;
     dcl-pi  *n;
         in_message   char(50)  const;
     end-pi;

     // Another level of procedure call
     SendProgramMessage('In Process2(): ' + %trim(in_message));

     return;
 end-proc;


 // Copy the SendProgramMessage & ClearProgramMessages procedures
/include EXMSGCPY

// end of example

