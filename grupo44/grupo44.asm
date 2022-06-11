; *********************************************************************************
; * Grupo 44:
; * Alexandre Duarte - 102948
; * David Nunes      - 102890
; * Érik Bianchi     - 103580
; *********************************************************************************

; *********************************************************************************
; * Constantes
; *********************************************************************************
TEC_LIN				     EQU 0C000H	      ; endereço das linhas do teclado
TEC_COL				     EQU 0E000H	      ; endereço das colunas do teclado (periférico PIN)
LINHA_TECLADO            EQU 8		      ; linha a testar (4ª linha, 1000b)
MASCARA				     EQU 0FH	      ; para isolar os 4 bits de menor peso, ao ler as colunas do teclado

TECLA_ESQUERDA			 EQU 11H	      ; tecla 0
TECLA_DIREITA		     EQU 14H	      ; tecla 2
TECLA_START			     EQU 81H          ; tecla C
TECLA_DISPARAR 			 EQU 12H
TECLA_PAUSAR			 EQU 82H
TECLA_TERMINAR			 EQU 84H

DISPLAYS                 EQU 0A000H	      ; endereço do periférico dos displays

DEFINE_LINHA    	     EQU 600AH        ; endereço do comando para definir a linha
DEFINE_COLUNA   	     EQU 600CH        ; endereço do comando para definir a coluna
DEFINE_PIXEL        	 EQU 6012H        ; endereço do comando para escrever um pixel
APAGA_AVISO     	     EQU 6040H        ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		     EQU 6002H        ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU 6042H        ; endereço do comando para selecionar uma imagem de fundo
REPRODUZ_SOM             EQU 605AH        ; comando que inicia a reprodução do audio específicado

LINHA        		     EQU 25           ; linha do boneco (a meio do ecrã))
COLUNA					 EQU 30           ; coluna do boneco (a meio do ecrã)

LINHA_POK				 EQU 1            ; linha do "meteorito"
COLUNA_POK				 EQU 6            ; coluna do "meteorito"

MIN_COLUNA				 EQU 0		      ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA				 EQU 63           ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA  				 EQU 32
ATRASO			 		 EQU 29H		  ; atraso para limitar a velocidade de movimento do boneco

LARGURA					 EQU 5 			  ; largura do boneco
COR_PIXEL_VERMELHO		 EQU 0FF00H		  ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_PIXEL_AMARELO   	 EQU 0FFD3H       ; cor do pixel: amarelo em ARGB (com opacidade máxima)
COR_PIXEL_PRETO     	 EQU 0F000H       ; cor do pixel: preto em ARGB (com opacidade máxima)
COR_PIXEL_CINZENTO  	 EQU 0F79CH       ; cor do pixel: cinzento em ARGB (com opacidade máxima)
COR_PIXEL_BRANCO		 EQU 0FFFFH       ; cor do pixel: branco em ARGB (com opacidade máxima)

VIDA    				 EQU 0CCH		  ; valor inicial da grandeza "vida", que aparece no display

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

	STACK 100H
SP_inicial_prog_princ:

	STACK 100H
SP_inicial_teclado:

	STACK 100H
SP_inicial_boneco:

	STACK 100H
SP_inicial_meteoro:

DEF_BONECO:				; tabela que define o boneco (cor, largura, pixels)
	WORD		LARGURA
	WORD		COR_PIXEL_PRETO, 0, 0, 0, COR_PIXEL_PRETO
	WORD		COR_PIXEL_AMARELO, COR_PIXEL_PRETO, COR_PIXEL_AMARELO, COR_PIXEL_PRETO, COR_PIXEL_AMARELO
	WORD		0, COR_PIXEL_VERMELHO, COR_PIXEL_AMARELO, COR_PIXEL_VERMELHO, 0
	WORD		COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO
	WORD		0, COR_PIXEL_AMARELO, 0, COR_PIXEL_AMARELO, 0

DEF_POKEBOLA: 			; tabela que define o "meteorito" (cor, largura, pixels)
	WORD		LARGURA
	WORD		0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0 		
	WORD		COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO
	WORD		COR_PIXEL_PRETO, COR_PIXEL_PRETO, COR_PIXEL_CINZENTO, COR_PIXEL_PRETO, COR_PIXEL_PRETO
	WORD		COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO
	WORD		0, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, 0

