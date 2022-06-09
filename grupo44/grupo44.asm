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
TECLA_ESQUERDA			 EQU 11H	      ; tecla na primeira coluna do teclado (tecla 0)
TECLA_DIREITA		     EQU 14H	      ; tecla na terceira coluna do teclado (tecla 2)
TECLA_MENOS			     EQU 24H		  ; tecla na terceira coluna do teclado (tecla 6)
TECLA_MAIS			     EQU 28H          ; tecla na quarta coluna do teclado (tecla 7)
TECLA_DESCER		     EQU 81H          ; tecla na primeira coluna do teclado (tecla C)
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
COLUNA_POK_1			 EQU 6            ; coluna do "meteorito"
COLUNA_POK_2			 EQU 22
COLUNA_POK_3			 EQU 38
COLUNA_POK_4			 EQU 54

MIN_COLUNA				 EQU 0		      ; número da coluna mais à esquerda que o objeto pode ocupar
MAX_COLUNA				 EQU 63           ; número da coluna mais à direita que o objeto pode ocupar
ATRASO			 		 EQU 07FFFH		  ; atraso para limitar a velocidade de movimento do boneco

LARGURA					 EQU 5 			  ; largura do boneco
COR_PIXEL_VERMELHO		 EQU 0FF00H		  ; cor do pixel: vermelho em ARGB (opaco e vermelho no máximo, verde e azul a 0)
COR_PIXEL_AMARELO   	 EQU 0FFD3H       ; cor do pixel: amarelo em ARGB (com opacidade máxima)
COR_PIXEL_PRETO     	 EQU 0F000H       ; cor do pixel: preto em ARGB (com opacidade máxima)
COR_PIXEL_CINZENTO  	 EQU 0F79CH       ; cor do pixel: cinzento em ARGB (com opacidade máxima)
COR_PIXEL_BRANCO		 EQU 0FFFFH       ; cor do pixel: branco em ARGB (com opacidade máxima)

VIDA    				 EQU 50H		  ; valor inicial da grandeza "vida", que aparece no display

; *********************************************************************************
; * Dados 
; *********************************************************************************
	PLACE       1000H

	STACK 100H
SP_inicial_prog_princ:

	STACK 100H


tab:
	WORD meteoros_int
	WORD missil_int
	WORD energia_int
							
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

coluna_meteoro:
	WORD

