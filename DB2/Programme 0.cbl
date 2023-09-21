      ********************************************************************************************************************#
      *  ÉNONCÉ : Dans la bibliothèque userid.SOURCE.DB2, écrire le programme DB2P0 qui lit et affiche toutes les         #
      *           colonnes de l'employé ayant le matricule '10'. Puis lecture et affichage de tous les employés de la     #
      *           table EMPLOYE triés sur le NOM. Dans un second temps, remplacer les displays par un fichier d'édition.  #
      ********************************************************************************************************************#

      * Programme DB2P0 + JCL + SYSOUT + EDITION

Informations sur les membres appelés par INCLUDE :
a) Issu du DCLGEN: API7.SOURCE.DCLGEN(EMPLOYE)
      ******************************************************************
      * DCLGEN TABLE(EMPLOYE)                                          *
      *        LIBRARY(API7.SOURCE.DCLGEN(EMPLOYE))                    *
      *        ACTION(REPLACE)                                         *
      *        LANGUAGE(COBOL)                                         *
      *        STRUCTURE(EMPLOYE)                                      *
      *        QUOTE                                                   *
      *        DBCSDELIM(NO)                                           *
      * ... IS THE DCLGEN COMMAND THAT MADE THE FOLLOWING STATEMENTS   *
      ******************************************************************
    EXEC SQL DECLARE EMPLOYE TABLE
    ( MAT                            CHAR(3) NOT NULL,
      NOM                            CHAR(7) NOT NULL,
      NOD                            CHAR(3) NOT NULL,
      DAT                            DATE NOT NULL,
      SAL                            DECIMAL(7, 2) NOT NULL,
      COM                            DECIMAL(7, 2)
    ) END-EXEC.
      ******************************************************************
      * COBOL DECLARATION FOR TABLE EMPLOYE                            *
      ******************************************************************
  01  EMPLOYE.
      10 MAT                  PIC X(3).
      10 NOM                  PIC X(7).
      10 NOD                  PIC X(3).
      10 DAT                  PIC X(10).
      10 SAL                  PIC S9(5)V9(2) USAGE COMP-3.
      10 COM                  PIC S9(5)V9(2) USAGE COMP-3.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 6       *
      ******************************************************************

      *b) Host-variables utilisées dans le programme: API7.SOURCE.COPY(EMPLOYE2)
      ******************************************************************
      * COBOL DECLARATION FOR TABLE EMPLOYE                            *
      ******************************************************************
