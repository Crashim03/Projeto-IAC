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
TECLA_DISPARAR 			 EQU 12H		  ; tecla 1
TECLA_PAUSAR			 EQU 82H		  ; tecla D
TECLA_TERMINAR			 EQU 84H		  ; tecla E

DISPLAYS                 EQU 0A000H	      ; endereço do periférico dos displays

DEFINE_LINHA    	     EQU 600AH        ; endereço do comando para definir a linha
DEFINE_COLUNA   	     EQU 600CH        ; endereço do comando para definir a coluna
DEFINE_PIXEL        	 EQU 6012H        ; endereço do comando para escrever um pixel
APAGA_AVISO     	     EQU 6040H        ; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ	 		     EQU 6002H        ; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO  EQU 6042H        ; endereço do comando para selecionar uma imagem de fundo
REPRODUZ_SOM             EQU 605AH        ; comando que inicia a reprodução do audio específicado
MOSTRAR_ECRA			 EQU 6006H		  ; comando que mostra o ecrã específicado
ESCONDER_ECRA			 EQU 6008H		  ; comando que esconde o ecrã específicado
SELECIONA_ECRA			 EQU 6004H		  ; comando que seleciona o ecrã específicado

LINHA        		     EQU 27			  ; linha do boneco
COLUNA					 EQU 30           ; coluna do boneco (a meio do ecrã)

; Colunas em que os meteoros podem aparecer
COLUNA_1				 EQU 1            
COLUNA_2				 EQU 8
COLUNA_3				 EQU 16
COLUNA_4 				 EQU 24
COLUNA_5				 EQU 32
COLUNA_6				 EQU 40
COLUNA_7				 EQU 48
COLUNA_8				 EQU 56

; Linhas em que os meteoros mudam de tamanho
LINHA_METEORO_1			 EQU 1
LINHA_METEORO_2			 EQU 3
LINHA_METEORO_3			 EQU 5
LINHA_METEORO_4			 EQU 9
LINHA_METEORO_5			 EQU 14


MIN_COLUNA				 EQU 0		      ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA				 EQU 63           ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA  				 EQU 32			  ; número da linha mais abaixo que o objeto pode ocupar
ATRASO			 		 EQU 90H		  ; atraso para limitar a velocidade de movimento do boneco

LARGURA					 EQU 5 			  ; largura do boneco
LARGURA_MEDIA			 EQU 3			  ; largura dos meteoros de tamanho médio
LARGURA_PEQUENA			 EQU 2            ; largura dos meteoros de tamanho pequeno
LARGURA_QUADRADO		 EQU 1			  ; largura de um quadrado pequeno
ALTURA_TIRO				 EQU 5			  ; altura máxima que o míssil pode ir

COR_PIXEL_VERMELHO		 EQU 0FF00H		  ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_PIXEL_AMARELO   	 EQU 0FFD3H       ; cor do pixel: amarelo em ARGB (com opacidade máxima)
COR_PIXEL_PRETO     	 EQU 0F000H       ; cor do pixel: preto em ARGB (com opacidade máxima)
COR_PIXEL_CINZENTO  	 EQU 0F79CH       ; cor do pixel: cinzento em ARGB (com opacidade máxima)
COR_PIXEL_BRANCO		 EQU 0FFFFH       ; cor do pixel: branco em ARGB (com opacidade máxima)
COR_PIXEL_LARANJA        EQU 0F4ABH       ; cor do pixel: laranja em ARGB (com opacidade máxima)
COR_PIXEL_AZUL	         EQU 0F4ABH       ; cor do pixel: azul em ARGB (com opacidade máxima)
COR_PIXEL_PRETO_TRANSP   EQU 0E000H       ; cor do pixel: preto em ARGB (com alguma opacidade)

VIDA_MAX    			 EQU 064H		  ; valor inicial da grandeza "vida", que aparece no display
NUMERO_METEORITOS_TAM    EQU 5			  ; numero de tamanhos que um meteoro pode ter

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

	STACK 100H
SP_desenha_tiro:

