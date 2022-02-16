@;=== Datos para el programa que resuelve sopas de letras  ===
@;= sopa2.s : cinco partes del cuerpo, en inglés (derecha y abajo)
@;= {0,0,0,1,1,3,0,0,0}

@;--- .data. Non-zero Initialized data ---
.data
		.global sopa_nfil
		.global sopa_ncol
		.global sopa_matriz
		.global sopa_palabras
	sopa_nfil:	.byte	10			@; número de filas
	sopa_ncol:	.byte	8			@; número de columnas
	sopa_matriz:					@; matriz de letras
		.ascii	"ugozdzvh"
		.ascii	"obonesas"
		.ascii	"xubbnsyh"
		.ascii	"qhrfepbc"
		.ascii	"yiemuaoe"
		.ascii	"ppaurerp"
		.ascii	"jssxoqed"
		.ascii	"ivtzndob"
		.ascii	"bhsnsxis"
		.ascii	"breadyoc"
	sopa_palabras:					@; lista de palabras a buscar
		.ascii	"BEARD.","BONES.","BREASTS.","HIPS.","NEURONS.","."

.end