TECLA_CARREGADA: WORD 0

MOV_DOWN: WORD 0

PAUSA: WORD 0

BTE_START:
	WORD meteoros_interrupt
	WORD 0
	WORD 0
	WORD 0

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                    		    ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial_prog_princ	    ; inicializa SP para a palavra a seguir
						                ; à última da pilha
	MOV  BTE,  BTE_START										

	EI0
	EI

    MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 1							; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo

	CALL teclado

menu:
	YIELD
	MOV  R0, TECLA_START
	MOV  R1, [TECLA_CARREGADA]
	CMP  R0, R1
	JNZ  menu

start:
	CALL boneco
	CALL meteoro
	MOV	 R1, 0							; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV  R3, VIDA                       ; coloca ao valor da vida para posterior amostra no display
	CALL converte_hex_dec
	CALL display                        ; mostra valor atual da vida ao utilizador

main:
	YIELD
	MOV  R1, [TECLA_CARREGADA]
	MOV  R0, TECLA_PAUSAR
	CMP  R0, R1
	JZ   pausa
	JMP  main

pausa:
	MOV  R0, [PAUSA]
	CMP  R0, 0
	JZ   pausar
	MOV  R0, 0
	MOV  [PAUSA], R0
	JMP  main

pausar:
	MOV  R0, 1
	MOV  [PAUSA], R0
	JMP  main

; **********************************************************************
; TECLADO - Faz uma leitura às teclas do teclado e retorna o valor lido
;				
; **********************************************************************

PROCESS SP_inicial_teclado
teclado:
	MOV  R2, TEC_LIN  				; endereço do periférico das linhas
	MOV  R3, TEC_COL   				; endereço do periférico das colunas
	MOV  R5, MASCARA   				; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV  R6, LINHA_TECLADO       	; linha a testar no teclado
	JMP teclado_loop

linha_original:
	
	YIELD
	MOV  R6, LINHA_TECLADO       		; linha a testar no teclado

teclado_loop:
	MOVB [R2], R6      					; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      					; ler do periférico de entrada (colunas)
	AND  R0, R5        					; elimina bits para além dos bits 0-3
	CMP  R0, 0                     	 	; verifica se há tecla premida na linha atual
	JNZ  testa_teclas               	; se há, sai da rotina
muda_linha:
    SHR  R6, 1                      	; muda para linha acima
    CMP  R6, 0                      	; verifica se todas as linhas foram vistas
    JNZ  teclado_loop               	; se não terminaram as linhas, volta a testar
	
	MOV  R0, 0
	MOV  [TECLA_CARREGADA], R0
	JMP  linha_original

testa_teclas:
	SHL  R6, 4			             	; coloca linha no nibble high
    OR   R6, R0				         	; junta coluna (nibble low)
	MOV  [TECLA_CARREGADA], R6

	MOV  R0, TECLA_ESQUERDA
	CMP  R6, R0
	JZ   linha_original
	MOV  R0, TECLA_DIREITA
	CMP  R6, R0
	JZ   linha_original

espera_nao_tecla:
	YIELD

	MOV  R0, 0
	MOV  [TECLA_CARREGADA], R0
	MOV  R6, LINHA_TECLADO

	MOVB [R2], R6      					; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      					; ler do periférico de entrada (colunas)
	AND  R0, R5        					; elimina bits para além dos bits 0-3
	CMP  R0, 0                      	; verifica se há tecla premida na linha atual
	JNZ  espera_nao_tecla
	JMP  linha_original


PROCESS SP_inicial_boneco

boneco:
    MOV  R1, LINHA						; linha do boneco
    MOV  R2, COLUNA						; coluna do boneco
	MOV	 R4, DEF_BONECO					; endereço da tabela que define o boneco
	MOV	 R8, [R4]
	MOV  R7, 0
	MOV  R11, ATRASO
	CALL desenha_boneco					; desenha o boneco a partir da tabela

