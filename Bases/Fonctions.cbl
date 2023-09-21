#********************************************************************************************************************#
#  ÉNONCÉ : Exemples de fonction COBOL : MODULO ; REMAINDER ; CURRENT DATE ; RANDOM ; MAX, MIN                       #
#********************************************************************************************************************#

#*******************************************************************#
#                            PROGRAMME                              #
#*******************************************************************#

        IDENTIFICATION DIVISION.
               PROGRAM-ID. EXO10.
               AUTHOR. SV.
               DATE-WRITTEN. 29/03/2023.
              ******************************************************************
              *  FONCTION DU PROGRAMME: EXEMPLES D'UTILISATION DE QUELQUES     *
              *                         FONCTIONS
              *  230329 : CREATION DU PROGRAMME                                *
              ******************************************************************
        ENVIRONMENT DIVISION.
        CONFIGURATION SECTION.
        SPECIAL-NAMES.
            DECIMAL-POINT IS COMMA.
        DATA DIVISION.

        WORKING-STORAGE SECTION.
         01  RESTE              PIC 9     VALUE ZEROES.
         01  WS-DATE.
              05 DATE-JOUR      PIC 9(8)  VALUE ZEROES.
              05 HEURE          PIC 9(6)  VALUE ZEROES.
         01  DATE-JOUR-ED       PIC X(10) VALUE SPACES.
         01  WS-RANDOM          PIC 9(4)  VALUE ZEROES.
         01  I                  PIC 99    VALUE ZEROES.
         01  WS-TAB.
              05                PIC X(5)  VALUE 'AF TT'.
              05                PIC X(5)  VALUE ' 99JK'.
              05                PIC X(5)  VALUE '5JHF1'.
              05                PIC X(5)  VALUE 'QZR  '.
              05                PIC X(5)  VALUE ';$(4 '.
         01  REDEFINES WS-TAB. 
              05 POSTE          PIC X(5) OCCURS 5.
         01  WS-POSTE-MAX       PIC X(5)  VALUE SPACES.
         01  WS-POSTE-MIN       PIC X(5)  VALUE SPACES.

        PROCEDURE DIVISION.
       * FONCTION MODULO
             COMPUTE RESTE = FUNCTION MOD(2023, 4)
             DISPLAY 'COMPUTE RESTE = FUNCTION MOD(2023, 4)'
                     ' ---> ' RESTE

       * FONCTION REMAINDER
             COMPUTE RESTE = FUNCTION REM(2023, 4)
             DISPLAY 'COMPUTE RESTE = FUNCTION REM(2023, 4)'
                     ' ---> ' RESTE

       * FONCTION CURRENT DATE
             MOVE FUNCTION CURRENT-DATE TO WS-DATE
             STRING DATE-JOUR(7 : 2)  DELIMITED BY SIZE
                    '/'               DELIMITED BY SIZE
                    DATE-JOUR(5 : 2)  DELIMITED BY SIZE
                    '/'               DELIMITED BY SIZE
                    DATE-JOUR(1 : 4)  DELIMITED BY SIZE
             INTO DATE-JOUR-ED
             DISPLAY 'MOVE FUNCTION CURRENT-DATE TO WS-DATE'
                     ' ---> DATE-JOUR : ' DATE-JOUR-ED
                     ', HEURE : '     HEURE

       * FONCTION RANDOM
             PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
               COMPUTE WS-RANDOM = FUNCTION RANDOM(I) * 1000
               DISPLAY 'COMPUTE WS-RANDOM = FUNCTION RANDOM'
                       ' ---> ' RESTE
             END-PERFORM

       * FONCTION MAX, MIN
             MOVE FUNCTION MAX(POSTE(ALL)) TO WS-POSTE-MAX
             DISPLAY 'MOVE FUNCTION MAX(POSTE(ALL)) TO WS-POSTE-MAX'
                     ' ---> ' WS-POSTE-MAX

             MOVE FUNCTION MIN(POSTE(ALL)) TO WS-POSTE-MIN
             DISPLAY 'MOVE FUNCTION MIN(POSTE(ALL)) TO WS-POSTE-MIN'
                     ' ---> ' WS-POSTE-MIN

             STOP RUN.



#*******************************************************************#
#                 SYSOUT : COMPTE-RENDU D'EXECUTION                 #
#*******************************************************************#

COMPUTE RESTE = FUNCTION MOD(2023, 4) ---> 3
COMPUTE RESTE = FUNCTION REM(2023, 4) ---> 3
MOVE FUNCTION CURRENT-DATE TO WS-DATE ---> DATE-JOUR : 29/03/2023, HEURE : 13305
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0885
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0328
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0771
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0214
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0656
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0099
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0542
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0984
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0427
COMPUTE WS-RANDOM = FUNCTION RANDOM ---> WS-RANDOM : 0870
MOVE FUNCTION MAX(POSTE(ALL)) TO WS-POSTE-MAX ---> 5JHF1
MOVE FUNCTION MIN(POSTE(ALL)) TO WS-POSTE-MIN --->  99JK