DEF_QUADRADO_PEQUENO:	; tabela que define um quadrado pequeno (cor, largura, pixels)
	WORD		LARGURA_QUADRADO
	WORD		COR_PIXEL_PRETO

DEF_QUADRADO:			; tabela que define um quadrado (cor, largura, pixels)
	WORD		LARGURA_PEQUENA
	WORD		COR_PIXEL_PRETO, COR_PIXEL_PRETO
	WORD		COR_PIXEL_PRETO, COR_PIXEL_PRETO

DEF_BONECO:				; tabela que define o boneco (cor, largura, pixels)
	WORD		LARGURA
	WORD		COR_PIXEL_PRETO, 0, 0, 0, COR_PIXEL_PRETO
	WORD		COR_PIXEL_AMARELO, COR_PIXEL_PRETO, COR_PIXEL_AMARELO, COR_PIXEL_PRETO, COR_PIXEL_AMARELO
	WORD		0, COR_PIXEL_VERMELHO, COR_PIXEL_AMARELO, COR_PIXEL_VERMELHO, 0
	WORD		COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO
	WORD		0, COR_PIXEL_AMARELO, 0, COR_PIXEL_AMARELO, 0

DEF_POKEBOLA: 			; tabela que define o meteoro grande (cor, largura, pixels)
	WORD		LARGURA
	WORD		0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0 		
	WORD		COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO
	WORD		COR_PIXEL_PRETO, COR_PIXEL_PRETO, COR_PIXEL_CINZENTO, COR_PIXEL_PRETO, COR_PIXEL_PRETO
	WORD		COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO
	WORD		0, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, 0

DEF_POKEBOLA_MEDIA:		; tabela que define o meteoro médio (cor, largura, pixels)
	WORD	   LARGURA_MEDIA
	WORD 	   COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO
	WORD	   COR_PIXEL_PRETO, COR_PIXEL_CINZENTO, COR_PIXEL_PRETO
	WORD	   COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO

DEF_POKEBOLA_PEQUENA:	; tabela que define o meteoro pequeno (cor, largura, pixels)
	WORD	   LARGURA_PEQUENA
	WORD	   COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO
	WORD	   COR_PIXEL_BRANCO, COR_PIXEL_BRANCO

DEF_PATO:				; tabela que define o meteoro bom grande (cor, largura, pixels)
    WORD	   LARGURA
	WORD	   0, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, 0
	WORD       0, COR_PIXEL_AMARELO, COR_PIXEL_PRETO, COR_PIXEL_AMARELO, 0
	WORD	   0, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_LARANJA, COR_PIXEL_LARANJA
	WORD	   COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, 0
	WORD       0, COR_PIXEL_AMARELO, 0, COR_PIXEL_AMARELO, 0

DEF_PATO_MEDIO:			; tabela que define o meteoro bom médio (cor, largura, pixels)
	WORD       LARGURA_MEDIA
	WORD       COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, 0
	WORD       COR_PIXEL_AMARELO, COR_PIXEL_LARANJA, COR_PIXEL_LARANJA
	WORD       COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, 0

DEF_PATO_PEQUENO:		; tabela que define o meteoro bom pequeno (cor, largura, pixels)
	WORD       LARGURA_PEQUENA
	WORD       COR_PIXEL_AMARELO, COR_PIXEL_AMARELO
	WORD       COR_PIXEL_AMARELO, COR_PIXEL_LARANJA

DEF_EXPLOSAO:			; tabela que define a explosão de um meteoro (cor, largura, pixels)
	WORD		LARGURA
	WORD		0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0 		
	WORD		COR_PIXEL_PRETO, 0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO
	WORD		0, COR_PIXEL_PRETO, 0, COR_PIXEL_VERMELHO, 0
	WORD		COR_PIXEL_BRANCO, 0, COR_PIXEL_BRANCO, 0, COR_PIXEL_PRETO
	WORD		0, COR_PIXEL_BRANCO, 0, COR_PIXEL_BRANCO, 0
	

