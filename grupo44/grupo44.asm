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
SELECIONA_MUSICA         EQU 6048H		  ; comando que seleciona a música específicada
COMEÇAR_MUSICA			 EQU 605CH		  ; comando que faz a música selecionada começar
TERMINA_MUSICA			 EQU 6066H		  ; comando que faz a música selecionada terminar
PAUSA_MUSICA			 EQU 605EH		  ; comando que faz a música selecionada pausar
CONTINUA_MUSICA          EQU 6060H		  ; comando que faz a música selecionda continuar

LINHA        		     EQU 27			  ; linha do boneco
COLUNA					 EQU 30           ; coluna do boneco (a meio do ecrã)

N_METEOROS  			 EQU 4			  ; número de meteoros no ecrã

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

ALCANCE_TIRO			 EQU 15			  ; número da linha máxima que o tiro pode alcançar


MIN_COLUNA				 EQU 0		      ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA				 EQU 63           ; número da coluna mais à direita que o objeto pode ocupar
MAX_LINHA  				 EQU 32			  ; número da linha mais abaixo que o objeto pode ocupar
ATRASO			 		 EQU 10H		  ; atraso para limitar a velocidade de movimento do boneco
ATRASO_METEORO_DEST      EQU 01400H

LARGURA					 EQU 5 			  ; largura do boneco
LARGURA_MEDIA			 EQU 3			  ; largura dos meteoros de tamanho médio
LARGURA_PEQUENA			 EQU 2            ; largura dos meteoros de tamanho pequeno
LARGURA_QUADRADO		 EQU 1			  ; largura de um quadrado pequeno

COR_PIXEL_VERMELHO		 EQU 0FF00H		  ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_PIXEL_AMARELO   	 EQU 0FFD3H       ; cor do pixel: amarelo escuro em ARGB (com opacidade máxima)
COR_PIXEL_AMARELO_PATO 	 EQU 0FFF0H       ; cor do pixel: amarelo claro em ARGB (com opacidade máxima)
COR_PIXEL_PRETO     	 EQU 0F000H       ; cor do pixel: preto em ARGB (com opacidade máxima)
COR_PIXEL_CINZENTO  	 EQU 0F888H       ; cor do pixel: cinzento em ARGB (com opacidade máxima)
COR_PIXEL_BRANCO		 EQU 0FFFFH       ; cor do pixel: branco em ARGB (com opacidade máxima)
COR_PIXEL_LARANJA        EQU 0FFB6H       ; cor do pixel: laranja em ARGB (com opacidade máxima)
COR_PIXEL_AZUL	         EQU 0F4ABH       ; cor do pixel: azul em ARGB (com opacidade máxima)
COR_PIXEL_PRETO_TRANSP   EQU 0B888H       ; cor do pixel: preto em ARGB (com alguma opacidade)

VIDA_MAX    			 EQU 064H		  ; valor inicial da grandeza "vida", que aparece no display
NUMERO_METEORITOS_TAM    EQU 5			  ; numero de tamanhos que um meteoro pode ter

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

; SP inicial do "main"
	STACK 100H
SP_inicial_prog_princ:

; SP inicial do teclado
	STACK 100H
SP_inicial_teclado:

; SP inicial do boneco
	STACK 100H
SP_inicial_boneco:

; SP inicial do tiro
	STACK 100H
SP_desenha_tiro:

; SP inicial de cada processo "meteoro"
	STACK 100H
SP_inicial_meteoro_1:

	STACK 100H
SP_inicial_meteoro_2:

	STACK 100H
SP_inicial_meteoro_3:

	STACK 100H
SP_inicial_meteoro_4:


meteoros_SP_tab:	    			; tabela com os SP iniciais de cada processo "meteoro"
	WORD	SP_inicial_meteoro_1
	WORD	SP_inicial_meteoro_2
	WORD	SP_inicial_meteoro_3
	WORD	SP_inicial_meteoro_4

DEF_QUADRADO_PEQUENO:				; tabela que define um quadrado pequeno (cor, largura, pixels)
	WORD		LARGURA_QUADRADO
	WORD		COR_PIXEL_PRETO_TRANSP

DEF_QUADRADO:						; tabela que define um quadrado (cor, largura, pixels)
	WORD		LARGURA_PEQUENA
	WORD		COR_PIXEL_PRETO_TRANSP, COR_PIXEL_PRETO_TRANSP
	WORD		COR_PIXEL_PRETO_TRANSP, COR_PIXEL_PRETO_TRANSP

DEF_BONECO:							; tabela que define o boneco (cor, largura, pixels)
	WORD		LARGURA
	WORD		COR_PIXEL_PRETO, 0, 0, 0, COR_PIXEL_PRETO
	WORD		COR_PIXEL_AMARELO, COR_PIXEL_PRETO, COR_PIXEL_AMARELO, COR_PIXEL_PRETO, COR_PIXEL_AMARELO
	WORD		0, COR_PIXEL_VERMELHO, COR_PIXEL_AMARELO, COR_PIXEL_VERMELHO, 0
	WORD		COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO, COR_PIXEL_AMARELO
	WORD		0, COR_PIXEL_AMARELO, 0, COR_PIXEL_AMARELO, 0

DEF_POKEBOLA: 						; tabela que define o meteoro grande (cor, largura, pixels)
	WORD		LARGURA
	WORD		0, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, 0 		
	WORD		COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO
	WORD		COR_PIXEL_PRETO, COR_PIXEL_PRETO, COR_PIXEL_CINZENTO, COR_PIXEL_PRETO, COR_PIXEL_PRETO
	WORD		COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO
	WORD		0, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, 0

DEF_POKEBOLA_MEDIA:					; tabela que define o meteoro médio (cor, largura, pixels)
	WORD	   LARGURA_MEDIA
	WORD 	   COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO
	WORD	   COR_PIXEL_PRETO, COR_PIXEL_CINZENTO, COR_PIXEL_PRETO
	WORD	   COR_PIXEL_BRANCO, COR_PIXEL_BRANCO, COR_PIXEL_BRANCO

DEF_POKEBOLA_PEQUENA:				; tabela que define o meteoro pequeno (cor, largura, pixels)
	WORD	   LARGURA_PEQUENA
	WORD	   COR_PIXEL_VERMELHO, COR_PIXEL_VERMELHO
	WORD	   COR_PIXEL_BRANCO, COR_PIXEL_BRANCO

