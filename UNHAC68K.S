; //////////////////////////////////////////////////////
; //////////////////////////////////////////////////////
; //////////////////////////////////////////////////////
; ///                                                ///
; /// >>> UnHac68K - Assembler Version - KOOS 98 <<< ///
; ///                                                ///
; /// Version 1.10 - May 1998                        ///
; ///                                                ///
; //////////////////////////////////////////////////////
; ///                                                ///
; ///                                                ///
; //////////////////////////////////////////////////////
; //////////////////////////////////////////////////////
; //////////////////////////////////////////////////////
	
	move.l	4(SP),A6		; Adresse de la BASEPAGE
	lea	$80(A6),A6		; Adresse de la COMMAND-TAIL
	move.b	(A6)+,D0		; Taille de la COMMAND-TAIL (ATTENTION : Format PASCAL)
	lea	Tempo_Path,A5
	BNE	Copy_File_Name		; Si la COMMAND-TAIL existe...
	move.b	#0,(A5)+		; Pas de COMMAND-TAIL
	BRA	Init_PRG_Mem

Copy_File_Name	move.b	(A6)+,(A5)+		; Copie de la COMMAND-TAIL
	subq.b	#1,D0
	bne	Copy_File_Name
	clr.b	(A5)		; Mets un OCTET nul … la fin de la chaine (ATTENTION : Transformation au format C)

Init_PRG_Mem	movea.l	4(SP),A6		; Adresse de la BasePage
	move.l	$C(A6),D0		; Taille du SEGMENT TEXT
	add.l	$14(A6),D0		; Additionne la taille du SEGMENT DATA … D0
	add.l	$1C(A6),D0		; Additionne la taille du SEGMENT BSS … D0
	addi.l	#$100,D0		; Additionne la taille de la BasePage … D0
	addi.l	#$400,D0		; Additionne la taille de la future PILE (Ici, 256 mots longs (1 Ko))
	move.l	D0,D1		; Copie D0 dans D1 (Taille … r‚server)
	add.l	A6,D1		; Additionne l'adresse du d‚but du programme avec D1 (La taille … r‚server)
	andi.l	#-2,D1		; Rend D1 pair (Au cas o— il ne l'‚tait pas)
	movea.l	D1,SP		; Installe l'adresse de fin du programme+place nouvelle PILE dans la PILE
	move.l	A6,4(SP)		; Adresse de la BasePage
	move.l	D0,-(SP)		; EmPILE la taille … reserver	\
	move.l	A6,-(SP)		; EmPILE l'adresse du programme |-> Rend le reste de la m‚moire au systŠme
	clr.w	-(SP)		; R‚serv‚                       |
	move.w	#$4A,-(SP)		; - M_SHRINK -                  |
	trap	#1		; *** GEMDOS ***                /
	lea	12(SP),SP