DEF_METEOROS:			; tabela que define o o tipo e o tamanho dos meteoros
	WORD       DEF_QUADRADO_PEQUENO, DEF_QUADRADO,DEF_PATO_PEQUENO, DEF_PATO_MEDIO, DEF_PATO
	WORD       DEF_QUADRADO_PEQUENO, DEF_QUADRADO, DEF_POKEBOLA_PEQUENA, DEF_POKEBOLA_MEDIA, DEF_POKEBOLA

DEF_TIRO:				; tabela que define o míssil (cor, largura, pixels)
	WORD	   LARGURA_QUADRADO
	WORD	   COR_PIXEL_LARANJA
	WORD	   0
	WORD	   COR_PIXEL_LARANJA
	WORD	   0
	WORD       COR_PIXEL_LARANJA

COLUNAS:				; tabela que define as colunas em que os meteoros podem aparecer
	WORD COLUNA_1
	WORD COLUNA_2
	WORD COLUNA_3
	WORD COLUNA_4
	WORD COLUNA_5
	WORD COLUNA_6
	WORD COLUNA_7
	WORD COLUNA_8

LINHAS:					; tabela que define as linhas em que os meteoros mudam de tamanho
	WORD LINHA_METEORO_1
	WORD LINHA_METEORO_2
	WORD LINHA_METEORO_3
	WORD LINHA_METEORO_4
	WORD LINHA_METEORO_5

TECLA_CARREGADA: WORD 0						; tabela que guarda a tecla que está a ser carregada
		
MOV_DOWN: WORD 0							; tabela que guarda 

MOV_UP: WORD 0

PAUSA: WORD 1

DESCE_VIDA: WORD 0

RESTART: WORD 0

POS_BONECO: WORD COLUNA

DISPAROU: WORD 0

VIDA: WORD 0

BTE_START:
	WORD meteoros_interrupt
	WORD tiros_interrupt
	WORD vida_interrupt
	WORD 0

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                    		    ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial_prog_princ	    ; inicializa SP para a palavra a seguir
						                ; à última da pilha
	MOV  BTE,  BTE_START										


	MOV  R3, 0
	MOV  [VIDA], R3
	CALL display

	MOV  R0, 1
	MOV  [PAUSA], R0
    MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 1							; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV  R11, 0

	CALL teclado

menu:
	YIELD
	MOV  R0, TECLA_START
	MOV  R1, [TECLA_CARREGADA]
	CMP  R0, R1
	JNZ  menu
	JMP  start
	
restart:
	MOV  R0, 1
	MOV  [RESTART], R0
	YIELD
	MOV  R0, 0
	MOV  [RESTART], R0
	JMP  start_2

start:
	EI0
	EI1
	EI2
	EI 

	CALL boneco
	;CALL meteoro
	CALL desenha_tiro

start_2:
	
	MOV  R0, 0
	MOV  [PAUSA], R0
	
	MOV  [MOSTRAR_ECRA], R0
	MOV  R0, 1
	MOV  [MOSTRAR_ECRA], R0
	MOV	 R1, 0		
	
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	
	MOV  R3, VIDA_MAX
	MOV  [VIDA], R3
	CALL display                        ; mostra valor atual da vida ao utilizador

main:
	YIELD
	MOV  R1, [TECLA_CARREGADA]
	MOV  R0, TECLA_PAUSAR
	CMP  R0, R1
	JZ   pausa

	MOV  R0, TECLA_TERMINAR
	CMP  R0, R1
	JZ   game_over
	
	MOV  R0, [PAUSA]
	MOV  R1, 1
	CMP  R0, R1
	JZ   pausado

	MOV  R0, [DESCE_VIDA]
	MOV  R1, 1
	CMP  R1, R0
	JZ   desce_vida

	JMP  main

pausado:
	MOV  R1, [TECLA_CARREGADA]
	MOV  R0, TECLA_START
	CMP  R0, R1
	JZ   restart
	JMP  main
	