DEF_PATO:							; tabela que define o meteoro bom grande (cor, largura, pixels)
    WORD	   LARGURA
	WORD	   0, COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO, 0
	WORD       0, COR_PIXEL_AMARELO_PATO, COR_PIXEL_PRETO, COR_PIXEL_AMARELO_PATO, 0
	WORD	   0, COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO, COR_PIXEL_LARANJA, COR_PIXEL_LARANJA
	WORD	   COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO, 0
	WORD       0, COR_PIXEL_AMARELO_PATO, 0, COR_PIXEL_AMARELO_PATO, 0

DEF_PATO_MEDIO:						; tabela que define o meteoro bom médio (cor, largura, pixels)
	WORD       LARGURA_MEDIA
	WORD       COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO, 0
	WORD       COR_PIXEL_AMARELO_PATO, COR_PIXEL_LARANJA, COR_PIXEL_LARANJA
	WORD       COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO, 0

DEF_PATO_PEQUENO:					; tabela que define o meteoro bom pequeno (cor, largura, pixels)
	WORD       LARGURA_PEQUENA
	WORD       COR_PIXEL_AMARELO_PATO, COR_PIXEL_AMARELO_PATO
	WORD       COR_PIXEL_AMARELO_PATO, COR_PIXEL_LARANJA

DEF_EXPLOSAO:						; tabela que define a explosão de um meteoro (cor, largura, pixels)
	WORD		LARGURA
	WORD		0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO, 0 		
	WORD		COR_PIXEL_PRETO, 0, COR_PIXEL_VERMELHO, 0, COR_PIXEL_VERMELHO
	WORD		0, COR_PIXEL_PRETO, 0, COR_PIXEL_VERMELHO, 0
	WORD		COR_PIXEL_BRANCO, 0, COR_PIXEL_BRANCO, 0, COR_PIXEL_PRETO
	WORD		0, COR_PIXEL_BRANCO, 0, COR_PIXEL_BRANCO, 0
	

DEF_METEOROS:						; tabela que define o o tipo e o tamanho dos meteoros
	WORD       DEF_QUADRADO_PEQUENO, DEF_QUADRADO, DEF_PATO_PEQUENO, DEF_PATO_MEDIO, DEF_PATO
	WORD       DEF_QUADRADO_PEQUENO, DEF_QUADRADO, DEF_POKEBOLA_PEQUENA, DEF_POKEBOLA_MEDIA, DEF_POKEBOLA

DEF_TIRO:							; tabela que define o míssil (cor, largura, pixels)
	WORD	   LARGURA_QUADRADO
	WORD	   COR_PIXEL_LARANJA

COLUNAS:							; tabela que define as colunas em que os meteoros podem aparecer
	WORD COLUNA_1
	WORD COLUNA_2
	WORD COLUNA_3
	WORD COLUNA_4
	WORD COLUNA_5
	WORD COLUNA_6
	WORD COLUNA_7
	WORD COLUNA_8

LINHAS:								; tabela que define as linhas em que os meteoros mudam de tamanho
	WORD LINHA_METEORO_1
	WORD LINHA_METEORO_2
	WORD LINHA_METEORO_3
	WORD LINHA_METEORO_4
	WORD LINHA_METEORO_5

TECLA_CARREGADA: WORD 0				; tabela que guarda a tecla que está a ser carregada
		
MOV_DOWN:			    			; tabela que guarda valores que permitem o movimento de cada meteoro de acordo com o "meteoros_interrupt"
	WORD 0							
	WORD 0
	WORD 0
	WORD 0

MOV_UP: WORD 0						; tabela que guarda o valor que permite o movimento do tiro de acordo com o "tiros_interrupt"

PAUSA: WORD 1						; tabela que guarda o valor que permite saber se o jogo está pausado ou não

DESCE_VIDA: WORD 0					; tabela que guarda o valor que permite a descida contínua de vida de acordo com "vida_interrupt"

RESTART: WORD 0						; tabela que guarda o valor que permite saber se o jogo vai ou recomeçar ou não

POS_BONECO: WORD COLUNA 			; tabela que guarda a posição da coluna do boneco

POS_TIRO_COLUNA: WORD COLUNA		; tabela que guarda a posição da coluna a que o tiro é disparado
		
POS_TIRO_LINHA: WORD LINHA			; tabela que guarda a posição da linha do tiro

DISPAROU: WORD 0					; tabela que permite saber se o tiro foi disparado ou não
		
VIDA: WORD 0						; tabela que guarda o valor da vida

METEORO_ATINGIDO: WORD 0			; tabela que permite saber se o meteoro foi atingido, permitindo que o tiro desapareça

BTE_START:							; tabela das rotinas de interrupção
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


	MOV  R3, 0							; inicializa a vida a zero
	MOV  [VIDA], R3						; guarda o valor da vida
	CALL display						; mostra o valor da vida no display

	MOV  R0, 1							; valor que pausa o jogo
	MOV  [PAUSA], R0					; mete o jogo em pausa
    MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 1							; cenário de fundo número 1
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo

	CALL teclado						; começa o processo "teclado"

menu:									; menu inicial
	YIELD		
	MOV  R0, TECLA_START				; endereço da tecla "D"
	MOV  R1, [TECLA_CARREGADA]			; endereço da tecla que está a ser pressionada neste momento
	CMP  R0, R1							; verifica se a tecla "D" foi pressionada
	JNZ  menu							; se não volta ao ciclo do menu
	JMP  start							; se foi começa o jogo
	

start:									; inicializa o jogo (só se passa por aqui uma vez)
	EI0									; interrupção dos meteoros
	EI1									; interrupção do míssil
	EI2									; interrupção da energia
	EI 									; as interrupções são inicializadas

	CALL boneco							; começa o processo "boneco"
	CALL desenha_tiro					; começa o processo "desenha_tiro"

	MOV  R0, N_METEOROS					; número de meteoros que vão ser "chamados"
loop_meteoros:
	SUB  R0, 1							; menos um processo para chamar
	CALL meteoro						; chama o processo meteoro
	CMP  R0, 0							; verifica se já foram chamados todos os meteoros
	JNZ  loop_meteoros					; se não chama outro

