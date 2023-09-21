      ********************************************************************************************************************#
      *  ÉNONCÉ : Développement d'accesseurs aux tables DB2 de la base EMPLOYE afin de rendre les programmes indépendants #
      *           des supports de l'information.                                                                          #
      ********************************************************************************************************************#

      *PROGRAMME PRINCIPAL : PROJ2 - ACCESSEUR : ACCESS2

      *Description de la zone de communication :
      *  01 ZACCESSEUR.
      *Valeurs possible : 'L' (lecture), 'C' (création), 'M' (modification), 'S' (suppression),
      *'O' (ouverture du curseur), 'Q' (lecture séquentielle du curseur), 'F' (fermeture du curseur)
      *05 ZCODE-FONC     PIC X.
      *05 ZMAT           PIC X(3).
      *05 ZNOM           PIC X(7).
      *05 ZNOD           PIC X(3).
      *05 ZDAT           PIC 9(8).
      *05 ZSAL           PIC 9(5)V99.
      *05 ZCOM           PIC 9(5)V99.
      *LE ZCODE-RET CORRESPOND AU N° D'ERREUR (VOIR LA TABLE DES ERREURS)
      *05 ZCODE-RET      PIC 99.
      *LE ZLIBERR CORRESPOND AU LIBELLÉ DE L'ERREUR DANS LA TABLE DES ERREURS
      *05 ZLIBERR        PIC X(50).


      ********************************************************************#
      *                            JEU DE TEST                            #
      ********************************************************************#

      *1) CREATION EMPLOYE MAT 100, NOM = MAGUY, N° DÉPARTEMENT : P01, DATE ENTRÉE : 20230515,
      *SALAIRE : 3000 - CODE RETOUR UNIQUE DE L'ACCESSEUR = 0  
      *2) LECTURE EMPLOYE MAT 100 - ACCESSEUR RETOURNE LES INFORMATIONS DE MAGUY
      *3) MODIFICATION MAT 100, SALAURE : 3500 ET COM : 500 - CODE RETOUR UNIQUE DE L'ACCESSEUR = 0
      *4) LECTURE ALL EMPLOYES AVEC GESTION PAR CURSEUR - ZCODE-FONC = 'O', 'Q' et 'F'
      *5) SUPPRESSION EMPLOYE MAT 100 - CODE RETOUR UNIQUE DE L'ACCESSEUR = 0  
      *6) LECTURE EMPLOYE MAT 100 - CODE RETOUR DE L'ACCESSEUR = 11


      ********************************************************************#
      *                         TABLE DES ERREURS                         #
      ********************************************************************#
      *Num   Libellé
      *1    CODE FONCTION ERRONE
      *2    CODE TABLE ERRONE
      *3    MATRICULE NON RENSEIGNE
      *4    MATRICULE DEJA EXISTANT
      *5    NOM NON RENSEIGNE
      *6    DEPARTEMENT NON RENSEIGNE
      *7    DEPARTEMENT INEXISTANT
      *8    DATE ENTREE ERRONEE
      *9    SALAIRE NON NUMERIQUE OU NUL
      *10   COMMISSION NON NUMERIQUE
      *11   MATRICULE INEXISTANT
      *12   DEPARTEMENT DEJA EXISTANT
      *13   NOM DEPARTEMENT NON RENSEIGNE
      *14   BATIMENT NON RENSEIGNE
      *15   MATRICULE DU CHEF NON RENSEIGNE
      *16   MATRICULE DU CHEF INEXISTANT                             
      *17   SUPPRESSION EMPLOYE IMPOSSIBLE, CONTRAINTE SUR DEP
      *18   SUPPRESSION DEP IMPOSSIBLE, CONTRAINTE SUR EMPLOYE
      *19   FIN DE LISTE
      *20   PROBLEME SUR TABLE
        

      ********************************************************************#
      *                        PROGRAMME PRINCIPAL                        #
      ********************************************************************#

   CBL DYNAM
       IDENTIFICATION DIVISION.
       PROGRAM-ID. PROJ2.
      ******************************************************************
      * BUT : PROGRAMME DE TEST DE L'ACCESSEUR DE LA BASE EMPLOYE      *
      ******************************************************************
       AUTHOR. SV.
       DATE-WRITTEN. 15/05/23.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.
           
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      *PICTURES D'EDITION
       01  ED-ZSAL        PIC Z(5),ZZ.
       01  ED-ZCOM        PIC Z(5),ZZ.
       
      *ZONE DE COMMUNICATION AVEC L'ACCESSEUR
       01 ZACCESSEUR.
          05 ZCODE-FONC     PIC X.
          05 ZMAT           PIC X(3).
          05 ZNOM           PIC X(7).
          05 ZNOD           PIC X(3).
          05 ZDAT           PIC 9(8).
          05 ZSAL           PIC 9(5)V99.
          05 ZCOM           PIC 9(5)V99.
          05 ZCODE-RET      PIC 99.
          05 ZLIBERR        PIC X(50).
          
      *ZONE DE COMMUNICATION AVEC L'ACCESSEUR DE LA TABLE DEPARTEMENT
        01 DACCESSEUR.
          05 DCODE-FONC     PIC X.
          05 DNOD           PIC X(3).
          05 DNDE           PIC X(6).
          05 DLIE           PIC X(4).
          05 DCHE           PIC X(3).
          05 DCODE-RET      PIC 99.
          05 DLIBERR        PIC X(50).
          
        01 ACCESS2          PIC X(8)    VALUE 'ACCESS2'.
        01 ACCESS2A         PIC X(8)    VALUE 'ACCESS2A'.
    
 
        PROCEDURE DIVISION.
      *LECTURE DE L'EMPLOYE MAT 10
             INITIALIZE ZACCESSEUR
             MOVE '10'     TO ZMAT
             PERFORM LECTURE-EMPLOYE
             
      *CREATION DE L'EMPLOYE MAT 100
             INITIALIZE ZACCESSEUR
             MOVE 'C'      TO ZCODE-FONC
             MOVE '100'    TO ZMAT
             MOVE 'MAGUY'  TO ZNOM
             MOVE 'P01'    TO ZNOD
             MOVE 20230515 TO ZDAT
             MOVE 3000     TO ZSAL
             
             DISPLAY SPACES
             DISPLAY '--- CODE FONCTION : '   ZCODE-FONC
             DISPLAY '--- MAT : '             ZMAT
             DISPLAY '--- NOM : '             ZNOM
             DISPLAY '--- NOD : '             ZNOD
             DISPLAY '--- DAT : '             ZDAT
             MOVE ZSAL TO ED-ZSAL
             DISPLAY '--- SAL : '             ED-ZSAL
             MOVE ZCOM TO ED-ZCOM
             DISPLAY '--- COM : '             ED-ZCOM
             
             CALL ACCESS2 USING ZACCESSEUR
             
             IF ZCODE-RET = ZEROES
                DISPLAY '--- CODE RETOUR : '  ZCODE-RET
                DISPLAY '--- CREATION EMPLOYE EFFECTUÉE'
             ELSE
                DISPLAY '--- ERR, CODE RETOUR : ' ZCODE-RET
                DISPLAY '--- LIBELLE ERR : '      ZLIBERR
             END-IF
             
      *LECTURE DE L'EMPLOYE 100
             INITIALIZE ZACCESSEUR
             MOVE '100'    TO ZMAT
             PERFORM LECTURE-EMPLOYE
             
      *MODIFICATION DE L'EMPLOYE MAT 100       
             INITIALIZE ZACCESSEUR
             MOVE 'm'      TO ZCODE-FONC
             MOVE '100'    TO ZMAT
             MOVE 'MAGUY'  TO ZNOM
             MOVE 'P01'    TO ZNOD
             MOVE 20230515 TO ZDAT
             MOVE 3500     TO ZSAL
             MOVE  500     TO ZCOM
             
             DISPLAY SPACES
             DISPLAY '--- CODE FONCTION : '   ZCODE-FONC
             DISPLAY '--- MAT : '             ZMAT
             DISPLAY '--- NOM : '             ZNOM
             DISPLAY '--- NOD : '             ZNOD
             DISPLAY '--- DAT : '             ZDAT
             MOVE ZSAL TO ED-ZSAL
             DISPLAY '--- SAL : '             ED-ZSAL
             MOVE ZCOM TO ED-ZCOM
             DISPLAY '--- COM : '             ED-ZCOM
             
             CALL ACCESS2 USING ZACCESSEUR
             
             IF ZCODE-RET = ZEROES
                DISPLAY '--- CODE RETOUR : '  ZCODE-RET
                DISPLAY '--- MODIFICATION EMPLOYE EFFECTUÉE'
             ELSE
                DISPLAY '--- ERR, CODE RETOUR : ' ZCODE-RET
                DISPLAY '--- LIBELLE ERR : '      ZLIBERR
             END-IF
             
      *LECTURE DE L'EMPLOYE 100
             INITIALIZE ZACCESSEUR
             MOVE '100'    TO ZMAT
             PERFORM LECTURE-EMPLOYE
             
      *LISTE DES EMPLOYES
      *OUVERTURE DU CURSEUR
             INITIALIZE ZACCESSEUR
             MOVE 'O'      TO ZCODE-FONC
             CALL ACCESS2 USING ZACCESSEUR
             
             IF ZCODE-RET = ZEROES
                DISPLAY 'OUVERTURE LISTE OK'
             ELSE
                DISPLAY '--- ERR, CODE RETOUR : ' ZCODE-RET
                DISPLAY '--- LIBELLE ERR : '      ZLIBERR
                PERFORM FIN
             END-IF
             
      *BOUCLE DE LECTURE
             INITIALIZE ZACCESSEUR
             MOVE 'Q'      TO ZCODE-FONC
             CALL ACCESS2 USING ZACCESSEUR
             
             PERFORM UNTIL ZCODE-RET = 19
                IF ZCODE-RET = ZEROES
                   DISPLAY SPACES
                   DISPLAY '--- MAT : '             ZMAT
                   DISPLAY '--- NOM : '             ZNOM
                   DISPLAY '--- NOD : '             ZNOD
                   DISPLAY '--- DAT : '             ZDAT
                   MOVE ZSAL TO ED-ZSAL
                   DISPLAY '--- SAL : '             ED-ZSAL
                   MOVE ZCOM TO ED-ZCOM
                   DISPLAY '--- COM : '             ED-ZCOM
                ELSE
                   DISPLAY '--- ERR, CODE RETOUR : ' ZCODE-RET
                   DISPLAY '--- LIBELLE ERR : '      ZLIBERR
                END-IF
                CALL ACCESS2 USING ZACCESSEUR
             END-PERFORM   
               
      *FERMETURE DU CURSEUR
             INITIALIZE ZACCESSEUR
             MOVE 'F'      TO ZCODE-FONC
             CALL ACCESS2 USING ZACCESSEUR
             IF ZCODE-RET = ZEROES
                DISPLAY 'FERMETURE LISTE OK'
             ELSE
                DISPLAY '--- ERR, CODE RETOUR : ' ZCODE-RET
                DISPLAY '--- LIBELLE ERR : '      ZLIBERR
                PERFORM FIN
             END-IF
             
      *SUPPRESSION D'UN EMPLOYE
             INITIALIZE ZACCESSEUR
             MOVE 'S'      TO ZCODE-FONC
             MOVE '100'    TO ZMAT
             CALL ACCESS2 USING ZACCESSEUR
             IF ZCODE-RET = ZEROES
                DISPLAY 'SUPPRESSION EMPLOYE ' ZMAT ' FAITE'
             ELSE
                DISPLAY '--- ERR, CODE RETOUR : ' ZCODE-RET
                DISPLAY '--- LIBELLE ERR : '      ZLIBERR
                PERFORM FIN
             END-IF

      *LECTURE DE L'EMPLOYE 100
             INITIALIZE ZACCESSEUR
             MOVE '100'    TO ZMAT
             PERFORM LECTURE-EMPLOYE
             
      *CREATION DU DEPARTEMENT DEP
             INITIALIZE DACCESSEUR
             MOVE 'C'      TO DCODE-FONC
             MOVE 'DEP'    TO DNOD
             MOVE 'JOHNNY' TO DNDE
             MOVE 'BATD'   TO DLIE
             MOVE '10'     TO DCHE
             
             DISPLAY SPACES
             DISPLAY '********** TABLE DEPARTEMENT ***********'
             DISPLAY '--- CODE FONCTION : ' DCODE-FONC
             DISPLAY '--- NOD : ' DNOD
             DISPLAY '--- NDE : ' DNDE
             DISPLAY '--- LIE : ' DLIE
             DISPLAY '--- CHE : ' DCHE
             
             CALL ACCESS2A USING DACCESSEUR
             
             IF ZCODE-RET = ZEROES
                DISPLAY '--- CODE RETOUR : '  DCODE-RET
                DISPLAY '--- CREATION DEPT EFFECTUÉE'
             ELSE
                DISPLAY '--- ERR, CODE RETOUR : ' DCODE-RET
                DISPLAY '--- LIBELLE ERR : '      DLIBERR
             END-IF
             
      *LECTURE DU DEPT DEP
             INITIALIZE DACCESSEUR
             MOVE 'DEP'    TO DNOD
             PERFORM LECTURE-DEPARTEMENT   
          
      *MODIFICATION DU DEPARTEMENT DEP      
             INITIALIZE ZACCESSEUR
             MOVE 'M'      TO DCODE-FONC
             MOVE 'DEP'    TO DNOD
             MOVE 'RH'     TO DNDE
             MOVE 'BATI'   TO DLIE
             MOVE '20'     TO DCHE
             
             DISPLAY SPACES
             DISPLAY '--- CODE FONCTION : '   DCODE-FONC
             DISPLAY '--- NOD : '             DNOD
             DISPLAY '--- NDE : '             DNDE
             DISPLAY '--- LIE : '             DLIE
             DISPLAY '--- CHE : '             DCHE
             
             CALL ACCESS2A USING DACCESSEUR
             
             IF ZCODE-RET = ZEROES
                DISPLAY '--- CODE RETOUR : '  DCODE-RET
                DISPLAY '--- MODIFICATION DEPT EFFECTUÉE'
             ELSE
                DISPLAY '--- ERR, CODE RETOUR : ' DCODE-RET
                DISPLAY '--- LIBELLE ERR : '      DLIBERR
             END-IF  
          
      *LECTURE DU DEPARTEMENT DEP
             INITIALIZE DACCESSEUR
             MOVE 'DEP'    TO DNOD
             PERFORM LECTURE-DEPARTEMENT
             
             
      *LISTE DES DEPARTEMENTS
      *OUVERTURE DU CURSEUR
             INITIALIZE DACCESSEUR
             MOVE 'O'      TO DCODE-FONC
             CALL ACCESS2A USING DACCESSEUR
             IF DCODE-RET = ZEROES
                DISPLAY 'OUVERTURE LISTE OK'
             ELSE
                DISPLAY '--- ERR, CODE RETOUR : ' DCODE-RET
                DISPLAY '--- LIBELLE, ERR : ' DLIBERR
                PERFORM FIN
             END-IF
 
      *BOUCLE DE LECTURE
             INITIALIZE DACCESSEUR
             MOVE 'Q'      TO DCODE-FONC
             CALL ACCESS2A USING DACCESSEUR
             PERFORM UNTIL DCODE-RET = 19
               IF DCODE-RET = ZEROES
                  DISPLAY SPACES
                  DISPLAY '--- NOD : ' DNOD
                  DISPLAY '--- NDE : ' DNDE
                  DISPLAY '--- LIE : ' DLIE
                  DISPLAY '--- CHE : ' DCHE
               ELSE
                  DISPLAY '--- ERR, CODE RETOUR : ' DCODE-RET
                  DISPLAY '--- LIBELLE ERR : ' DLIBERR
                  PERFORM FIN
               END-IF
            
      *FERMETURE DU CURSEUR
               INITIALIZE DACCESSEUR
               MOVE 'F'      TO DCODE-FONC
               CALL ACCESS2A USING DACCESSEUR
               
               IF DCODE-RET = ZEROES
                  DISPLAY 'FERMETURE LISTE OK'
               ELSE
                  DISPLAY '--- ERR, CODE RETOUR : ' DCODE-RET
                  DISPLAY '--- LIBELLE ERR : ' DLIBERR 
                  PERFORM FIN
               END-IF
               
      *SUPPRESSION D'UN DEPARTEMENT
               INITIALIZE DACCESSEUR
               MOVE 'S'      TO DCODE-FONC
               MOVE 'DEP'    TO DNOD
               CALL ACCESS2A USING DACCESSEUR
               
               IF DCODE-RET = ZEROES
                  DISPLAY 'SUPPRESSION DEPT ' DNOD ' OK'
               ELSE
                  DISPLAY '--- ERR, CODE RETOUR : ' DCODE-RET
                  DISPLAY '--- LIBELLE ERR : ' DLIBERR
                  PERFORM FIN
               END-IF
               
      *LECTURE DU DEPT DEP
               INITIALIZE DACCESSEUR
               MOVE 'DEP'    TO DNOD
               PERFORM LECTURE-DEPARTEMENT
               .
          
      *LECTURE D'UN EMPLOYE
         LECTURE-EMPLOYE.
               MOVE 'L'      TO ZCODE-FONC
               DISPLAY SPACES
               DISPLAY '--- CODE FONCTION : ' ZCODE-FONC
               DISPLAY '--- MAT : ' ZMAT
               
               CALL ACCESS2 USING ZACCESSEUR
               
               IF ZCODE-RET = ZEROES
                  DISPLAY '--- NOM : ' ZNOM
                  DISPLAY '--- NOD : ' ZNOD
                  DISPLAY '--- DAT : ' ZDAT
                  MOVE ZSAL TO ED-ZSAL
                  DISPLAY '--- SAL : ' ED-ZSAL
                  MOVE ZCOM TO ED-ZCOM
                  DISPLAY '--- COM : ' ED-ZCOM
                ELSE
                  DISPLAY '--- ERREUR, CODE RETOUR : ' ZCODE-RET
                  DISPLAY '---- LIBELLE ERR : ' ZLIBERR
                END-IF
                .
                
      *LECTURE D'UN DEPARTEMENT
       LECTURE-DEPARTEMENT.
               MOVE 'L'      TO ZCODE-FONC
               DISPLAY SPACES
               DISPLAY '--- CODE FONCTION : ' ZCODE-FONC
               DISPLAY '--- NOD : ' ZNOD
               
               CALL ACCESS2A USING DACCESSEUR
               
               IF ZCODE-RET = ZEROES
                  DISPLAY '--- NDE : ' DNDE
                  DISPLAY '--- LIE : ' DLIE
                  DISPLAY '--- CHE : ' DCHE
                ELSE
                  DISPLAY '--- ERREUR, CODE RETOUR : ' DCODE-RET
                  DISPLAY '---- LIBELLE ERR : ' DLIBERR
                END-IF
                .      
                
          FIN.
          STOP RUN
          .