desce_vida:
	MOV  R3, [VIDA]
	MOV  R0, -5
	CALL adiciona_vida
	MOV  [VIDA], R3
	MOV  R0, 0
	CMP  R0, R3
	JZ   game_over
	CALL display
	MOV  R0, 0
	MOV  [DESCE_VIDA], R0
	JMP  main

pausa:
	MOV  R0, [PAUSA]
	CMP  R0, 0
	JZ   pausar
	MOV  R0, 0
	MOV  [PAUSA], R0
	MOV  [MOSTRAR_ECRA], R0
	MOV  R0, 1
	MOV  [MOSTRAR_ECRA], R0
	MOV  R0, 0
	MOV  [SELECIONA_CENARIO_FUNDO], R0
	JMP  main

pausar:
	MOV  R0, 1
	MOV  [PAUSA], R0
	MOV  R0, 2
	MOV  [SELECIONA_CENARIO_FUNDO], R0
	MOV  R0, 0
	MOV  [ESCONDER_ECRA], R0
	MOV  R0, 1
	MOV  [ESCONDER_ECRA], R0
	MOV  R0, 2
	MOV  [ESCONDER_ECRA], R0
	JMP  main

game_over:
	CALL display
	MOV  R0, 3
	MOV  [SELECIONA_CENARIO_FUNDO], R0
	MOV  R0, 0
	MOV  [ESCONDER_ECRA], R0
	MOV  R0, 1
	MOV  [ESCONDER_ECRA], R0
	MOV  [PAUSA], R0

game_over_loop:
	YIELD

	MOV  R0, [TECLA_CARREGADA]
	MOV  R1, TECLA_START
	CMP  R1, R0
	JZ   restart

	JMP  game_over_loop

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
	MOV  [POS_BONECO], R2
	
	YIELD

	MOV  R0, 0
	MOV  [SELECIONA_ECRA], R0

	MOV  R0, [RESTART]
	MOV  R6, 1
	CMP  R0, R6
	JZ   restart_boneco

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

restart_boneco:
	CALL apaga_boneco
	JMP  boneco

move_esquerda:
	MOV	 R7, -1							; vai deslocar para a esquerda
	CALL testa_limites
	CMP  R7, 0
	JZ   ciclo_boneco

ciclo_atraso:
	YIELD 

	MOV  R0, 0
	MOV  [SELECIONA_ECRA], R0

	MOV  R0, [PAUSA]
	CMP  R0, 1
	JZ   ciclo_atraso

	SUB	 R11, 1               ; decrementa o tempo de atraso
	JNZ	 ciclo_atraso         ; se o tempo de atraso ainda termina, continua

movimento_boneco:
	MOV  R11, ATRASO
	CALL apaga_boneco
	ADD  R2, R7
	CALL desenha_boneco
	JMP ciclo_boneco

PROCESS SP_inicial_meteoro

meteoro:
	MOV  R10, LINHAS
    MOV  R1, [R10]					    ; linha do boneco
	ADD  R10, 2
	SUB  R1, 1

	CALL escolhe_meteoro
	CALL escolhe_coluna

    MOV  R2, R0					; coluna do boneco
	MOV  R3, DEF_METEOROS	
	ADD  R3, R11
	MOV	 R4, [R3]						; endereço da tabela que define o boneco
	MOV	 R8, [R4]
	MOV  R5, NUMERO_METEORITOS_TAM
	SUB  R5, 1
	MOV  R0, 1
	MOV  [SELECIONA_ECRA], R0
	CALL desenha_boneco					; desenha o boneco a partir da tabela

ciclo_meteoro:
	YIELD

	MOV  R0, 1
	MOV  [SELECIONA_ECRA], R0
	
	MOV  R0, [RESTART]
	MOV  R6, 1
	CMP  R0, R6
	JZ   restart_meteoro

	
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

desce_meteoro:
	CALL apaga_boneco                   ; apaga o "meteorito" na posição atual
	ADD  R1, 1                          ; incrementa o valor da posição da linha
	MOV  R0, [R10]
	CMP  R0, R1
	JZ   muda_meteoro
	;CALL verifica_colisao_player	    ; verifica se está a ocorrer uma colisão entre o player e o meteoro
	