; *********************************************************************************
; * Código
; *********************************************************************************
PLACE   0                    		    ; o código tem de começar em 0000H
inicio:
	MOV  SP, SP_inicial	_prog_princ	            ; inicializa SP para a palavra a seguir
						                ; à última da pilha
                            
    MOV  [APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado (o valor de R1 não é relevante)
    MOV  [APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados (o valor de R1 não é relevante)
	MOV	 R1, 0							; cenário de fundo número 0
    MOV  [SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV	 R7, 1							; valor a somar à coluna do boneco, para o movimentar
	MOV  R3, VIDA                       ; coloca ao valor da vida para posterior amostra no display
	MOV  R5, LINHA_POK                  ; coloca ao valor da linha do "meteorito"
	MOV  R11, ATRASO					; valor que visa empatar os processos
	CALL display                        ; mostra valor atual da vida ao utilizador

	EI0
	EI1
	EI2
	EI
     
posição_pokebola:
    MOV  R1, LINHA_POK					; linha do boneco
    MOV  R2, COLUNA_POK					; coluna do boneco
	MOV	 R4, DEF_POKEBOLA				; endereço da tabela que define o boneco

mostra_pokebola:
	CALL desenha_boneco					; desenha o boneco a partir da tabela

posição_boneco:
    MOV  R1, LINHA						; linha do boneco
    MOV  R2, COLUNA						; coluna do boneco
	MOV	 R4, DEF_BONECO					; endereço da tabela que define o boneco

mostra_boneco:
	CALL desenha_boneco					; desenha o boneco a partir da tabela

linha_original:
	MOV  R6, LINHA_TECLADO       		; linha a testar no teclado

loop:				        			; neste ciclo espera-se até uma tecla ser premida
	CALL teclado_entrada				; leitura às teclas
	CMP	 R0, 0                          ; verificar se há alguma tecla premida
	JZ   linha_original		   	        ; espera, enquanto não houver tecla
	SHL  R6, 4			                ; coloca linha no nibble high
    OR   R6, R0				            ; junta coluna (nibble low)
	MOV  R0, TECLA_ESQUERDA             ; valor da tecla esquerda
	CMP	 R6, R0                         ; verificar se a tecla premida é a tecla esquerda
	JNZ	 testa_direita                  ; verificar se a tecla premida visa um movimento do boneco para a direita
	MOV	 R7, -1							; vai deslocar para a esquerda
	JMP	 ve_limites                     ; testar se o boneco está no limite do ecrã
testa_direita:
	MOV	 R0, TECLA_DIREITA              ; valor da tecla direita
	CMP  R6, R0                         ; verificar se a tecla premida é a tecla direita
	JNZ	 outras_teclas					; analizar outras teclas
	MOV	 R7, +1							; vai deslocar para a direita
	
ve_limites:
	MOV	 R6, [R4]						; obtém a largura do boneco
	CALL testa_limites					; vê se chegou aos limites do ecrã e se sim força R7 a 0
	CMP	 R7, 0                          ; verifica se o boneco está parado
	JZ	 linha_original					; se não, é suposto movimentar o boneco e ler o teclado de novo

move_boneco:
	CALL atraso                         ; empatar os processos por um intervalo de tempo significativo
	CALL apaga_boneco					; apaga o boneco na sua posição corrente
	
coluna_seguinte:
	ADD	 R2, R7							; para desenhar objeto na coluna seguinte (direita ou esquerda)

	JMP	 mostra_boneco					; vai desenhar o boneco de novo

outras_teclas:
	MOV  R0, TECLA_MENOS                ; valor da tecla menos
	CMP  R6, R0                         ; verificar se a tecla premida é a tecla menos
	JZ   diminui_vida                   ; se sim, diminuir vida
	MOV  R0, TECLA_MAIS                 ; valor da tecla mais
	CMP  R6, R0                         ; verificar se a tecla premida é a tecla mais
	JZ   aumenta_vida                   ; se sim, aumentar vida
	MOV  R0, TECLA_DESCER               ; valor da tecla descer
	CMP  R6, R0                         ; verificar se a tecla premida é a tecla descer
	JZ   desce_pok                      ; se sim, descer o "meteorito"
	JMP  linha_original                 ; se não, é suposto ler o teclado de novo

diminui_vida:
	SUB  R3, 1                          ; diminuir o valor da vida por 1
	CALL display                        ; alterar valor da vida mostrado no display
	JMP  espera_nao_tecla               ; esperar que uma tecla não esteja a ser premida

aumenta_vida:
	ADD  R3, 1                          ; aumentar o valor da vida por 1
	CALL display                        ; alterar valor da vida mostrado no display
	JMP  espera_nao_tecla               ; esperar que uma tecla não esteja a ser premida

desce_pok:
	MOV  R0, R2                         ; coloca o valor da coluna do boneco noutro registo temporariamente
	MOV  R2, COLUNA_POK                 ; atribui o valor da coluna do "meteorito", que é constante
	MOV  R1, R5                         ; atribui o valor da linha atual do "meteorito" ao registo
	MOV  R4, DEF_POKEBOLA               ; tabela do "meteorito"
	CALL apaga_boneco                   ; apaga o "meteorito" na posição atual
	ADD  R1, 1                          ; incrementa o valor da posição da linha
	CALL desenha_boneco                 ; desenha o "meteorito" na nova posição
	MOV  R5, R1                         ; atualiza o valor da linha do "meteorito" 
	MOV  R2, R0                         ; devolve o valor da coluna do boneco ao registo original
	MOV  R1, LINHA                      ; devolve o valor da linha do boneco ao registo original
	MOV  R4, DEF_BONECO                 ; devolve a tabela do boneco ao registo original
	MOV  R0, 0                          ; som atual
	MOV  [REPRODUZ_SOM], R0             ; reproduz o som atual
	JMP  espera_nao_tecla               ; esperar que uma tecla não esteja a ser premida

espera_nao_tecla:
	CALL teclado_entrada	            ; leitura às teclas
	CMP  R0, 0                          ; verificar se há alguma tecla premida
	JNZ  espera_nao_tecla               ; se ainda estiver a ser premida alguma tecla continua a esperar
	JMP  linha_original                 ; se já não houver tecla premida, volta a ler o teclado

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
;				R7 - numero de linhas
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
	MOV  R7, R6             ; número de linhas a tratar
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
	MOV  R7, R6             ; número de linhas a tratar
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
; ATRASO - Executa um ciclo para implementar um atraso.
; Argumentos:   R11 - valor que define o atraso
;
; **********************************************************************
atraso:
	PUSH R11
ciclo_atraso:
	SUB	 R11, 1               ; decrementa o tempo de atraso
	JNZ	 ciclo_atraso         ; se o tempo de atraso ainda termina, continua
	POP	 R11
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
; TECLADO - Faz uma leitura às teclas do teclado e retorna o valor lido
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
;				
; Retorna: 	R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; **********************************************************************
teclado_entrada:
	PUSH R2
	PUSH R3
	PUSH R5
teclado_loop:
	MOV  R2, TEC_LIN  				; endereço do periférico das linhas
	MOV  R3, TEC_COL   				; endereço do periférico das colunas
	MOV  R5, MASCARA   				; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB [R2], R6      				; escrever no periférico de saída (linhas)
	MOVB R0, [R3]      				; ler do periférico de entrada (colunas)
	AND  R0, R5        				; elimina bits para além dos bits 0-3
	CMP  R0, 0                      ; verifica se há tecla premida na linha atual
	JNZ  teclado_saida              ; se há, sai da rotina
muda_linha:
    SHR  R6, 1                      ; muda para linha acima
    CMP  R6, 0                      ; verifica se todas as linhas foram vistas
    JNZ  teclado_loop               ; se não terminaram as linhas, volta a testar
teclado_saida:
	POP	 R5 
	POP	 R3
	POP	 R2
	RET

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
