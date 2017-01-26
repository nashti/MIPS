
	.data

debut :                .asciiz "SUDOKU"	
s:         .asciiz " \n grille initiale : \n \n"



espace :        .asciiz " | "
trait :		.asciiz "\n  |           |           |           ]\n  | "		#ligne pour afficher les nombres regroupés par 3
trait_case:    	.asciiz "\n  [-----------+-----------+-----------]\n  | "		#trait pour séparer les cases 
fin_grille :    .asciiz "\n  [-----------+-----------+-----------]\n"   		#trait à la fin de la grille
rien :          .asciiz "*" 								#étoile pour dire qu'l n'y a rien





grille : 				
    .byte 5, 3, 0, 0, 7, 0, 0, 0, 0
    .byte 6, 0, 0, 1, 9, 5, 0, 0, 0
    .byte 0, 9, 8, 0, 0, 0, 0, 6, 0
    .byte 8, 0, 0, 0, 6, 0, 0, 0, 3
    .byte 4, 0, 0, 8, 0, 3, 0, 0, 1
    .byte 7, 0, 0, 0, 2, 0, 0, 0, 6
    .byte 0, 6, 0, 0, 0, 0, 2, 8, 0
    .byte 0, 0, 0, 4, 1, 9, 0, 0, 5
    .byte 0, 0, 0, 0, 8, 0, 0, 7, 9



	.text
	
main:

la $a0, debut        
li $v0, 4
syscall                     		# on affiche "SUDOKU"
    
    				
    								
la $a0, s       
li $v0, 4
syscall                     		#on affiche "grille initiale :"				
			

addi $sp,$sp,-64			#Ouverture pour la fonction affichage
addi $fp,$sp,64
lb $a0, grille + 0($t0)             	#on charge la case actuelle
sw $a0,0($sp)
jal affichage				#Appel de la fonction affichage
lw $a0,0($sp)				#Fermeture pour la fonction affichage
		


addi $sp,$sp,-64			#Ouverture pour la fonction grille_valide
addi $fp,$sp,64
sw $a0,0($sp)

jal grille_valide				#Appel de la fonction qui vérifie si la grille est valide
#beq $v0, $0, return_fail    # si elle n'est pas fausse, on poursuit

lw $a0,0($sp)				#Fermeture pour la fonction grille_valide










add $a0,$v0,$zero
ori $v0,$zero,1
syscall


 
 
 




ori $v0,$0,10
syscall		
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										
										# // AFFICHAGE //                           
  
 			
 						
 												
affichage: 
addi $sp,$sp,-8				#Prologue
sw $ra,0($sp)
sw $fp,4($sp)
addi $fp,$sp,8

    li $t0, 0                           #case actuelle 
    
separer_case: 
    la $a0, trait_case               	#affichage d'un trait pour separer les cases 
    li $v0, 4
    syscall
    
aff_nombres:
    lb $a0, grille + 0($t0)             #on charge la case actuelle
    li $v0, 1                           #On affiche la case actuelle
    beq $a0, $0, etoile   		#si la case contient un 0, on affiche une étoile
 

    li $v0, 1                           #Si c'est un chiffre autorisé, on l'affiche
    syscall
    
    j continue


etoile:                 		#si la case contient un 0 
    la $a0, rien                        
    li $v0, 4                           #on affiche un point
    syscall
    
continue: 
    la $a0, espace                      #Pour afficher un espace entre les chiffres
    li $v0, 4
    syscall
    
    addi $t0, $t0, 1                    #On incrémente l'indice

    beq $t0, 81, dernier             	#On fait un saut à "dernier" pour afficher la dernière ligne si on arrive à 81
    
    addi $t2,$0,27			#On charge 27 pour l'utiliser et afficher un trait après 27 chiffres
    
    div $t0, $t2                    	#On affiche un trait case pour séparer 29 chiffres
    mfhi $t1
    beq $t1, $0, separer_case
    
    addi $t2,$0,9			#On charge 9 pour l'utiliser afin de passer à la ligne
    
    div $t0,$t2                     	#On affiche un trait sur le quel on affiche les chiffes
    mfhi $t1
    beq $t1, $0, ligne
    
    j aff_nombres			
			
ligne: 
    la $a0, trait                	#On affiche un trait 
    li $v0, 4
    syscall
    j aff_nombres			#On continue par afficher les chiffres
    
dernier:
    la $a0, fin_grille                  #On affiche le dernier trait

    li $v0, 4
    syscall
    		

lw $ra,0($sp)				#Epilogue
lw $fp,4($sp)
addi $sp,$sp,8
 
 jr $ra
 
 		
 				
			
			
			
			
			
			
			
			# // VERIFICATION//






verification :

addi $sp,$sp,-8				#Prologue
sw $ra,0($sp)
sw $fp,4($sp)
addi $fp,$sp,8



    li $t9, 9		
    div $a1, $t9
    mflo $t0              #On a la ligne qui contient a1
    mfhi $t2              #On a la colonne contenant a1 (premiere case de la colonne contenant a1)
    
    addi $t1,$zero,9
    mult $t0, $t1      	#On a la premiere case de la ligne contenant a1
    mflo $t1

    addi $t3, $t1, 9      #premiere case de la ligne en dessous de a1 
    addi $t5, $t2, 81     #premiere case située sous la colonne contenant a1 
    
    				
    				
    			###########
			#  LIGNE  #
			###########
    					
    