acaba_desenho:
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

muda_meteoro:
	CMP  R5, 0
	JZ   acaba_desenho
	SUB  R5, 1
	ADD  R10, 2
	ADD  R3, 2
	MOV  R4, [R3]
	MOV  R8, [R4]
	JMP  acaba_desenho
	
restart_meteoro:
	CALL apaga_boneco
	JMP  meteoro

sair_meteoro:
	YIELD
	JMP  meteoro

PROCESS SP_desenha_tiro

desenha_tiro:
	MOV  R0, 0
	MOV  [DISPAROU], R0					; inicializar booleano a 0, a indicar que ainda não foi disparado um tiro
	MOV  R4, DEF_TIRO					; tabela que define o boneco
	MOV  R8, ALTURA_TIRO
	MOV  R5, LARGURA_QUADRADO
	MOV  R1, LINHA						; inicializar linha inicial do tiro
	SUB  R1, 4							; (4 linhas acima da do player)
	MOV  R2, [POS_BONECO] 				; o tiro deve ser gerado na coluna atual do player
	ADD  R2, 2							; centralizar tiro com o player(que tem 5 pixeis)
	
	MOV  R0, 2							; seleciona ecrã no qual o tiro vai ser desenhado
	MOV  [SELECIONA_ECRA], R0
	
ciclo_tiro:
	YIELD

	MOV  R0, [RESTART]
	MOV  R6, 1
	CMP  R0, R6
	JZ   restart_tiro

	MOV  R0, 2
	MOV  [SELECIONA_ECRA], R0

	MOV  R0, [PAUSA]
	CMP  R0, 1
	JZ   ciclo_tiro

	MOV  R0, TECLA_DISPARAR
	MOV  R6, [TECLA_CARREGADA]
	CMP  R6, R0
	JZ   disparou
	JMP  ciclo_tiro_2

ciclo_tiro_vida:
	MOV  R2, [POS_BONECO]
	ADD  R2, 2
	MOV  R0, 1
	MOV  [DISPAROU], R0
	MOV  R0, -5
	MOV  R3, [VIDA]
	CALL adiciona_vida
	MOV  [VIDA], R3


ciclo_tiro_2:
	MOV  R0, LINHA_METEORO_5
	CMP  R1, R0
	JZ   restart_tiro
	
	MOV  R0, [DISPAROU]
	CMP  R0, 0
	JZ   ciclo_tiro

sobe_tiro:	
	MOV  R0, [MOV_UP]
	CMP  R0, 0
	JZ   ciclo_tiro
	CALL apaga_boneco
	SUB  R1, 1
	CALL desenha_boneco
	MOV R0, 0
	MOV [MOV_UP], R0
	JMP ciclo_tiro

disparou:
	MOV  R0, 0
	MOV  R6, [DISPAROU]
	CMP  R0, R6
	JZ   ciclo_tiro_vida
	JMP  ciclo_tiro_2

restart_tiro:
	CALL apaga_boneco
	JMP  desenha_tiro


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
	MOV  R7, R8             ; número de linhas a tratar
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
; VERIFICA_COLISAO_PLAYER - Verifica colisões entre player e meteoros.
; Argumentos:   R1 - linha do meteoro
;               R2 - coluna do meteoro
;
; **********************************************************************
verifica_colisao_player:
	PUSH R0
	MOV R0, LINHA
	CMP R1, R0				; verificar se o meteoro se encontra na mesma linha que o player
	JNZ verifica_sair
	MOV R0, [POS_BONECO]
	CMP R2, R0
	JNZ verifica_sair

meteoro_bom_ou_mau:
	MOV R0, 10
	CMP R11, R0
	JGE meteoro_bom_colisao

meteoro_mau_colisao:
	MOV R0, 0
	MOV [VIDA], R0			; se for meteoro mau, tirar toda a vida, pra dar gameover
	JMP verifica_sair

