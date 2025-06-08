**free
// Procedures for sending and clearing program messages
/IF DEFINED(MSGCPY)
    /EOF
/ENDIF
/DEFINE MSGCPY

 //========================================================================
 // Send a CPF9898 message to the program message queue
 dcl-proc  SendProgramMessage;
     dcl-pi  *n;
         in_message  varchar(80) const;
     end-pi;

    dcl-pr  SendMessage  extpgm('QMHSNDPM');       // Send Program Message API
        msgId            char(7)  const;  // e.g. CPF9898
        msgFile          char(20) const;  // message file/library
        msgData          char(80) const;  // replacement text
        msgLength        int(10)  const;  // length of msgData
        msgType          char(10) const;  // *INFO, *DIAG, etc
        stackEntry       char(10) const;  // call stack program
        stackCounter     int(10)  const;  // call stack depth
        msgKey           char(4);         // returned key
        errorDs          likeds(errorDs); // API error structure
    end-pr;

     dcl-ds  errorDs;
         bytesProvided    int(10) inz(16);
         bytesAvailable   int(10);
         exceptionId      char(7);
     end-ds;
     dcl-s msgKey   char(4);

     SendMessage( 'CPF9898'
                : 'QCPFMSG   QSYS'
                : in_message
                : %len(in_message)
                : '*INFO'
                : PS_PgmNam
                : 0
                : msgKey
                : errorDS
                );

 end-proc  SendProgramMessage;


 //========================================================================
 // Remove all messages from the program message queue
 dcl-proc  ClearProgramMessages;

    dcl-pr  RemoveMessage  extpgm('QMHRMVPM');   // Remove Program Message API
        stackEntry       char(10) const;  // program to clean
        stackCount       int(10)  const;  // depth to search
        msgKey           char(4)  const;  // start key or blank
        toRemove         char(10) const;  // *ALL, *PRV, etc
        errorDs          likeds(errorDs); // API error
    end-pr;

     dcl-ds  errorDs;
         bytesProvided    int(10) inz(16);
         bytesAvailable   int(10);
         exceptionId      char(7);
     end-ds;
     dcl-s msgKey   char(4);

     RemoveMessage( '*'
                  : 1
                  : ' '
                  : '*ALL'
                  : errorDS
                  );

end-proc  ClearProgramMessages;

// end of copybook