start_2:								; inicializa o resto do jogo (passa-se todas as vezes que se dá "restart")

	MOV  R0, 0							; valor que tira o jogo da pausa
	MOV  [PAUSA], R0					; o jogo é despausado
	MOV  [SELECIONA_MUSICA], R0			; a música "0" é selecionada
	MOV  [COMEÇAR_MUSICA], R0			; música de fundo começa
	MOV  R0, 5							; é selecionado o efeito sonoro de "Start"
	MOV  [REPRODUZ_SOM], R0				; "Start" é reproduzido
	
	CALL mostrar_ecras					; são mostrados todos os ecrãs

	MOV	 R1, 0							; ecrã de fundo do jogo
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	
	MOV  R3, VIDA_MAX					; inicializa o jogo com a vida máxima
	MOV  [VIDA], R3						; é guardado o valor da vida
	CALL display                        ; mostra valor atual da vida ao utilizador

main:
	YIELD
	MOV  R1, [TECLA_CARREGADA]			; tecla que está a ser pressionada neste momento
	MOV  R0, TECLA_PAUSAR				; tecla que pausa o jogo
	CMP  R0, R1							; verifica se foi carregada
	JZ   pausa							; se sim pausa o jogo

	MOV  R0, TECLA_TERMINAR				; tecla que termina o jogo
	CMP  R0, R1							; verifica se foi carregada
	JZ   game_over						; se sim termina o jogo

	MOV  R0, 0							; valor da vida que faz o jogador perder
	MOV  R1, [VIDA]						; valor atual da vida
	CMP  R1, R0							; verifica se a vida chegou ao zero
	JZ   game_over						; se sim termina o jogo
	
	MOV  R0, [PAUSA]					; valor que determina se o jogo está pausado atualmente
	MOV  R1, 1							; valor do estado "pausado"
	CMP  R0, R1							; verifica se o jogo está pausado
	JZ   pausado						; se sim salta para "pausado"

	MOV  R0, [DESCE_VIDA]				; valor que determina se está no momento de descer a vida
	MOV  R1, 1							; valor do estado "desce_vida"
	CMP  R1, R0							; verifica se está no momento de descer a vida
	JZ   desce_vida						; se sim desce a vida

	JMP  main							; volta ao ciclo "main"

restart:
	MOV  R0, 1							; valor de restart
	MOV  [RESTART], R0					; dá restart
	YIELD			
	MOV  R0, 0							; valor que diz o restart já terminou
	MOV  [RESTART], R0					; termina o restart
	JMP  start_2						; reinicializa os valores

pausado:
	MOV  R1, [TECLA_CARREGADA]			; tecla que está a ser pressionada neste momento
	MOV  R0, TECLA_START				; tecla que começa o jogo, vai ser usada para recomeçar o jogo
	CMP  R0, R1							; verifica se a tecla está a ser carregada
	JZ   restart 						; se sim dá restart
	JMP  main 							; se não volta ao "main"
	
desce_vida:
	MOV  R3, [VIDA]						; valor atual da vida
	MOV  R0, -5							; valor a ser adicionado à vida
	CALL adiciona_vida					; rotina que adiciona R0 a R3
	MOV  [VIDA], R3						; guarda o valor atual da vida
	MOV  R0, 0							; sem vida
	CMP  R0, R3							; verifica se a vida atual é zero
	JZ   game_over						; se sim, termina o jogo
	CALL display						; se não, atualiza o display com a vida atual
	MOV  R0, 0							; valor que diz que não está no momento de descer a vida
	MOV  [DESCE_VIDA], R0				; atualiza
	JMP  main							; volta para o ciclo principal

pausa:
	MOV  R0, [PAUSA]					; verifica se o jogo está na pausa
	CMP  R0, 0							
	JZ   pausar							; se não, pausa
	MOV  R0, 0							; se sim, retira a pausa
	MOV  [PAUSA], R0					
	CALL mostrar_ecras					; mostra todos os ecrãs que foram escondidos
	MOV  [SELECIONA_MUSICA], R0			; seleciona a música de fundo
	MOV  [CONTINUA_MUSICA], R0			; continua a música de fundo
	MOV  [SELECIONA_CENARIO_FUNDO], R0	; seleciona o cenário de fundo "0"
	MOV  R0, 4							; som de pausa
	MOV  [REPRODUZ_SOM], R0				
	JMP  main							; volta para o ciclo principal

pausar:
	MOV  R0, 1							; pausa o jogo
	MOV  [PAUSA], R0					
	MOV  R0, 2							; cenário de fundo da pausa é selecionado
	MOV  [SELECIONA_CENARIO_FUNDO], R0	
	MOV  R0, 0							; seleciona a música de fundo
	MOV  [SELECIONA_MUSICA], R0			
	MOV  [PAUSA_MUSICA], R0				; pausa a música de fundo
	MOV  R0, 4							; reproduz o som de pausa
	MOV  [REPRODUZ_SOM], R0				
	CALL esconder_ecras					; esconde todos os ecrãs
	JMP  main							; volta para o ciclo principal

game_over:
	CALL display						; atualiza o display com a vida atual (pode ou não ser zero)
	MOV  R0, 3							; seleciona o cenário de fundo de "gameover"
	MOV  [SELECIONA_CENARIO_FUNDO], R0	
	CALL esconder_ecras					; esconde os ecrãs
	MOV  [PAUSA], R0					; pausa o jogo
	MOV  R0, 0							; termina música de fundo
	MOV  [TERMINA_MUSICA], R0			
	MOV  R0, 2							; reproduz o som de "gameover"
	MOV  [REPRODUZ_SOM], R0				

game_over_loop:
	YIELD

	MOV  R0, [TECLA_CARREGADA]			; tecla que está a ser pressionada atualmente
	MOV  R1, TECLA_START				; se for a tecla "start" recomeça o jogo
	CMP  R1, R0							
	JZ   restart						

	JMP  game_over_loop					; se não, volta para o mesmo ciclo

; **********************************************************************
; TECLADO - Faz uma leitura às teclas do teclado e retorna o valor lido
;				
; **********************************************************************