meteoro_bom_colisao:
	MOV R0, +5	
	CALL adiciona_vida

	MOV  R4, DEF_EXPLOSAO					; tabela que define o desenho da explosão
	MOV  R8, LARGURA
	MOV R5, R8
	MOV R6, R8

	CALL apaga_boneco

verifica_sair:
	POP R0
	RET


; **********************************************************************
; VERIFICA_COLISAO_TIRO - Verifica colisões entre meteoro e tiro.
; Argumentos:   R1 - linha do meteoro
;               R2 - coluna do meteoro
;
; **********************************************************************
;verifica_colisao_player:
;	PUSH R0
;	MOV R0, LINHA
;	CMP R1, R0				; verificar se o meteoro se encontra na mesma linha que o player
;	JNZ verifica_sair
;	MOV R0, [POS_BONECO]
;	CMP R2, R0
;	JNZ verifica_sair
;
;explosao:
;	MOV  R4, DEF_EXPLOSAO					; tabela que define o desenho da explosão
;	MOV  R8, LARGURA
;	MOV R5, R8
;	MOV R6, R8
;	CALL e
;	CALL atraso
;	CALL apanha_boneco
;
;verifica_sair:
;	POP R0
;	RET

	


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
	MOV R6, 0						; inicializar a 0 o valor em decimal - output
	MOV R5, 10H						; valor da divisão entre duas casas hexadecimais seguidas
	MOV R4, 0AH						; valor da divisão entre duas casas decimais seguidas
								
	MOV R7, 16H						; razão da progressão geométrica ainda agora descrita
	JMP converte_loop

letra_detetada:
	MOV R7, 1						; se a letra for detetada, alterar o devido booleano para 1(True)
	JMP retirar_letras_loop_2

converte_loop:
	MOV R0, R3						; adicionar mais um registo com o valor do input
									; para computar em separado:
	MOD R0, R5						; o último dígito do input
	DIV R3, R5						; os restantes dígitos do input

	MOV R1, R0						; adicionar mais um registo com o valor do último dígito do input
	MOD R1, R4						; ultimo digito do [ultimo digito do input] em decimal
	DIV R0, R4						; primeiro dígito do [último digíto do input] em decimal
									; Ex.: último dígito = C,
									; logo último digito do [ultimo digito do input] em decimal = 12%10 = 2
	
	MUL R0, R5


	ADD R6, R1						; adicionar as duas computações parciais ao output
	ADD R6, R0

	CMP R3, 0						; já não há casas hexadecimais a serem computadas?
	JZ retirar_letras

converte_segunda_passagem:
	MOV R1, 2
	MOV R2, 5

	MOV R0, R3
	DIV R0, R1 
	ADD R0, R3
	MUL R0, R5
	ADD R0, R3
	MOD R3, R1 
	MUL R3, R2
	ADD R0, R3

	ADD R6, R0						; adicionar a última computação parciais ao output

retirar_letras:						; a computação anterior deixa algumas letras no output por retirar (onde por exemplo "1C" = 10 + 12 = 22)
	MOV R3, R6						; colocar output anterior no R3 como no início da rotina
	MOV R6, 0						; inicializar a 0 o novo output
	MOV R2, 1						; inicializar valor pelo qual a computação duma certa casa hexadecimal
	MOV R7, 0						; booleano para verificar se ainda foram detetadas letras

retirar_letras_loop:
	MOV R0, R3						; adicionar mais um registo com o valor do input
									; para computar em separado:
	MOD R0, R5						; o último digito do input
	DIV R3, R5						; os restantes dígitos do input

	MOV R1, R0						; adicionar mais um registo com o valor do último dígito do input
	MOD R1, R4						; ultimo digito do [ultimo digito do input] em decimal
	DIV R0, R4						; primeiro dígito do [último digíto do input] em decimal
									; Ex.: último dígito = C,
									; logo último digito do [ultimo digito do input] em decimal = 12%10 = 2
	MUL R0, R5

	CMP R0, 0						; um dígito hex em dec, só tem primeiro dígito == 1, se for letra. Ex.: CH = 12, enquanto que 9H = 09 
	JNZ letra_detetada				; se letra detetada, alterar booleano

