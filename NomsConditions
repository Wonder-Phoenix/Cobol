#********************************************************************************************************************#
#  ÉNONCÉ : Utilisation des noms conditions ; Utilisation de la fonction EVALUATE                                    #
#           Écrire les variables suivantes en déclarant les noms conditions adéquats :                               #
#               - le statut d'un compte ouvert s'il est égal à 'O', bloqué pour 'B', clôturé pour 'C' puis afficher  #
#                 le statut ;                                                                                        #
#               - le compte est créditeur si son solde est positif ou nul, débiteur s'il est négatif puis afficher   #
#                 le sens créditeur ou débiteur                                                                      #
#********************************************************************************************************************#

#*******************************************************************#
#                            PROGRAMME                              #
#*******************************************************************#

IDENTIFICATION DIVISION.
 PROGRAM-ID. EXO6.
 AUTHOR. SV.
 DATE-WRITTEN. 20/03/2023.
******************************************************************
*  FONCTION DU PROGRAMME :  EXERCICE SUR LES NOMS CONDITIONS     *
******************************************************************
 ENVIRONMENT DIVISION.
 CONFIGURATION SECTION.
 SPECIAL-NAMES.
     DECIMAL-POINT IS COMMA.
     
 DATA DIVISION.
 
 WORKING-STORAGE SECTION.
* VARIABLE POUR LE POSITIONNEMENT DU STATUT DU COMPTE
01  STATUT           PIC X        VALUE SPACES.
    88 OUVERT                     VALUE 'O'.
    88 BLOQUE                     VALUE 'B'.
    88 CLOTURE                    VALUE 'C'.

* VARIABLES POUR LE POSITIONNEMENT DU SENS DU SOLDE
01 SOLDE             PIC S9(9)V99 VALUE +2436,91.
01                   PIC X        VALUE SPACES.
    88 CREDITEUR                  VALUE 'C'.
    88 DEBITEUR                   VALUE 'D'.

 PROCEDURE DIVISION.
     DISPLAY SPACES
     DISPLAY '-----------'
     DISPLAY '  STATUT   '
     DISPLAY '-----------'
     DISPLAY SPACES
     
     ACCEPT STATUT
     
* 1ERE FORME POSSIBLE
     EVALUATE STATUT
      WHEN 'O'
           DISPLAY 'COMPTE OUVERT'
      WHEN 'B'
           DISPLAY 'COMPTE BLOQUE'
      WHEN 'C'
           DISPLAY 'COMPTE CLOTURE'
      WHEN OTHER
           DISPLAY 'STATUT ERRONE'
     END-EVALUATE
     
* 2EME FORME POSSIBLE
     EVALUATE TRUE
      WHEN OUVERT
           DISPLAY 'COMPTE OUVERT'
      WHEN BLOQUE
           DISPLAY 'COMPTE BLOQUE'
      WHEN CLOTURE
           DISPLAY 'COMPTE CLOTURE'
      WHEN OTHER
           DISPLAY 'STATUT ERRONE'
     END-EVALUATE
     
     DISPLAY SPACES
     DISPLAY '-----------'
     DISPLAY '  COMPTE   '
     DISPLAY '-----------'
     DISPLAY SPACES

IF SOLDE < 0
   SET DEBITEUR TO TRUE
ELSE
   SET CREDITEUR TO TRUE
END-IF

IF DEBITEUR
   DISPLAY 'COMPTE DEBITEUR'
ELSE
   DISPLAY 'COMPTE CREDITEUR'
END-IF

STOP RUN.