ciclo_boneco:
	YIELD

	MOV  R0, [PAUSA]
	CMP  R0, 1
	JZ   ciclo_boneco

	MOV  R3, [TECLA_CARREGADA]
	MOV  R0, TECLA_ESQUERDA
	CMP  R3, R0
	JZ   move_esquerda
	MOV  R0, TECLA_DIREITA
	CMP  R3, R0
	JNZ ciclo_boneco

move_direita:
	MOV	 R7, +1							; vai deslocar para a direita
	CALL testa_limites
	CMP  R7, 0
	JNZ  ciclo_atraso
	JMP  ciclo_boneco

move_esquerda:
	MOV	 R7, -1							; vai deslocar para a esquerda
	CALL testa_limites
	CMP  R7, 0
	JZ   ciclo_boneco

ciclo_atraso:
	YIELD 

	MOV  R0, [PAUSA]
	CMP  R0, 1
	JZ   ciclo_atraso

	SUB	 R11, 1               ; decrementa o tempo de atraso
	JNZ	 ciclo_atraso         ; se o tempo de atraso ainda termina, continua

movimento_boneco:
	MOV  R11, ATRASO
	CALL apaga_boneco
	ADD R2, R7
	CALL desenha_boneco
	JMP ciclo_boneco

PROCESS SP_inicial_meteoro

meteoro:
    MOV  R1, LINHA_POK					; linha do boneco
    MOV  R2, COLUNA_POK					; coluna do boneco
	MOV	 R4, DEF_POKEBOLA				; endereço da tabela que define o boneco
	MOV	 R8, [R4]
	CALL desenha_boneco					; desenha o boneco a partir da tabela

ciclo_meteoro:
	YIELD

	MOV  R0, [PAUSA]
	CMP  R0, 1
	JZ   ciclo_meteoro

	MOV  R0, [MOV_DOWN]
	CMP  R0, 0
	JZ   ciclo_meteoro
	MOV  R0, MAX_LINHA
	SUB  R0, R8
	CMP  R1, R0
	JZ   acaba_meteoro

desce_pok:
	CALL apaga_boneco                   ; apaga o "meteorito" na posição atual
	ADD  R1, 1                          ; incrementa o valor da posição da linha
	CALL desenha_boneco                 ; desenha o "meteorito" na nova posição
	MOV  R0, 0                         
	MOV  [MOV_DOWN], R0
	JMP  ciclo_meteoro                  ; esperar que uma tecla não esteja a ser premida

acaba_meteoro:
	CALL apaga_boneco                   ; apaga o "meteorito" na posição atual
	SUB  R8, 1
	JZ   sair_meteoro
	ADD  R1, 1                          ; incrementa o valor da posição da linha
	CALL desenha_boneco                 ; desenha o "meteorito" na nova posição
	MOV  R0, 0                         
	MOV  [MOV_DOWN], R0
	JMP  ciclo_meteoro
	
sair_meteoro:
	YIELD
	JMP  sair_meteoro

; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R0 - coluna inicial
;				R1 - linha
;               R2 - coluna
;				R3 - cor do próximo pixel
;               R4 - tabela que define o boneco
;				R5 - número de colunas
;				R6 - largura do boneco
;				R8 - numero de linhas
;
; **********************************************************************
desenha_boneco:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R0
	MOV  R0, R2             ; coloca valor da coluna num registo temporário
	MOV	 R6, [R4]			; obtém a largura do boneco
	MOV  R5, R6             ; número de colunas a tratar
	MOV  R7, R8                 ; número de linhas a tratar
	ADD	 R4, 2				; endereço da cor do 1º pixel (2 porque a largura é uma word)
desenha_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	 R3, [R4]			; obtém a cor do próximo pixel do boneco
	CALL escreve_pixel		; escreve cada pixel do boneco
	ADD	 R4, 2				; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1              ; próxima coluna
    SUB  R5, 1				; menos uma coluna para tratar
    JNZ  desenha_pixels     ; continua até percorrer toda a largura do objeto
	MOV  R5, R6             ; reseta o número de colunas a tratar
	MOV  R2, R0             ; reseta a posição da coluna atual
	ADD  R1, 1              ; passa para a linha seguinte
	SUB  R7, 1              ; menos uma linha para tratar
	JNZ  desenha_pixels     ; continua até percorrer toda a altura do objeto
	POP  R0
	POP  R7
	POP  R6
	POP	 R5
	POP	 R4
	POP	 R3
	POP	 R2
	POP  R1
	RET

