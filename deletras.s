@;=== Programa para resolver una sopa de letras (adjunta en fichero "sopa.s") ==
@;= Aitor Mendoza Sancho = aitor.mendoza@estudiants.urv.cat
@;= alumne 2 = jordi.vives@estudiants.urv.cat



@;-- .bss. Zero initialized data ---
.bss
	sopa_result:	.space	9		@; números de palabras encontradas
									@; pos.0: palabras no encontradas
									@; pos.1: palabras en orientación 1
									@; pos.2: palabras en orientación 2
									@; etc.



@;-- .text. Program code ---
.text		
		.arm
		.global principal
	@; Función 'principal' -> recorre totes les palabras de la lista, con la
	@; ayuda de la función 'longitud_palabra', e invoca la función 
	@; 'encontar_palabra'para cada casilla de la matriz de la sopa de letras,
	@; hasta que la encuentra una vez y pasa a la siguiente palabra.
	@;	Entrada:
	@;		global sopa_nfil:	número de filas de la matriz
	@;		global sopa_ncol:	número de columnas de la matriz
	@;		global sopa_matriz:	matriz con el contenido de la sopa de letras
	@;		global sopa_palabras:	lista de palabras a encontrar, donde cada
	@;							palabra acaba en punto y la lista acaba con una
	@;							palabra vacía (un solo punto)
	@;	Salida:
	@;		global sopa_matriz: las posiciones de las palabras encontradas se
	@;							cambian de minúsculas a mayúsculas
	@;		sopa_result:	vector con el número de palabras encontradas en
	@;							cada orientación, más el número de palabras
	@;							no encontradas en la primera posición del vector
	@;		R0:				número de palabras analizadas
	principal:
			push {r1-r8, lr}			@; salvar registros y dirección retorno
			ldr r0, =sopa_nfil
			ldrb r1, [r0]				@; R1 = número de filas
			ldr r0, =sopa_ncol
			ldrb r2, [r0]				@; R2 = número de columnas
			ldr r4, =sopa_matriz		@; R4 apunta a inicio de matriz
			ldr r5, =sopa_palabras		@; R5 apunta a inicio de lista palabras
			ldr r6, =sopa_result		@; R6 apunta a inicio de resultados
			mov r7, #0					@; R7 = número de palabras analizadas
		.Lprin_buc:
			mov r0, r5
			bl longitud_palabra			@; calcula longitud de siguiente palabra
			cmp r0, #0					@; verifica que haya palabra
			beq .Lprin_fin				@; si número de letras == 0, final bucle
			mov r8, r0					@; R8 guarda número de letras de palabra
			mov r0, r4
			mov r3, r5					@; preparar parámetros de función
			bl encontrar_palabra
			ldrb r3, [r6, r0]
			add r3, #1					@; incrementar contador resultado
			strb r3, [r6, r0]
			add r5, r8					@; adelantar puntero lista palabras
			add r5, #1					@; saltar el caracter de final palabra
			add r7, #1					@; incrementar contador de palabras
			b .Lprin_buc
		.Lprin_fin:
			mov r0, r4
			bl limpiar_minusculas
			mov r0, r7					@; copiar resultado en reg. de retorno
			
			pop {r1-r8, pc}				@; recuperar registros y retornar




	@; Función 'longitud_palabra' -> calcula el número de letras de la palabra
	@; actual de la lista, hasta que encuentra un carácter punto '.'
	@;	Parámetros:
	@;		R0 : puntero a primera letra de la palabra actual
	@;	Resultado:
	@;		R0 : número de letras de la palabra (puede ser cero)
	longitud_palabra:
		push {r1-r2,lr}			@;salvamos registros
		mov r1, #0				@;r1 sera contador
		.Lcalcula:				
			ldrb r2, [r0,r1]	@;r2=vector(contador)
			add r1, #1			
			cmp r2, #'.'		
			bne .Lcalcula		@;continua bucle si r2!='.'
	
		sub r1, #1				@;restamos el punto
		mov r0, r1				@;r0 retorna longitud
		pop {r1-r2,pc}			@;recuperar registros



	@; Función 'encontrar_palabra' -> busca la palabra actual en todas las
	@; posiciones de la matriz y en todas las orientaciones posibles, hasta que
	@; la encuentra una vez o se acaba la matriz; si encuentra la palabra, se
	@; cambiarán en la matriz las letras minúsculas por mayúsculas.
	@;	Parámetros:
	@;		R0 : dirección base de la matriz
	@;		R1 : número de filas
	@;		R2 : número de columnas
	@;		R3 : puntero a la palabra actual
	@;	Resultado:
	@;		R0 : código de orientación encontrado [1..8], o cero si no encuentra
	encontrar_palabra:
			push {r3-r7,lr}								@;salvamos registros
			mov r4, #0									@;r4=fila
			mov r5, #0									@;r5=columna
			mov r6, r3									@;salvamos r3, r6 auxiliar
			mov r7,r0									@;salvamos r0, r7 auxiliar
			.Lbucle_fila:					
				mov r5, #0								@;reiniciamos columna
				.Lbucle_columna:
					ldrb r3, [r6]						@;r3=palabra[i]
					bl coincidencia
					cmp r0, #0							@;comprobamos coincidencia
					mov r0, r7							@;restauramos r0
					beq .Lsiguiente_letra				@;no coincidencia=siguiente letra
					mov r3,r6							@;restauramos r3
					bl detectar_8_orientaciones	
					cmp r0, #0							@;comprobamos orientacion
					bne .Lfinal_encontrar				@;orientacion!=0, no buscara mas
					mov r0, r7							@;restauramos r0
					.Lsiguiente_letra:
						cmp r5, r2						@;comprobamos columna
						beq .Lultima_columna			@;ultima columna=terminamos
						add r5, #1													
						b .Lbucle_columna				@;sino, siguiente columna y empezamos
					.Lultima_columna:
						cmp r4, r1						@;comprobamos fila
						beq .Lultima_fila				@;ultima fila=terminamos
						add r4, #1	
						b .Lbucle_fila					@;sino, siguiente fila y empezamos
			.Lultima_fila:
				mov r0, #0								@;reiniciamos fila
			.Lfinal_encontrar:
			pop {r3-r7,pc}								@;restauramos registros
			

	@; Función 'detectar_8_orientaciones' -> dada una coincidencia de la primera
	@; letra de una palabra con una posición de la matriz, buscar la continua-
	@; ción de la coincidencia del resto de las letras en las 8 posibles
	@; orientaciones y, en caso de coincidencia completa, cambiar las minúsculas
	@; por mayúsculas.
	@;	Parámetros:
	@;		R0 : dirección base de la matriz
	@;		R1 : número de filas
	@;		R2 : número de columnas
	@;		R3 : puntero a la palabra actual
	@;		R4 : índice fila actual
	@;		R5 : índice columna actual
	@;		R6 : incremento fila
	@;		r7 : incremento columna
	@;	Resultado:
	@;		R0 : código de orientación encontrado [1..8], o cero si no encuentra
	detectar_8_orientaciones:
			push {r3,r6-r9,lr}
			mov r8, #1
			mov r9, r0						@;salvamos r0, r9 auxiliar
			.Lbucle_orientaciones:
				cmp r8,#1
				beq .Lorientacion_1
				cmp r8,#2
				beq .Lorientacion_2
				cmp r8,#3
				beq .Lorientacion_3	
				cmp r8,#4
				beq .Lorientacion_4
				cmp r8,#5
				beq .Lorientacion_5	
				cmp r8,#6
				beq .Lorientacion_6
				cmp r8,#7
				beq .Lorientacion_7
				cmp r8,#8
				beq .Lorientacion_8
				.Lorientacion_1:			@;preparamos incrementos de indice para orientacion 1
					mov r6, #-1
					mov r7, #0
					b .Lfin_orientacion		@;una vez preparados, salimos
				.Lorientacion_2:			@;preparamos incrementos de indice para orientacion 2
					mov r6, #-1
					mov r7, #1
					b .Lfin_orientacion		@;una vez preparados, salimos					
				.Lorientacion_3:			@;preparamos incrementos de indice para orientacion 3
					mov r6, #0
					mov r7, #1
					b .Lfin_orientacion		@;una vez preparados, salimos				
				.Lorientacion_4:			@;preparamos incrementos de indice para orientacion 4
					mov r6, #1
					mov r7, #1
					b .Lfin_orientacion		@;una vez preparados, salimos				
				.Lorientacion_5:			@;preparamos incrementos de indice para orientacion 5
					mov r6, #1
					mov r7, #0
					b .Lfin_orientacion		@;una vez preparados, salimos				
				.Lorientacion_6:			@;preparamos incrementos de indice para orientacion 6
					mov r6, #1
					mov r7, #-1
					b .Lfin_orientacion		@;una vez preparados, salimos				
				.Lorientacion_7:			@;preparamos incrementos de indice para orientacion 7
					mov r6, #0
					mov r7, #-1
					b .Lfin_orientacion		@;una vez preparados, salimos					
				.Lorientacion_8:			@;preparamos incrementos de indice para orientacion 8
					mov r6, #-1
					mov r7, #-1		
				.Lfin_orientacion:
				bl detectar_1_orientacion
				cmp	r0, r8					@;comprobamos si hemos encontrado toda la palabra en sopa
				beq .Lencontrada
				mov r0, r9					@;restauramos r0
				add r8, #1	
				cmp r8, #9					@;comprobamos siguiente orientacion
				bne .Lbucle_orientaciones	
			mov r0, #0						@;palabra no encontrada=orientacion 0
			b .Lfinal_orientaciones
			.Lencontrada:
				mov r0, r3					@;preparar parametros para funcion
				bl longitud_palabra
				mov r3, r0 					
				mov r0, r9 					@;preparar parametros para funcion
				bl cambiar_letras
				mov r0, r8 					@;cargamos orientacion para futura comparacion
			.Lfinal_orientaciones:
			pop {r3,r6-r9,pc}

	@; Función 'detectar_1_orientacion' -> dada una coincidencia de la primera
	@; letra de una palabra con una posición de la matriz, buscar la continua-
	@; ción de la coincidencia del resto de las letras en una posible orienta-
	@; ción y, en caso de coincidencia completa, cambiar las minúsculas por
	@; mayúsculas.
	@;	Parámetros:
	@;		R0 : dirección base de la matriz
	@;		R1 : número de filas
	@;		R2 : número de columnas
	@;		R3 : puntero a la palabra actual
	@;		R4 : índice fila actual
	@;		R5 : índice columna actual
	@;		R6 : incremento fila actual
	@;		R7 : incremento columna actual
	@;		R8 : orientación que se está comprobando ahora mismo
	@;	Resultado:
	@;		R0 : diferente de cero si hay coincidencia de la palabra
	detectar_1_orientacion:
			push {r1-r12,lr}
			mov r9, r3					@;salvamos r3, r9 auxiliar
			mov r10, r0					@;salvamos r0, r10 auxiliar
			add r9, #1						
			.Lbucle_orientacion:
				ldrb r3, [r9]			@;r3=palabra[i]		
				cmp r3, #'.'	
				beq .Lfinal_palabra 	@;toda la palabra detectada
				bl seguent					
				bl coincidencia				
				cmp r0, #0				@;comprobamos coincidencia
				beq .Lbuclefin			@;falso=terminamos
				add r9, #1				@;incrementamos el contador para cargar la siguiente letra
				mov r0, r10				@;restauramos r0
				b .Lbucle_orientacion	
			.Lfinal_palabra:
				mov r0, r8	@;el resultado a devolver es la orientación en curso en caso de que llegue aquí
			.Lbuclefin:
			pop {r1-r12,pc}
	
	@; Función 'seguent' -> función creada que busca la siguiente letra en la sopa segun su incremento en filas/columnas:
	@;	Parámetros:
	@;		R1 : número de filas
	@;		R2 : número de columnas
	@;		R4 : índice fila actual
	@;		R5 : índice columna actual
	@;		R6 : incremento fila actual
	@;		R7 : incremento columna actual
	@;	Resultados:
	@;		R4 : nuevo índice fila 
	@;		R5 : nuevo índice columna
	seguent:
		push {r8,r9,lr}
			mov r8, r4
			mov r9, r5					@;usamos r8 y r9 de auxiliares para no perder valores
			cmp r6, #0
			beq .Lsiguiente_columna		@;si inc.fila=0, solo incrementa una columna
			blt .Lresta_fila			@;si es negativo, se tiene que restar la fila
			cmp r4, r1
			beq .Lfinal_siguiente		@;si es la ultima fila, no podemos coger una de mas
			add r4, #1					@;si no es la ultima fila, se suma 
			b .Lsiguiente_columna		@;una vez tocada la fila, miramos columnas
			.Lresta_fila:
				cmp r4, #0
				beq .Lfinal_siguiente	@;si ind.fila=0 no podemos restarla
				sub r4, #1				@;sino, restamos
			.Lsiguiente_columna:
				cmp r7, #0
				beq .Lfinal_siguiente	@;si inc.columna es 0 e inc.fila es 0, no tocamos nada
				blt .Lresta_columna		@;sino, si es negativo se resta
			cmp r5, r2
			beq .Lrestaura				@;si estamos en la ultima columna no podemos sumarla
			add r5, #1					@;si no es la ultima columna, se suma
			b .Lfinal_siguiente			@;y terminamos
			.Lresta_columna:
				cmp r5, #0
				beq .Lrestaura	@;si estamos en primera columna no podemos restar
				sub r5, #1				@;sino, restamos 1
				b .Lfinal_siguiente		@;y terminamos
			.Lrestaura:
				mov r4, r8
				mov r5, r9				@;devolvemos el mismo indice aunque pida incremento porque nos salimos del limite
			.Lfinal_siguiente:
		pop {r8,r9,pc}

	@; Función 'coincidencia' -> detecta si una letra coincide con una posición
	@; de la matriz, independientemente de si en la matriz se encuentra en
	@; mayúsculas o minúsculas.
	@;	Parámetros:
	@;		R0 : dirección base de la matriz
	@;		R2 : número de columnas
	@;		R3 : código ASCII de la letra a detectar (se supone en mayúsculas)
	@;		R4 : índice fila actual
	@;		R5 : índice columna actual
	@;	Resultado:
	@;		R0 : cero si no coincide, diferente de cero si coincide
	coincidencia:
			push {r3,r6-r8,lr}
			mov r6, r5				@;salvamos r5 usando r6
			mul r7, r4, r2	
			add r6, r7		
			add r6, r0				@;las cuentas para encontrar indice sopa
			ldrb r8, [r6]			@;cargamos el byte en el registro calculado sobre R0
			cmp r3, #'Z'
			bhi .Lminus_paraula
			add r3, #32				@;pasamos a minus en caso que esta mayus
			.Lminus_paraula:
			cmp r8, #'Z'
			bhi .Lminus_sopa
			add r8, #32				@;pasamos a minus en caso que esta mayus
			.Lminus_sopa:
			cmp r3, r8				@;comparamos letra sopa minus con letra palabra minus
			beq	.Ltrue
			bne .Lfalse
			.Ltrue:
				mov r0, #1
				b .Lfinal_coincidencia
			.Lfalse:
				mov r0, #0
			.Lfinal_coincidencia:	@;retornamos r0 usandolo como booleano
			pop {r3,r6-r8,pc}

	@; Función 'cambiar_letras' -> a partir de una posición inicial de la
	@; matriz, una orientación y un número de letras, cambiar todas las
	@; minúsculas por mayúsculas.
	@;	Parámetros:
	@;		R0 : dirección base de la matriz
	@;		R2 : número de columnas
	@;		R3 : número de letras a cambiar
	@;		R4 : índice fila actual
	@;		R5 : índice columna actual
	@;		R6 : incremento fila actual
	@;		R7 : incremento columna actual
	cambiar_letras:
		push {r8-r11,lr}
		mov r8, #0					@;r8 sera indice para bucle
		.Lbucle_cambiar:
			mov r9, r5		
			mul r10, r4, r2	
			add r9, r10		
			add r9, r0				@;operaciones para el indice de la sopa
			ldrb r11,[r9]
			cmp r11, #'Z'
			blo .Lfinal				@;si ya es mayuscula (letra comun de dos palabras), no la tocamos
			sub r11, #32			@;sino, la convertimos en mayus
			strb r11, [r9]			@;guardamos a la memoria la nueva letra (mayus)
			.Lfinal:
				bl seguent
				add r8, #1
				cmp r8, r3
				bne .Lbucle_cambiar	@;si no hemos cambiado todas las letras, continuamos
		pop {r8-r11,pc}
	
	@; Función 'limpiar_minusculas' -> convierte todas las letras minúsculas de
	@; la matriz en puntos.
	@;	Parámetros:
	@;		R0 : dirección base de la matriz
	@;		R1 : número de filas
	@;		R2 : número de columnas
	limpiar_minusculas:
		push {r3-r4, lr}
			
		mul r3, r1, r2				@; R3 = número de posiciones
		.Llimp_buc:
			sub r3, #1					@; pasar a posición anterior
			ldrb r4, [r0, r3]			@; R4 = matriz[pos]
			cmp r4, #'a'				
			blo .Llimp_cont				@; si letra mayúscula, continua
			mov r4, #'.'				@; convierte minúscula en punto 
			strb r4, [r0, r3]
		.Llimp_cont:
			cmp r3, #0
			bne .Llimp_buc				@; repite para todas las posiciones
			
			pop {r3-r4, pc}

.end