PROCESS SP_inicial_teclado
teclado:
	MOV  R2, TEC_LIN  					; endereço do periférico das linhas
	MOV  R3, TEC_COL   					; endereço do periférico das colunas
	MOV  R5, MASCARA   					; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOV  R6, LINHA_TECLADO       		; linha a testar no teclado
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
	
	MOV  R0, 0							; se não houver tecla carregada colocar 0 na variável
	MOV  [TECLA_CARREGADA], R0			
	JMP  linha_original					

testa_teclas:
	MOV  R7, R6							 
	SHL  R6, 4			             	; coloca linha no nibble high
    OR   R6, R0				         	; junta coluna (nibble low)
	MOV  [TECLA_CARREGADA], R6			 

	MOV  R0, TECLA_ESQUERDA				; verifica se a tecla esquerda tá a ser carregada
	CMP  R6, R0							 
	JZ   linha_original					 
	MOV  R0, TECLA_DIREITA				; verifica se a tecla direita tá a ser carregada
	CMP  R6, R0							 
	JZ   linha_original					 

espera_nao_tecla:
	YIELD

	MOV  R6, R7							
	MOV  R0, 0							
	MOV  [TECLA_CARREGADA], R0			

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
	MOV	 R8, [R4]						; largura do boneco
	MOV  R7, 0							 
	MOV  R11, ATRASO					; número utilizado para manter boneco parado caso jogo esteja parado
	CALL desenha_boneco					; desenha o boneco a partir da tabela

ciclo_boneco:
	MOV  [POS_BONECO], R2				; atualizar valor da coluna do boneco
	
	YIELD

	MOV  R0, 0							; selecionar o ecrã onde vai ser desenhado o boneco
	MOV  [SELECIONA_ECRA], R0			

	MOV  R0, [RESTART]					; ver se player deu restart
	MOV  R6, 1							
	CMP  R0, R6							; se sim,
	JZ   restart_boneco					; executar rotina de restart no boneco

	MOV  R0, [PAUSA]					; ver se player pausou o jogo
	CMP  R0, 1							; se sim
	JZ   ciclo_boneco					; prender processo num ciclo até despausarem o jogo

	MOV  R3, [TECLA_CARREGADA]			
	MOV  R0, TECLA_ESQUERDA				
	CMP  R3, R0							; tecla_esquerda foi premida?
	JZ   move_esquerda					; se sim, tentar mover jogador para a esquerda
	MOV  R0, TECLA_DIREITA				; tecla_direita foi premida?
	CMP  R3, R0							; se sim, tentar mover jogador para a direita
	JNZ ciclo_boneco					; continuar ciclo

move_direita:
	MOV	 R7, +1							; vai deslocar para a direita
	CALL testa_limites					; verifica se boneco se encontra no limite do ecrã
	CMP  R7, 0							
	JNZ  ciclo_atraso					
	JMP  ciclo_boneco					

restart_boneco:							; se jogo foi restarted
	CALL apaga_boneco					; apagar player
	JMP  boneco							; reiniciar processo (tal como no início do jogo)

move_esquerda:
	MOV	 R7, -1							; vai deslocar para a esquerda
	CALL testa_limites					; verifica se boneco se encontra no limite do ecrã
	CMP  R7, 0							 
	JZ   ciclo_boneco					

ciclo_atraso:
	YIELD 

	MOV  R0, 0							; seleciona o ecrã no qual o boneco vai ser desenhado
	MOV  [SELECIONA_ECRA], R0			

	MOV  R0, [PAUSA]					; verifica se o jogo está em pausa
	CMP  R0, 1							
	JZ   ciclo_atraso					; se sim, manter o boneco parado (em ciclo de atraso)

	SUB	 R11, 1               			; decrementa o tempo de atraso
	JNZ	 ciclo_atraso         			; se o tempo de atraso ainda não terminou, continua o loop

movimento_boneco:
	MOV  R11, ATRASO					; reseta o atraso
	CALL apaga_boneco					
	ADD  R2, R7							; altera valor da coluna baseado no deslocamento guardado
	CALL desenha_boneco					
	JMP ciclo_boneco					

; **********************************************************************
; METEORO - Processo do meteoro.
;				
; **********************************************************************
PROCESS SP_inicial_meteoro_1

meteoro:
	MOV  R7, R0							; número do meteoro (sendo que há 4 meteoros)
	SHL  R7, 1
	MOV  R0, meteoros_SP_tab			; tabela com os SP iniciais de cada processo "meteoro"
	MOV  SP, [R0 + R7]					; ir para o início do processo do meteoro a computar

meteoro_inicio:

	MOV  R10, LINHAS					; tabela com valor das linhas de todos os meteoros
    MOV  R1, [R10]					    ; linha do meteoro
	ADD  R10, 2							; andar uma posição para a frente na tabela LINHAS
	SUB  R1, 1							; descer o meteoro uma linha

	CALL escolhe_meteoro				; escolhe (pseudo-aleatoriamente) se o meteoro vai ser bom ou mau
	CALL escolhe_coluna					; escolhe (pseudo-aleatoriamente) a coluna onde o meteoro vai surgir

    MOV  R2, R0							; coluna do boneco
	MOV  R3, DEF_METEOROS				; tabela que contém tabelas dos meteoros todos
	ADD  R3, R11						; escolher entre meteoro bom ou mau, segundo escolhe_meteoro
	MOV	 R4, [R3]						; endereço da tabela que define o meteoro
	MOV	 R8, [R4]						; largura do meteoro
	MOV  R5, NUMERO_METEORITOS_TAM		; numero de tamanhos que um meteoro pode ter
	SUB  R5, 1
	MOV  R0, R7							; número do meteoro
	MOV  R6, 2							;
	DIV  R0, R6							; 
	ADD  R0, R6							; 
	MOV  [SELECIONA_ECRA], R0			; escolher o ecrã do meteoro a ser computado
	CALL desenha_boneco					; desenha o boneco a partir da tabela