retirar_letras_loop_2:
	MUL R0, R2						; multiplicar computação pelo valor de uma unidade na casa hexadecimal em questão, em decimal
	MUL R1, R2

	ADD R6, R1						; adicionar as duas computações parciais ao output
	ADD R6, R0
	
	MUL R2, R5
	CMP R3, 0						; já não há casas hexadecimais a serem computadas?
	JNZ retirar_letras_loop			; se não, continuar loop
	

converte_saida:
	MOV R3, R6						; colocar valor do output no registo certo
	CMP R7, 0						; houve alguma letra retirada ao output nesta iteração do retirar_letras?
	JNZ retirar_letras				; se sim, reiniciar loop
	POP R7
	POP R6
	POP R5
	POP R4
	POP R0
	POP R2
	POP R1
	RET

adiciona_vida:
	ADD  R3, R0
	MOV  R0, 0
	CMP  R0, R3
	JGE  vida_zero

	MOV  R0, 100
	CMP  R3, R0
	JGE  vida_cem

	JMP  sair_vida

vida_zero:
	MOV  R3, 0
	JMP  sair_vida

vida_cem:
	MOV  R3, 100

sair_vida:
	CALL display
	RET

; **********************************************************************
; DISPLAY - mostra o valor da grandeza "vida" ao utilizador

; Argumentos:   R3 - vida atual
;
; **********************************************************************
display:
	PUSH R0 
	PUSH R1
	PUSH R2
	PUSH R4
	MOV  R1, TEC_LIN   				; endereço do periférico das linhas
    MOV  R2, TEC_COL   				; endereço do periférico das colunas
    MOV  R4, DISPLAYS  				; endereço do periférico dos displays
	MOV  R0, R3
	CALL converte_hex_dec
	MOV  [R4], R3       			; escreve a vida atual nos displays
	MOV  R3, R0
	POP	 R4
	POP	 R2
	POP  R1
	POP  R0
	RET


numero_aleatorio:
	PUSH R1

	MOV  R1, TEC_COL
	MOV  R0, [R1]
	SHR  R0, 13

	POP  R1
	RET

escolhe_meteoro:
	PUSH R1

	CALL numero_aleatorio
	MOV  R1, 6
	CMP  R0, R1
	JGE  meteoro_bom
	MOV  R11, 10
	JMP  sai_meteoro_aleatorio

meteoro_bom:
	MOV  R11, 0

sai_meteoro_aleatorio:
	POP  R1
	RET

escolhe_coluna:
	PUSH R1

	CALL numero_aleatorio
	MOV  R1, 2
	MUL  R0, R1
	MOV  R1, COLUNAS
	ADD  R1, R0
	MOV  R0, [R1]
	

	POP  R1
	RET


; Interrupts

meteoros_interrupt:
	PUSH R0
	PUSH R1

	MOV  R0, [PAUSA]
	MOV  R1, 1
	CMP  R0, R1
	JZ  meteoros_int_saida

	MOV  R0, 1
	MOV  [MOV_DOWN], R0

meteoros_int_saida:
	POP  R1
	POP  R0
	RFE

tiros_interrupt:
	PUSH R0
	PUSH R1

	MOV  R0, [PAUSA]
	MOV  R1, 1
	CMP  R0, R1
	JZ  tiros_int_saida

	MOV  R0, 1
	MOV  [MOV_UP], R0

tiros_int_saida:
	POP  R1
	POP  R0
	RFE

vida_interrupt:
	PUSH R0
	PUSH R1

	MOV  R0, [PAUSA]
	MOV  R1, 1
	CMP  R0, R1
	JZ  vida_saida

	MOV  R0, 1
	MOV  [DESCE_VIDA], R0

vida_saida:
	POP  R1
	POP  R0
	RFE