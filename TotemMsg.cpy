       MESSAGE-FOR-FILEERROR.
           CALL "C$RERRNAME" USING TOTEM-MSG-ERR-FILE
           CALL "C$RERR" USING EXTEND-STAT, TEXT-MESSAGE
              MOVE PRIMARY-ERROR TO TOTEM-MSG-ID
           .

       SHOW-TRANSACTION-ROUTINE.
           IF TOTEM-TRANSACTION-FLAG = SPACES
              IF TRANSACTION-STATUS NOT = 0
                 STRING "TRANSACTION ERROR ", TRANSACTION-STATUS
                    DELIMITED BY SIZE INTO TOTEM-MSG-1
              END-IF
           ELSE
              PERFORM SHOW-MSG-ROUTINE
              IF TRANSACTION-STATUS = 0
                 MOVE "RollBack transaction." TO TOTEM-MSG-3
              ELSE
                 STRING "TRANSACTION ERROR ", TRANSACTION-STATUS
                    DELIMITED BY SIZE INTO TOTEM-MSG-3
              END-IF
           END-IF
           .

       SHOW-MSG-ROUTINE.
           MOVE SPACE TO TOTEM-MSG-1 TOTEM-MSG-2 TOTEM-MSG-3
           EVALUATE TOTEM-MSG-ID
               WHEN "10"
                    STRING "File:" TOTEM-MSG-ERR-FILE DELIMITED BY SPACE
                       INTO TOTEM-MSG-1
                    MOVE "No more data." TO TOTEM-MSG-2
                    MOVE MB-DEFAULT-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
               WHEN "22"
                    STRING "File:" TOTEM-MSG-ERR-FILE DELIMITED BY SPACE
                       INTO TOTEM-MSG-1
                    MOVE "Key duplication." TO TOTEM-MSG-2
                    MOVE MB-ERROR-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
               WHEN "23"
                    STRING "File:" TOTEM-MSG-ERR-FILE DELIMITED BY SPACE
                       INTO TOTEM-MSG-1
                    MOVE "Record not found." TO TOTEM-MSG-2
                    MOVE MB-WARNING-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
               WHEN "101"
                    MOVE "Quit?" TO TOTEM-MSG-1
                    MOVE 4 TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-YES-NO TO TOTEM-MSG-BUTTON-TYPE
               WHEN "201"
                    MOVE "Add Record?" TO TOTEM-MSG-1
                    MOVE 4 TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-YES-NO TO TOTEM-MSG-BUTTON-TYPE
               WHEN "202"
                    MOVE "Update Record?" TO TOTEM-MSG-1
                    MOVE 4 TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-YES-NO TO TOTEM-MSG-BUTTON-TYPE
               WHEN "203"
                    MOVE "Delete Record?" TO TOTEM-MSG-1
                    MOVE 4 TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-YES-NO TO TOTEM-MSG-BUTTON-TYPE
               WHEN "204"
                    MOVE "Key duplication." TO TOTEM-MSG-1
                    MOVE MB-WARNING-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
               WHEN "301"
                    MOVE "Add Successful." TO TOTEM-MSG-1
                    MOVE MB-DEFAULT-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
               WHEN "302"
                    MOVE "Update Successful." TO TOTEM-MSG-1
                    MOVE MB-DEFAULT-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
               WHEN "303"
                    MOVE "Delete Successful." TO TOTEM-MSG-1
                    MOVE MB-DEFAULT-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
               WHEN "401"
                    MOVE "Shell not found." TO TOTEM-MSG-1
                    MOVE MB-ERROR-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
               WHEN OTHER
                    MOVE TEXT-MESSAGE TO TOTEM-MSG-1
                    STRING "FILE:" TOTEM-MSG-ERR-FILE DELIMITED BY SPACE
                       INTO TOTEM-MSG-3
                    MOVE 0 TO TOTEM-IDX1
                    INSPECT TOTEM-MSG-3 TALLYING TOTEM-IDX1
                       FOR TRAILING SPACE
                    STRING TOTEM-MSG-3(1:TOTEM-MSG-LENGTH - TOTEM-IDX1), 
                       ", FILE STATUS ", PRIMARY-ERROR "," 
                       SECONDARY-ERROR
                    DELIMITED BY SIZE INTO TOTEM-MSG-2
                    MOVE SPACES TO TOTEM-MSG-3
                    MOVE MB-ERROR-ICON TO TOTEM-MSG-ICON-TYPE
                    MOVE MB-OK TO TOTEM-MSG-BUTTON-TYPE
           END-EVALUATE
           PERFORM MESSAGE-BOX-ROUTINE
           .

       MESSAGE-BOX-ROUTINE.
           MOVE 1 TO TOTEM-MSG-TEXT-POINTER
           IF TOTEM-MSG-1 NOT = SPACE
              MOVE 0 TO TOTEM-MSG-SIZE
              INSPECT TOTEM-MSG-1 TALLYING TOTEM-MSG-SIZE 
                      FOR TRAILING SPACE
              STRING TOTEM-MSG-1(1:TOTEM-MSG-LENGTH - TOTEM-MSG-SIZE)
                 DELIMITED BY SIZE
                 INTO TOTEM-MSG-TEXT, POINTER TOTEM-MSG-TEXT-POINTER
           END-IF

           IF TOTEM-MSG-2 NOT = SPACE
              MOVE 0 TO TOTEM-MSG-SIZE
              INSPECT TOTEM-MSG-2 TALLYING TOTEM-MSG-SIZE 
                      FOR TRAILING SPACE
              IF TOTEM-MSG-TEXT-POINTER > 1
                 STRING X"0A" DELIMITED BY SIZE INTO TOTEM-MSG-TEXT, 
                              POINTER TOTEM-MSG-TEXT-POINTER
              END-IF
              STRING TOTEM-MSG-2(1:TOTEM-MSG-LENGTH - TOTEM-MSG-SIZE)
                  DELIMITED BY SIZE
                  INTO TOTEM-MSG-TEXT, POINTER TOTEM-MSG-TEXT-POINTER
           END-IF

           IF TOTEM-MSG-3 NOT = SPACE
              MOVE 0 TO TOTEM-MSG-SIZE
              INSPECT TOTEM-MSG-3 TALLYING TOTEM-MSG-SIZE 
                      FOR TRAILING SPACE
              IF TOTEM-MSG-TEXT-POINTER > 1
                 STRING X"0A" DELIMITED BY SIZE INTO TOTEM-MSG-TEXT, 
                              POINTER TOTEM-MSG-TEXT-POINTER
              END-IF
              STRING TOTEM-MSG-3(1:TOTEM-MSG-LENGTH - TOTEM-MSG-SIZE)
                  DELIMITED BY SIZE
                  INTO TOTEM-MSG-TEXT, POINTER TOTEM-MSG-TEXT-POINTER
           END-IF

           IF TOTEM-MSG-TEXT-POINTER = 1
              MOVE 0 TO TOTEM-MSG-SIZE
              INSPECT TOTEM-MSG-TEXT TALLYING TOTEM-MSG-SIZE 
                      FOR TRAILING SPACE
                  COMPUTE TOTEM-MSG-TEXT-POINTER = 
                          TOTEM-MSG-FULL-LENGTH - TOTEM-MSG-SIZE + 1
           END-IF
           MOVE LOW-VALUES TO TOTEM-MSG-TEXT(TOTEM-MSG-TEXT-POINTER:1)
           .

       MESSAGE-BOX-DISPLAY.
           PERFORM SHOW-MSG-ROUTINE
           PERFORM MESSAGE-BOX-ROUTINE
           DISPLAY MESSAGE BOX TOTEM-MSG-TEXT
               TITLE IS TOTEM-MSG-TITLE
               TYPE  IS TOTEM-MSG-BUTTON-TYPE
               ICON  IS TOTEM-MSG-DEFAULT-BUTTON
               RETURNING TOTEM-MSG-RETURN-VALUE
           .