ciclo_meteoro:
	YIELD

	MOV  R0, R7							; número do meteoro
	MOV  R6, 2							;
	DIV  R0, R6							;
	ADD  R0, R6							;
	MOV  [SELECIONA_ECRA], R0			; escolher o ecrã do meteoro
	
	MOV  R0, [RESTART]					; verificar se o player deu restart
	MOV  R6, 1							;
	CMP  R0, R6							;
	JZ   restart_meteoro				; se sim, dar restart ao meteoro

	MOV  R0, [PAUSA]					; verificar se o player meteu o jogo em pausa
	CMP  R0, 1							;
	JZ   ciclo_meteoro					; se sim, manter o processo do meteoro preso num loop até despausarem o jogo

	CALL verifica_colisao_player	    ; verifica se está a ocorrer uma colisão entre o player e o meteoro
	CMP  R0, 0							; 
	JZ   restart_meteoro				; se sim, dar restart ao meteoro
	CALL verifica_colisao_tiro			; verifica se está a ocorrer uma colisão entre o tiro e o meteoro
	CMP  R0, 0							;
	JZ   meteoro_destruido				; se sim, destruir meteoro
	
	MOV  R0, MOV_DOWN					; 
	ADD  R0, R7							; valor booleano que diz se o relogio_meteoro já deu tempo para o meteoro descer de novo
	MOV  R6, [R0]						;
	MOV  R0, 0							;
	CMP  R6, R0							; se não, voltar ao início do processo, deixando o meteoro no seu sítio
	JZ   ciclo_meteoro					;

	MOV  R0, MAX_LINHA					; verificar se meteoro já passou o ecrã(por baixo) 
	SUB  R0, R8							;
	CMP  R1, R0							;
	JZ   acaba_meteoro					; se sim, apagar meteoro e criar um meteoro novo, de seguida

desce_meteoro:
	CALL apaga_boneco                   ; apaga o meteoro na posição atual
	ADD  R1, 1                          ; atualiza o valor da posição da linha
	MOV  R0, [R10]						; 
	CMP  R0, R1							; se meteoro estiver na linha de transição entre meteoros de tamanhos diferentes
	JZ   muda_meteoro					; muda para meteoro com maior dimensão

acaba_desenho:
	CALL desenha_boneco                 ; desenha o "meteorito" na nova posição
	MOV  R0, MOV_DOWN					; endereço da tabela dos booleanos do relógio
	ADD  R0, R7							 
	MOV  R6, 0                      	
	MOV  [R0], R6						; linha do meteoro passa a ser 0, para reiniciar movimento do meteoro no topo do ecrã
	JMP  ciclo_meteoro                  ; esperar que uma tecla não esteja a ser premida

acaba_meteoro:
	CALL apaga_boneco                   ; apaga o "meteorito" na posição atual
	SUB  R8, 1							;
	JZ   sair_meteoro					;
	ADD  R1, 1                          ; incrementa o valor da posição da linha
	CALL desenha_boneco                 ; desenha o "meteorito" na nova posição
	MOV  R0, MOV_DOWN					; endereço da tabela dos booleanos do relógio do meteoro
	ADD  R0, R7							; booleano do relógio do meteoro, para este específico meteoro
	MOV  R6, 0                      	;
	MOV  [R0], R6						; linha do meteoro passa a ser 0, para reiniciar movimento do meteoro no topo do ecrã
	JMP  ciclo_meteoro					;

meteoro_destruido:
	MOV  R0, R7							; número do meteoro a ser computado
	MOV  R6, 2							;
	DIV  R0, R6							;
	ADD  R0, R6							;
	MOV  [SELECIONA_ECRA], R0			; selecionar ecrã do meteoro
	CALL apaga_boneco					; 
	MOV  R4, DEF_EXPLOSAO			    ; tabela que define desenho da explosão
	CALL desenha_boneco					; desenha explosão
	MOV  R6, ATRASO_METEORO_DEST		; fica com a explosão desenhada um tempo antes de apagar esse desenho

meteoro_destruido_ciclo:
	YIELD
	MOV  [SELECIONA_ECRA], R0			; selecionar ecrã do meteoro
	SUB  R6, 1							; 
	JZ   restart_meteoro				; quando acabar este atraso dar restar ao meteoro
	JMP  meteoro_destruido_ciclo		; continuar neste ciclo de atraso para o desenho da explosão ficar algum tempo no ecrã

muda_meteoro:
	CMP  R5, 0							; 
	JZ   acaba_desenho					;
	SUB  R5, 1							;
	ADD  R10, 2							; anda uma posição para a frente na tabela das LINHAS
	ADD  R3, 2							; anda uma posição para a frente na tabela dos meteoros
	MOV  R4, [R3]						; tabela do meteoro novo
	MOV  R8, [R4]						; largura do meteoro novo
	JMP  acaba_desenho					;
	
restart_meteoro:						; se o jogo der restart
	CALL apaga_boneco					; apaga o meteoro
	JMP  meteoro_inicio					; e volta ao início do processo (como no início do jogo)

sair_meteoro:
	YIELD
	JMP  meteoro_inicio					

; **********************************************************************
; TIRO - Processo do tiro.
;				
; **********************************************************************
PROCESS SP_desenha_tiro

desenha_tiro:
	MOV  R0, 0							;
	MOV  [DISPAROU], R0					; inicializar booleano a 0, a indicar que ainda não foi disparado um tiro
	MOV  R4, DEF_TIRO					; tabela que define o boneco
	MOV  R8, LARGURA_QUADRADO			; altura do tiro
	MOV  R5, LARGURA_QUADRADO			; largura do tiro
	MOV  R1, LINHA						; inicializar linha inicial do tiro
	MOV  [POS_TIRO_LINHA], R1			; atualizar linha do tiro (para verificar colisões)
	MOV  R2, [POS_BONECO] 				; o tiro deve ser gerado na coluna atual do player
	ADD  R2, 2							; centralizar tiro com o player(que tem 5 pixeis)
	MOV  R0, [POS_TIRO_COLUNA]			; atualizar coluna do tiro (para verificar colisões)
	
	MOV  R0, 1							; seleciona ecrã no qual o tiro vai ser desenhado
	MOV  [SELECIONA_ECRA], R0			;
	