01  HVE-EMPLOYE.
      10 HVE-MAT              PIC X(3).
      10 HVE-NOM              PIC X(7).
      10 HVE-NOD              PIC X(3).
      10 HVE-DAT              PIC X(10).
      10 HVE-SAL              PIC S9(5)V9(2) USAGE COMP-3.
      10 HVE-COM              PIC S9(5)V9(2) USAGE COMP-3.
      ******************************************************************
      * THE NUMBER OF COLUMNS DESCRIBED BY THIS DECLARATION IS 6       *
      ******************************************************************




      ********************************************************************#
      *                            PROGRAMME                              #
      ********************************************************************#

       IDENTIFICATION DIVISION.
       PROGRAM-ID. ESSAI.
       AUTHOR. SV.
       DATE-WRITTEN. 29/03/2023.
      ******************************************************************
      *  FONCTION DU PROGRAMME: LECTURE D'UN EMPLOYE ET                *
      *   EDITION DE LA LISTE DES EMPLOYES DANS UN FICHIER D'EDITION   *
      *  230329 : CREATION DU PROGRAMME                                *
      ******************************************************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
      *DECLARATION DU FICHIER D'EDITION
           SELECT EDIT ASSIGN TO EDIT
                  ORGANIZATION IS SEQUENTIAL
                  ACCESS MODE  IS SEQUENTIAL
                  FILE STATUS  IS FS-EDIT.
       DATA DIVISION.
      *DECLARATION DU BUFFER
       FILE SECTION.
       FD  EDIT RECORDING MODE IS F.
       01  ENR-EDIT.
      *METTRE EN COMMENTAIRE LE CARACTERE DE SAUT SI ON UTILISE
      *WRITE AFTER ADVANCING
           05 CAR-SAUT       PIC X.
           05 LIG-EDIT       PIC X(132).

       WORKING-STORAGE SECTION.
      *FILE STATUS
       01  FS-EDIT           PIC 99 VALUE ZEROES.

      *COPY DES DECLARATIONS DE LA TABLE EMPLOYE
           EXEC SQL INCLUDE EMPLOYE END-EXEC.
      *COPY DES HOST VARIABLES DE LA TABLE EMPLOYE
           EXEC SQL INCLUDE EMPLOYE2 END-EXEC.
      *COPY DES ZONES UTILES A DB2
           EXEC SQL INCLUDE SQLCA   END-EXEC.

       01  WS-MAT PIC X(3) VALUE SPACES.

      *ECRITURE DE L'ORDRE POUR LISTER LA TABLE EMPLOYE
      *UTILISATION D'UN CURSEUR CAR PLUSIEURS LIGNES
           EXEC SQL DECLARE LISTE CURSOR FOR
            SELECT MAT,
                   NOM,
                   NOD,
                   DAT,
                   SAL,
                   VALUE(COM, 0)
            FROM EMPLOYE
            ORDER BY NOM
           END-EXEC

      *LIGNES EDITION
       01  L1.
            05                      PIC X(30) VALUE SPACES.
            05                      PIC X(18) VALUE 'LISTE DES EMPLOYES'.
       01  L2.
            05                      PIC X(30) VALUE SPACES.
            05                      PIC X(18) VALUE ALL '-'.

       01  L3.
            05                      PIC X(03) VALUE 'MAT'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(07) VALUE 'NOM'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(03) VALUE 'NOD'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(10) VALUE 'DAT'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(10) VALUE 'SAL'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(10) VALUE 'COM'.

        01  L4.
            05                      PIC X(03) VALUE ALL '-'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(07) VALUE ALL '-'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(03) VALUE ALL '-'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(10) VALUE ALL '-'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(10) VALUE ALL '-'.
            05                      PIC X(03) VALUE SPACES.
            05                      PIC X(10) VALUE ALL '-'.

       01  L5.
            05 ED-MAT               PIC X(03) VALUE SPACES.
            05                      PIC X(03) VALUE SPACES.
            05 ED-NOM               PIC X(07) VALUE SPACES.
            05                      PIC X(03) VALUE SPACES.
            05 ED-NOD               PIC X(03) VALUE SPACES.
            05                      PIC X(03) VALUE SPACES.
            05 ED-DAT               PIC X(10) VALUE SPACES.
            05                      PIC X(03) VALUE SPACES.
            05 ED-SAL               PIC ZZ.ZZZ,ZZ VALUE ZEROES.
            05                      PIC X(03) VALUE SPACES.
            05 ED-COM               PIC ZZ.ZZZ,ZZ VALUE ZEROES.

       PROCEDURE DIVISION.
      *LECTURE D'UNE LIGNE DE LA TABLE EMPLOYE
             MOVE '10'     TO WS-MAT
             DISPLAY 'LECTURE DE L''EMPLOYE DE MATRICULE : ' WS-MAT
             EXEC SQL
              SELECT MAT,
                     NOM,
                     NOD,
                     DAT,
                     SAL,
                     VALUE(COM, 0)
              INTO
                    :HVE-MAT,
                    :HVE-NOM,
                    :HVE-NOD,
                    :HVE-DAT,
                    :HVE-SAL,
                    :HVE-COM
              FROM EMPLOYE
              WHERE MAT = :WS-MAT
             END-EXEC

             DISPLAY 'SQLCODE : ' SQLCODE

      *AFFICHAGE DES COLONNES SI SQLCODE = 0
             EVALUATE SQLCODE
              WHEN ZEROES
                DISPLAY 'EMPLOYE : '
                        HVE-MAT ', '
                        HVE-NOM ', '
                        HVE-NOD ', '
                        HVE-DAT ', '
                        HVE-SAL ', '
                        HVE-COM
              WHEN +100
                DISPLAY 'EMPLOYE : ' WS-MAT ' INCONNU EN TEBLE'
              WHEN OTHER
                DISPLAY 'ERREUR SELECT EMPLOYE, SQLCODE : ' SQLCODE
                PERFORM FIN
             END-EVALUATE

      *OUVERTURE DU FICHIER D'EDITION
             OPEN OUTPUT EDIT
             IF FS-EDIT NOT = ZEROES
                DISPLAY 'ERREUR OPEN EDIT, FS : ' FS-EDIT
                PERFORM FIN
             END-IF

      *ECRITURE DE L'ENTETE
      *1ERE FACON : AVEC GESTION AUTOMATIQUE DU CARACTERE DE SAUT
      *   MOVE L1   TO LIG-EDIT
      *   WRITE ENR-EDIT AFTER ADVANCING PAGE
      *   MOVE L2   TO LIG-EDIT
      *   WRITE ENR-EDIT AFTER ADVANCING 2 LINES
      *   MOVE L3   TO LIG-EDIT
      *   WRITE ENR-EDIT
      *   MOVE L4   TO LIG-EDIT
      *   WRITE ENR-EDIT

      *2EME FACON: EN RENSEIGNANT LE CARACTERE DE SAUT
      *  1 : SAUT DE PAGE
      *  0 : SAUT DE LIGNE
      *  BLANC : RETOUR CHARIOT
             MOVE '1'  TO CAR-SAUT
             MOVE L1   TO LIG-EDIT
             WRITE ENR-EDIT
             MOVE ' '  TO CAR-SAUT
             MOVE L2   TO LIG-EDIT
             WRITE ENR-EDIT
             MOVE '0'  TO CAR-SAUT
             MOVE L3   TO LIG-EDIT
             WRITE ENR-EDIT
             MOVE ' '  TO CAR-SAUT
             MOVE L4   TO LIG-EDIT
             WRITE ENR-EDIT

      *LECTURE DES EMPLOYES : UTILISATION DU CURSEUR
             DISPLAY SPACES
             DISPLAY 'LECTURE DE TOUS LES EMPLOYES'

      *--> 1- OUVERTURE DU CURSEUR (OPEN)
             EXEC SQL OPEN LISTE END-EXEC
             IF SQLCODE NOT = ZEROES
                DISPLAY 'ERREUR OPEN LISTE : ' SQLCODE
                PERFORM FIN
             END-IF

      *--> 2- BOUCLE DE LECTURE DU CURSEUR (FETCH)
             PERFORM UNTIL SQLCODE = +100
                EXEC SQL
                   FETCH LISTE
                   INTO
                         :HVE-MAT,
                         :HVE-NOM,
                         :HVE-NOD,
                         :HVE-DAT,
                         :HVE-SAL,
                         :HVE-COM
                END-EXEC
                IF SQLCODE = ZEROES
                   MOVE HVE-MAT TO ED-MAT
                   MOVE HVE-NOM TO ED-NOM
                   MOVE HVE-NOD TO ED-NOD
                   MOVE HVE-DAT TO ED-DAT
                   MOVE HVE-SAL TO ED-SAL
                   MOVE HVE-COM TO ED-COM
                   MOVE L5      TO LIG-EDIT
                   MOVE ' '     TO CAR-SAUT
                   WRITE ENR-EDIT
                END-IF
             END-PERFORM

      *--> 3- FERMETURE DU CURSEUR (CLOSE)
             EXEC SQL CLOSE LISTE END-EXEC
             .
       FIN.
             STOP RUN.



      ********************************************************************#
      *                         JCL D'EXECUTION                           #
      ********************************************************************#