; **********************************************************************
; APAGA_BONECO - Apaga um boneco na linha e coluna indicadas
;			  com a forma definida na tabela indicada.
; Argumentos:   R0 - coluna inicial
;				R1 - linha
;               R2 - coluna
;				R3 - cor do próximo pixel
;               R4 - tabela que define o boneco
;				R5 - número de colunas
;				R6 - largura do boneco
;				R7 - numero de linhas
;
; **********************************************************************
apaga_boneco:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R0
	MOV  R0, R2             ; posição inicial da primeira coluna do boneco
	MOV	 R6, [R4]			; obtém a largura do boneco
	MOV  R5, R6             ; número de colunas a tratar
	MOV  R7, R8             ; número de linhas a tratar
	ADD	 R4, 2				; endereço da cor do 1º pixel (2 porque a largura é uma word)
apaga_pixels:       		; desenha os pixels do boneco a partir da tabela
	MOV	 R3, 0				; cor para apagar o próximo pixel do boneco
	CALL escreve_pixel		; escreve cada pixel do boneco
	ADD	 R4, 2				; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1              ; próxima coluna
    SUB  R5, 1				; menos uma coluna para tratar
    JNZ  apaga_pixels       ; continua até percorrer toda a largura do objeto
	MOV  R5, R6             ; reseta o número de colunas a tratar
	MOV  R2, R0             ; reseta a posição da coluna atual
	ADD  R1, 1              ; passa para a linha seguinte
	SUB  R7, 1              ; menos uma linha para tratar
	JNZ  apaga_pixels       ; continua até percorrer toda a altura do objeto
	POP  R0
	POP  R7
	POP  R6	
	POP	 R5
	POP	 R4
	POP	 R3
	POP	 R2
	POP  R1
	RET


; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:   R1 - linha
;               R2 - coluna
;               R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV  [DEFINE_LINHA], R1	  ; seleciona a linha
	MOV  [DEFINE_COLUNA], R2  ; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	  ; altera a cor do pixel na linha e coluna já selecionadas
	RET

; **********************************************************************
; TESTA_LIMITES - Testa se o boneco chegou aos limites do ecrã e nesse caso
;			   impede o movimento (força R7 a 0)
; Argumentos:	R2 - coluna em que o objeto está
;			    R6 - largura do boneco
;				R7 - sentido de movimento do boneco (valor a somar à coluna
;				em cada movimento: +1 para a direita, -1 para a esquerda)
;
; Retorna: 	R7 - 0 se já tiver chegado ao limite, inalterado caso contrário	
; **********************************************************************
testa_limites:
	PUSH R5
	PUSH R6
	MOV  R6, [R4]
testa_limite_esquerdo:				; vê se o boneco chegou ao limite esquerdo
	MOV	 R5, MIN_COLUNA             ; número da coluna mais à esquerda que o objeto pode ocupar
	CMP	 R2, R5                     ; verifica se o boneco está no limite esquerdo
	JGT	 testa_limite_direito       ; se não, testa o limite direito
	CMP	 R7, 0						; verifica se está parado
	JGE	 sai_testa_limites          ; se o boneco está parado, termina a rotina
	JMP	 impede_movimento			; se não está parado, força este estado
testa_limite_direito:				; vê se o boneco chegou ao limite direito
	ADD	 R6, R2						; posição a seguir ao extremo direito do boneco
	MOV	 R5, MAX_COLUNA             ; número da coluna mais à direita que o objeto pode ocupar
	CMP	 R6, R5                     ; verifica se o boneco está no limite direito
	JLE	 sai_testa_limites			; se sim, termina a rotina
	CMP	 R7, 0						; passa a deslocar-se para a direita
	JGT	 impede_movimento           ; se não, para o boneco
	JMP	 sai_testa_limites          ; termina a rotina