ciclo_tiro:
	YIELD

	MOV  R0, 1							; seleciona o ecrã onde vai desenhar o tiro
	MOV  [SELECIONA_ECRA], R0			;

	MOV  R0, [RESTART]					; vê se o jogador reiniciou o jogo
	MOV  R6, 1							;
	CMP  R0, R6							;
	JZ   restart_tiro					; se sim, reiniciar o tiro


	MOV  R0, [PAUSA]					; vê se o jogador pausou o jogo
	CMP  R0, 1							;
	JZ   ciclo_tiro						; se sim, manter o tiro parado, mantendo o processo deste em loop até despausar o jogo

	MOV  R0, TECLA_DISPARAR				;
	MOV  R6, [TECLA_CARREGADA]			;
	CMP  R6, R0							; vê se TECLA_DISPARAR está carregada
	JZ   disparou						; se sim, disparar o tiro após verificar se possível
	JMP  ciclo_tiro_2					; verificar só se meteoro foi atingido

ciclo_tiro_vida:
	MOV  R2, [POS_BONECO]				;
	ADD  R2, 2							;
	MOV  [POS_TIRO_COLUNA], R2			; coluna do tiro deve ser a coluna central do player (2 pixeis à direita da coluna esquerda do player)
	MOV  R0, 1							;
	MOV  [DISPAROU], R0					; guardar na variável a informação de que o tiro foi disparado
										; para impedir tiros extra enquanto este existe
	
	MOV  R0, -5							; retirar 5 pontos de vida
	MOV  R3, [VIDA]						; (por ter disparado um tiro)
	CALL adiciona_vida					;
	MOV  [VIDA], R3						;

	MOV  R0, 6							; reproduz som do tiro
	MOV  [REPRODUZ_SOM], R0				;


ciclo_tiro_2:
	MOV  R0, [METEORO_ATINGIDO]			; ver se meteoro foi atingido
	MOV  R6, 1							;
	CMP  R6, R0							;
	JZ   restart_tiro					; se sim, apaga tiro e possibilita que este volte a ser disparado de novo

	MOV  R0, ALCANCE_TIRO				; ver se meteoro chegou ao máximo do seu alcance
	CMP  R1, R0							; 
	JZ   restart_tiro					; se sim, dar restart ao tiro
	
	MOV  R0, [DISPAROU]					; se tiro não foi disparado
	CMP  R0, 0							;
	JZ   ciclo_tiro						; voltar ao início do processo

sobe_tiro:								; se já foi disparado
	MOV  R0, [MOV_UP]					; relógio_tiro deu tempo para este subir?
	CMP  R0, 0							;
	JZ   ciclo_tiro						; se não, manter tiro no sítio
	CALL apaga_boneco					; se sim, sobe tiro por um pixel
	SUB  R1, 1							;
	MOV  [POS_TIRO_LINHA], R1			; atualizar variável da linha do tiro (para depois verificar colisões)
	CALL desenha_boneco					;
	MOV R0, 0							;
	MOV [MOV_UP], R0					; reiniciar booleano que verifica se o relógio_tiro já deu tempo para voltar a subir
	JMP ciclo_tiro						; voltar ao início do processo

disparou:
	MOV  R0, 0							;
	MOV  R6, [DISPAROU]					;
	CMP  R0, R6							; verificar se já foi disparado um tiro (para não haver mais que um tiro)
	JZ   ciclo_tiro_vida				; se não, disparar o tiro
	JMP  ciclo_tiro_2					; se sim, verificar só se meteoro foi atingido

restart_tiro:
	MOV  R0, 0							;
	MOV  [METEORO_ATINGIDO], R0			; reiniciar variável que indica se meteoro foi atingido
	CALL apaga_boneco					; apaga o tiro do ecrã
	JMP  desenha_tiro					; volta ao inicio do processo

; **********************************************************************
; ESCONDER_ECRAS - esconde todos os ecrãs (de 0 a 5)
;
; **********************************************************************
esconder_ecras:
	PUSH R0
	MOV R0, 0							; inicializa o número do ecrã a 0
esconder_ecras_loop:
	MOV [ESCONDER_ECRA], R0				; esconde ecrã selecionado
	ADD R0, 1							; incrementa valor do ecrã para percorrer todos os ints de 0 a 5
	CMP R0, 6							; quando ultrapassa o ecrã 5, sair do loop
	JNZ esconder_ecras_loop				;
esconder_ecras_saida:
	POP R0		
	RET

; **********************************************************************
; MOSTRAR_ECRAS - mostra todos os ecrãs (de 0 a 5)
;
; **********************************************************************
mostrar_ecras:
	PUSH R0
	MOV R0, 0							; inicializa o número do ecrã a 0
mostrar_ecras_loop:
	MOV [MOSTRAR_ECRA], R0				; mostra ecrã selecionado
	ADD R0, 1							; incrementa valor do ecrã para percorrer todos os ints de 0 a 5
	CMP R0, 6							; quando ultrapassa o ecrã 5, sair do loop
	JNZ mostrar_ecras_loop				;
mostrar_ecras_saida:
	POP R0
	RET

; **********************************************************************
; DESENHA_BONECO - Desenha um boneco na linha e coluna indicadas
;			    com a forma e cor definidas na tabela indicada.
; Argumentos:   R0 - coluna inicial
;				R1 - linha
;               R2 - coluna
;				R3 - cor do próximo pixel
;               R4 - tabela que define o boneco
;				R5 - número Fde colunas
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
	MOV  R0, R2             			; coloca valor da coluna num registo temporário
	MOV	 R6, [R4]						; obtém a largura do boneco
	MOV  R5, R6             			; número de colunas a tratar
	MOV  R7, R8             			; número de linhas a tratar
	ADD	 R4, 2							; endereço da cor do 1º pixel (2 porque a largura é uma word)
desenha_pixels:       					; desenha os pixels do boneco a partir da tabela
	MOV	 R3, [R4]						; obtém a cor do próximo pixel do boneco
	CALL escreve_pixel					; escreve cada pixel do boneco
	ADD	 R4, 2							; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1              			; próxima coluna
    SUB  R5, 1							; menos uma coluna para tratar
    JNZ  desenha_pixels     			; continua até percorrer toda a largura do objeto
	MOV  R5, R6             			; reseta o número de colunas a tratar
	MOV  R2, R0             			; reseta a posição da coluna atual
	ADD  R1, 1              			; passa para a linha seguinte
	SUB  R7, 1              			; menos uma linha para tratar
	JNZ  desenha_pixels     			; continua até percorrer toda a altura do objeto
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
	MOV  R0, R2             			; posição inicial da primeira coluna do boneco
	MOV	 R6, [R4]						; obtém a largura do boneco
	MOV  R5, R6             			; número de colunas a tratar
	MOV  R7, R8             			; número de linhas a tratar
	ADD	 R4, 2							; endereço da cor do 1º pixel (2 porque a largura é uma word)