ligne_valide : 
    beq $t1, $t3, colonne_valide            #on teste la colonne
    beq $t1, $a1, horizontal		   #On saute la case a1

    lb $t4, grille + 0($t1)                              #la case ou on est
    beq $t4, $a0, echec                      #On ne peut pas mettre a0 à cette position

horizontal :                   #Si on peut mettre a0, on passe a la case d'apès sur la ligne
    addi $t1, $t1, 1
    j ligne_valide
    
    
			###########
			# COLONNE #
			###########
				    	    

colonne_valide : 
    beq $t2, $t5, valide              			 #Après la ligne et la colonne, on teste le bloc
    beq $t2, $a1, vertical     					#On saute également la case a1
    
    lb $t4, grille + 0($t2)                              #contenue de la case
    beq $t4, $a0, echec                      #On ne peut pas y mettre a0
    
vertical  :                    #Si on peut le mettre, on passe à la case en dessous donc 9 cases plus loin
    addi $t2, $t2, 9
    j colonne_valide


			##########
			#  BLOC  #
			##########
valide :
    sub $t5, $t5, 81
    div $t6, $t0, 3
    mul $t6, $t6, 27     	#Mul est une pseudo instruction qui permet de faire une multiplication et de mettre le résultat dans $t6
    div $t7, $t5, 3
    addi $t7,$t7,3
    mul $t7, $t7, 3   		#Mul est une pseudo instruction qui permet de faire une multiplication et de mettre le résultat dans $t7
    add $t6, $t6, $t7    
    
    addi $t7, $t6, 3                                 #Ici c'est la fin de ligne
    addi $t8, $t6, 27                                #Ici c'est une fin de bloc
    
parcours :
    beq $t6, $t8, succes               #Si on a verifié tout le bloc c'est bon
    beq $t6, $t7, ligne_suivante  			  #Ici on verifie un bloc de ligne
    beq $t6, $a1, case_suivante     		#On avance d'une case
    
    lb $t4, grille + 0($t6)                           #On charge le contenu de la case
    beq $t4, $a0, succes                  #Si on ne peut pas y mettre a1, alorc c'est un échec
    j case_suivante                 		#Si on peut y mettre a1, on continue à la case suivante
    
ligne_suivante :                    		#On passe a la ligne suivante du bloc
    addi $t6, $t6, 6                                  #début d'une ligne
    addi $t7, $t7, 9                                  #fin d'une ligne
    j parcours

case_suivante :                     	#Pour passer à la case suivante
    addi $t6, $t6, 1
    j parcours



succes: 				#On retourne 1 si c'est un succès
    li $v0, 1
    lw $ra,0($sp)				#Epilogue
    lw $fp,4($sp)
    addi $sp,$sp,8
    jr $ra
    
echec : 				#On retourne 0 si c'est un échec 
    li $v0, 0
    lw $ra,0($sp)				#Epilogue
    lw $fp,4($sp)
    addi $sp,$sp,8
    jr $ra




			# // GRILLE VALIDE //
			
			
grille_valide : 
    li $s7, -1                # cases successives de la grille
    li $v0, 1                 #Valeur de sortie de la fonction
    addi $sp,$sp,-8				#Prologue
    sw $ra,0($sp)
    sw $fp,4($sp)
    addi $fp,$sp,8    

parcours_grille : 
    addi $s7, $s7, 1                        #On passe à la case suivante
    beq $s7, 81, sortie         #Si on a parcouru toute la grille, on sort de la fonction
    lb $a0, grille + 0($s7)                 #Ici on charge le contenu de la case ou on est
    
    beq $a0, $s0, parcours_grille   # 0 ou 10 dans la case actuelle, on la saute
    
    move $a1, $s7                           #on met s7 dans a1 pour l'appel de la fonction verification
    
    
    jal verification                        # on lance la verification
    
    
    beq $v0, $0, sortie         # conflit dans la case actuelle, on quitte avec $v0=0
    j parcours_grille               # pas de conflit, on passe a la case suivante

sortie :
    lw $ra,0($sp)				#Epilogue
    lw $fp,4($sp)
    addi $sp,$sp,8
    jr $ra








					# // VERIFIE LE CHIFFRE A METTRE
					
chiffre_a_mettre :
    addi $sp,$sp,-8				#Prologue
    sw $ra,0($sp)
    sw $fp,4($sp)
    addi $fp,$sp,8
    move $v0, $0                 #on initialise $v0 à 0 si jamais on sort directement
    
ch_parcours :
    add $a0, $a0, 1             #on teste si le chiffre suivant est possible
    beq $a0, 10, ch_echec  	#Si aucun chiffre ne marche,on jump à la sortie
    jal verification              #On appelle la fonction de verification
    beq $v0, $0, ch_parcours   #Si le chiffre ne marche pas, on refait la manipulation
    move $v0, $a0                 #On stocke $a0 dans $v0 si c'est valide
    
sortie_chiffre:
    lw $ra,0($sp)				#Epilogue
    lw $fp,4($sp)
    addi $sp,$sp,8
    jr $ra
    
ch_echec :
    move $v0, $0                 # on place s0 dans v0 (0 si strategie MIN, 10 si strategie MAX) 
    lw $ra,0($sp)				#Epilogue
    lw $fp,4($sp)
    addi $sp,$sp,8
    jr $ra