//API7DB JOB NOTIFY=&SYSUID,CLASS=A,MSGCLASS=H
//*
//PROCLIB  JCLLIB ORDER=SDJ.FORM.PROCLIB
//*
//         SET SYSUID=API7
//         NOMPGM:ESSAI
//*
//APPROC   EXEC COMPDB2
//STEPDB2.SYSLIB   DD DSN=API7.SOURCE.DCLGEN,DISP=SHR
//                 DD DSN=API7.SOURCE.COPY,DISP=SHR
//STEPDB2.SYSIN    DD DSN=API7.SOURCE.DB2(ESSAI),DISP=SHR
//STEPDB2.DBRMLIB DD DSN=API7.SOURCE.DBRMLIB(ESSAI),DISP=SHR
//STEPLNK.SYSLMOD  DD DSN=API7.SOURCE.PGMLIB(ESSAI),DISP=SHR
//*
//*--- ETAPE DE BIND --------------------------------------
//*
//BIND     EXEC PGM=IKJEFT01,COND=(4,LT)
//*DBRMLIB  DD  DSN=&SYSUID..DB2.DBRMLIB,DISP=SHR
//DBRMLIB  DD  DSN=API7.SOURCE.DBRMLIB,DISP=SHR
//SYSTSPRT DD  SYSOUT=*,OUTLIM=25000
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  BIND PLAN      (ESSAI) -
       QUALIFIER (API7)     -
       ACTION    (REPLACE) -
       MEMBER    (ESSAI) -
       VALIDATE  (BIND)    -
       ISOLATION (CS)      -
       ACQUIRE   (USE)     -
       RELEASE   (COMMIT)  -
       EXPLAIN   (NO)