apaga_pixels:       					; desenha os pixels do boneco a partir da tabela
	MOV	 R3, 0							; cor para apagar o próximo pixel do boneco
	CALL escreve_pixel					; escreve cada pixel do boneco
	ADD	 R4, 2							; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
    ADD  R2, 1              			; próxima coluna
    SUB  R5, 1							; menos uma coluna para tratar
    JNZ  apaga_pixels       			; continua até percorrer toda a largura do objeto
	MOV  R5, R6             			; reseta o número de colunas a tratar
	MOV  R2, R0             			; reseta a posição da coluna atual
	ADD  R1, 1              			; passa para a linha seguinte
	SUB  R7, 1              			; menos uma linha para tratar
	JNZ  apaga_pixels       			; continua até percorrer toda a altura do objeto
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
	MOV  [DEFINE_LINHA], R1	  		; seleciona a linha
	MOV  [DEFINE_COLUNA], R2  		; seleciona a coluna
	MOV  [DEFINE_PIXEL], R3	  		; altera a cor do pixel na linha e coluna já selecionadas
	RET


; **********************************************************************
; VERIFICA_COLISAO - Verifica colisões entre player e meteoros.
; Argumentos:   R1 - linha superior do meteoro
;               R2 - coluna mais esquerda do meteoro
;				R11 - indice na tabela dos meteoros(a partir do indice 10 estamos perante um meteoro mau)
;
; **********************************************************************
verifica_colisao_player:
	PUSH R3
	PUSH R5

	MOV  R0, LINHA					; coloca o valor da linha num registo temporário 
	SUB  R0, R1						; subtrai ao R0 o valor da linha do meteoro
	MOV  R3, 0						; atribui o valor 0 ao R3
	CMP  R3, R0						; verifica se o valor da linha é 0 
	JGE  torna_linha_positiva		; se não for 0 então a linha é positiva

verifica_colisao_player_2:
	CMP  R0, LARGURA				; verificar se o meteoro se encontra na mesma linha que o player
	JGE  nao_ha_colisao_player		; se não for a mesma linha então não houve colisão 
	MOV  R0, [POS_BONECO]			; verifica a posição do boneco
	SUB  R0, R2						; subtrai o valor da coluna do meteoro à posição do boneco
	MOV  R3, 0						 
	CMP  R3, R0						; verifica se o valor da linha do meteoro é maior do que 0
	JGE  torna_coluna_positiva		; se não, torna o valor da coluna positivo

verifica_colisao_player_3:
	CMP  R0, LARGURA				; verificar se o meteoro se encontra na mesma linha que o player
	JGE  nao_ha_colisao_player		; se não, então não houve colisão

meteoro_bom_ou_mau:
	MOV R0, 10						; atribui ao R0 o valor 10
	CMP R0, R11						; verifica se o meteoro é bom ou mau comparando o valor de R0 ao indice na tabela dos meteoros 
	JNE meteoro_bom_colisao			; se não for igual então a colisão foi com um meteoro bom

meteoro_mau_colisao:
	MOV R3, 0    					; atribui o valor 0 ao R3
	MOV [VIDA], R3					; se for meteoro mau, tirar toda a vida, pra dar gameover
	CALL display					
	JMP ha_colisao_player		

torna_linha_positiva:
	MOV  R3, -1						; atribuir ao R3 o valor -1
	MUL  R0, R3						; tornar o valor negativo
	JMP  verifica_colisao_player_2

torna_coluna_positiva:
	MOV  R3, -1						; atribuir ao R3 o valor -1
	MUL  R0, R3 					; tornar o valor negativo
	JMP  verifica_colisao_player_3 

meteoro_bom_colisao:
	MOV  R3, [VIDA]					; guardar em R3 o valor da vida
	MOV  R0, +10					; atribuir o valor 10 à um registo temporario 
	CALL adiciona_vida				; aumenta o valor da vida 
	MOV  [VIDA], R3				
	MOV  R0, 3						
	MOV  [REPRODUZ_SOM], R0 		; reproduz o som 3
	JMP  ha_colisao_player			

nao_ha_colisao_player:
	MOV  R0, 1						; o R0 fica com o valor 1
	JMP  verifica_sair_player		; faz um jump para "verifica_sair_player" e sai da rotina "nao_ha_colisao_player"

ha_colisao_player:
	MOV  R0, 0						; o R0 fica a 0

verifica_sair_player:
	POP  R5
	POP  R3
	RET 

verifica_colisao_tiro:
	PUSH R3
	PUSH R5

	MOV  R0, [DISPAROU]				; verifica se tiro foi disparado
	MOV  R3, 0						; R3 passa a guardar o número 0
	CMP  R3, R0						
	MOV  R6, 1						
	JZ   nao_ha_colisao_tiro		; não houve colisão com tiro, se tiro não foi disparado
	MOV  R0, [POS_TIRO_LINHA]		; linha do tiro
	MOV  R3, R1						; linha superior do meteoro
	MOV  R5, [R4]			    	; valor da largura do meteoro (no tamanho em que este se torna atingível por tiro)
	ADD  R3, R5						; linha inferior do meteoro
	CMP  R0, R3						; verificar se píxel superior do tiro está ao nível da linha inferior do meteoro (ou acima desta)
	JGE  nao_ha_colisao_tiro		; se não, não houve colisão com tiro
	
	MOV  R0, [POS_TIRO_COLUNA]		; coluna do tiro
	SUB  R0, R2						; diferença entre coluna do tiro e coluna mais esquerda do meteoro
	MOV  R3, 5						
	CMP  R0, R3						; se a diferença for maior que 4, tiro passou à direita do meteoro -> náo há colisão
	JGE  nao_ha_colisao_tiro		
	MOV  R3, -1						
	CMP  R3, R0				    	; se a diferença é menor que 0, tiro passou à esquerda do meteoro -> não há colisão
	JGE  nao_ha_colisao_tiro		
									; caso contrário, houve explosão
	MOV  R0, 1						
	MOV  [REPRODUZ_SOM], R0			; reproduz o som 1
	MOV  [METEORO_ATINGIDO], R0 	
	MOV  R0, 10						
	CMP  R0, R11					
	JNE  ha_colisao_tiro			; se for meteoro bom, colisão com tiro não altera vida
	MOV  R3, [VIDA]					
	MOV  R0, 5						
	CALL adiciona_vida				; aumenta o valor da vida
	MOV  [VIDA], R3					
	CALL display					; apresenta o valor da vida
	JMP  ha_colisao_tiro			