impede_movimento:
	MOV	 R7, 0						; impede o movimento, forçando R7 a 0
sai_testa_limites:	
	POP	 R6 
	POP	 R5
	RET

; **********************************************************************
; CONVERTE_HEX_DEC - converte o valor da vida de hexadecimal para decimal

; Argumentos:   R3 - vida atual
;
; **********************************************************************
converte_hex_dec:
	PUSH R1
	PUSH R2
	PUSH R0
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	MOV R6, 0						; inicializar a 0 o valor da vida em decimal
	MOV R5, 10H						; valor da divisão entre duas casas hexadecimais seguidas
	MOV R4, 0AH						; valor da divisão entre duas casas decimais seguidas
	MOV R2, 1						; inicializar valor pelo qual vamos multiplicar computação duma certa casa hexadecimal (16^(nºcasa hexadecimal em questão))
	MOV R7, 16H
	JMP converte_loop

letra_detetada:
	MOV R7, 1
	JMP retirar_letras_loop_2

converte_loop:
	MOV R0, R3

	MOD R0, R5						; último digito do input
	DIV R3, R5						; resto do input

	MOV R1, R0						
	MOD R1, R4						; ultimo digito do [ultimo digito do input] em decimal
	DIV R0, R4
	MUL R0, R5
	
	MUL R0, R2						; multiplicar computação pelo valor em decimal
	MUL R1, R2

	ADD R6, R1
	ADD R6, R0
	
	MUL R2, R7
	CMP R3, 0
	JNZ converte_loop


retirar_letras:
	MOV R3, R6
	MOV R6, 0
	MOV R2, 1
	MOV R7, 0						; booleano para verificar se ainda foram detetadas letras

retirar_letras_loop:
	MOV R0, R3

	MOD R0, R5						; último digito do input
	DIV R3, R5						; resto do input

	MOV R1, R0						
	MOD R1, R4						; ultimo digito do [ultimo digito do input] em decimal
	DIV R0, R4
	MUL R0, R5
	CMP R0, 0
	JNZ letra_detetada				;se letra detetada, alterar booleano

retirar_letras_loop_2:
	MUL R0, R2						; multiplicar computação pelo valor em decimal
	MUL R1, R2

	ADD R6, R1
	ADD R6, R0
	
	MUL R2, R5
	CMP R3, 0
	JNZ retirar_letras_loop
	

converte_saida:
	MOV R3, R6
	CMP R7, 0
	JNZ retirar_letras
	POP R7
	POP R6
	POP R5
	POP R4
	POP R0
	POP R2
	POP R1

; **********************************************************************
; CONVERTE_DEC_HEX - converte o valor da vida de decimal para hexadecimal

; Argumentos:   R3 - vida atual
;
; **********************************************************************

converte_dec_hex:
	PUSH R1
	PUSH R2
	PUSH R0
	PUSH R6
	PUSH R7
	MOV R7, 10H
	MOV R6, 0AH
	MOV R0, 0			; inicializar output(hexadecimal) a 0

dec_hex_loop:
	MOV R1, R3
	DIV R3, R7
	MOD R1, R7
	MUL R1, R6
	ADD R0, R1
	CMP R3, 0
	JNZ dec_hex_loop

dec_hex_saida:
	MOV R3, R0
	POP R7
	POP R6
	POP R0
	POP R2
	POP R1

; **********************************************************************
; DISPLAY - mostra o valor da grandeza "vida" ao utilizador

; Argumentos:   R3 - vida atual
;
; **********************************************************************
display:
	PUSH R1
	PUSH R2
	PUSH R4
	MOV  R1, TEC_LIN   				; endereço do periférico das linhas
    MOV  R2, TEC_COL   				; endereço do periférico das colunas
    MOV  R4, DISPLAYS  				; endereço do periférico dos displays
	MOV  [R4], R3       			; escreve a vida atual nos displays
	POP	 R4
	POP	 R2
	POP  R1
	RET


; Interrupts

meteoros_interrupt:
	PUSH R0

	MOV R0, 1
	MOV [MOV_DOWN], R0

	POP R0
	RFE
