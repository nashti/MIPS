
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
 
 		
 				
			
			
			
			
			
			
			