nao_ha_colisao_tiro:
	MOV  R0, 1						
	JMP  verifica_sair_tiro			

ha_colisao_tiro:
	MOV  R0, 0						

verifica_sair_tiro:
	POP  R5
	POP  R3
	RET 

; **********************************************************************
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

; ***********************************************************************
; CONVERTE_HEX_DEC - converte o valor da vida de hexadecimal para decimal
;
; Argumentos:   R3 - vida atual
;
; ***********************************************************************
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
	ADD  R3, R0						; adiciona ao valor da vida o valor atual de R0
	MOV  R0, 0						; R0 passa a ser 0
	CMP  R0, R3						; se o valor de R3 for menor ou igual ao de R0, então a vida está zerada (0)
	JGE  vida_zero					; 

	MOV  R0, 100					; R0 passa a ser 100
	CMP  R3, R0						; se o valor de R3 for maior ou igual ao de R0, então a vida está cheia (100) 
	JGE  vida_cem					; 

	JMP  sair_vida					

vida_zero:
	MOV  R3, 0						; o registo que guarda o valor da vida, passa a ser 0
	JMP  sair_vida					; 

vida_cem:
	MOV  R3, 100					; o registo que guarda o valor da vida, passa a ser 100

sair_vida:
	CALL display					; 
	RET


; **********************************************************************
; DISPLAY - mostra o valor da grandeza "vida" ao utilizador
;
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
	MOV  R0, R3						; R0 guarda temporariamente o valor da vida 
	CALL converte_hex_dec			; converte o valor da vida de Hexadecimal para decimal 
	MOV  [R4], R3       			; escreve a vida atual nos displays
	MOV  R3, R0						; R3 volta a receber o valor da vida em Hexadecimal
	POP	 R4
	POP	 R2
	POP  R1
	POP  R0
	RET

; **********************************************************************
; NUMERO_ALEATORIO - escolhe um número pseudo-aleatório de 0 a 7
;
;
; **********************************************************************
numero_aleatorio:
	PUSH R1

	MOV  R1, TEC_COL				; faz-se uma leitura do periférico
	MOV  R0, [R1]					
	SHR  R0, 13						; desloca um certo número de bits para a direita

	POP  R1
	RET

; **********************************************************************
; ESCOLHE_METEORO - escolhe se meteoro que vai surgir é bom ou mau
;
;
; **********************************************************************

escolhe_meteoro:
	PUSH R1

	CALL numero_aleatorio			; gerar um número pseudo-aleatório
	MOV  R1, 6						; R1 passa a guardar o valor 6
	CMP  R0, R1						; verifica se o número aleatorio é maior ou igual a 6
	JGE  meteoro_bom				; se sim, então é um meteoro bom
	MOV  R11, 10					; se for escolhido um meteoro mau, escolher um meteoro cujo índice na tabela dos meteoros é superior a 9
	JMP  sai_meteoro_aleatorio		; sai da rotina 

meteoro_bom:
	MOV  R11, 0						; se for escolhido um meteoro mau, escolher um meteoro cujo índice na tabela dos meteoros é inferior a 10

sai_meteoro_aleatorio:
	POP  R1
	RET

escolhe_coluna:
	PUSH R1

	CALL numero_aleatorio			; gerar um número pseudo-aleatório
	MOV  R1, 2						; guarda o valor 2 no registo R1
	MUL  R0, R1						; duplica o número aleatório por 2 
	MOV  R1, COLUNAS				; R1 passa a guardar o valor das colunas 
	ADD  R1, R0						; adiciona o número aleatório ao valor das colunas 
	MOV  R0, [R1]					; 

	POP  R1
	RET

; Interrupts
meteoros_interrupt:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4

	MOV  R4, MOV_DOWN				; endereço da tabela dos booleanos das interrupções
	MOV  R3, N_METEOROS				; número total de meteoros no ecrã
	MOV  R2, 0						; índice 0

	MOV  R0, [PAUSA]				; se jogo estiver em pausa não fazer nada na interrupção
	MOV  R1, 1						;
	CMP  R0, R1						;
	JZ  meteoros_int_saida			;

	MOV  R0, 1						

meteoros_int_loop:
	MOV  [R4 + R2], R0				; reinicar valor booleano da interrupção a 1 para sincronizar ações sensíveis ao tempo com os relógios
	ADD  R2, 2						; segue para o próximo
	SUB  R3, 1						;
	JNZ  meteoros_int_loop			; se já acabaram os meteoros sai

meteoros_int_saida:
	POP  R4
	POP  R3
	POP  R2
	POP  R1
	POP  R0
	RFE

tiros_interrupt:
	PUSH R0
	PUSH R1

	MOV  R0, [PAUSA]				; se jogo estiver em pausa não fazer nada na interrupção
	MOV  R1, 1						;
	CMP  R0, R1						;
	JZ  tiros_int_saida				;

	MOV  R0, 1						; 
	MOV  [MOV_UP], R0				; reinicar valor booleano da interrupção a 1 para sincronizar ações sensíveis ao tempo com os relógios

tiros_int_saida:
	POP  R1
	POP  R0
	RFE

vida_interrupt:
	PUSH R0
	PUSH R1

	MOV  R0, [PAUSA]				; se jogo estiver em pausa não fazer nada na interrupção
	MOV  R1, 1						;
	CMP  R0, R1						;
	JZ  vida_saida					;

	MOV  R0, 1						;
	MOV  [DESCE_VIDA], R0			; reinicar valor booleano da interrupção a 1 para sincronizar ações sensíveis ao tempo com os relógios

vida_saida:
	POP  R1
	POP  R0
	RFE