//*
//* DELETE DU FICHIER D'EDITION
//DEL      EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=*
//SYSIN    DD   *
  DELETE API7.EDITION
  SET MAXCC = 0
//*
//STEPRUN  EXEC PGM=IKJEFT01,COND=(4,LT)
//STEPLIB  DD DSN=API7.SOURCE.PGMLIB,DISP=SHR
//EDIT     DD  DSN=API7.EDITION,DISP=(,CATLG,DELETE),
//         DCB=(DSORG=PS,RECFM=FB,LRECL=133),
//         SPACE=(TRK,(1))
//SYSOUT   DD  SYSOUT=*,OUTLIM=1000
//SYSTSPRT DD  SYSOUT=*,OUTLIM=2500
//SYSTSIN  DD  *
  DSN SYSTEM (DSN1)
  RUN PROGRAM(ESSAI) PLAN (ESSAI) PARMS('11001')
//



      ********************************************************************#
      *                 SYSOUT : COMPTE-RENDU D'EXECUTION                 #
      ********************************************************************#

      ********************************** TOP OF DATA **********************************
LECTURE DE L'EMPLOYE DE MATRICULE : 10
SQLCODE : 000000000
EMPLOYE : 10 , DURAND , E10, 2000-02-10, 1100000, 0500000

LECTURE DE TOUS LES EMPLOYES 
      ********************************* BOTTOM OF DATA ********************************



      ********************************************************************#
      *                          FICHIER D'EDITION                        #
      ********************************************************************#
1                              LISTE DES EMPLOYES
                               ------------------
0MAT   NOM       NOD   DAT          SAL          COM
 ---   -------   ---   ----------   ----------   ----------
 30    BARI      P02   2001-01-04    6.000,00    3.000,00
 50    CICS      P02   2006-06-20    8.500,00    3.500,50
 20    DUPOND    P01   1998-01-11   15.100,50
 10    DURAND    E10   2000-02-10   11.000,00    5.000,00
 40    JAVA      C04   2005-12-03   21.000,50    1.000,50
 70    NOEL      P02   2007-05-18   10.500,00      900,50
 60    PARIS     P01   2008-04-22    9.000,00    3.500,00
