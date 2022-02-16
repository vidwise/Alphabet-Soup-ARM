@;=== Datos para el programa que resuelve sopas de letras  ===
@;= sopa0.s : cinco jugetes (horizontales y verticales, no cruzadas)
@;= {0,0,0,2,0,3,0,0,0}

@;--- .data. Non-zero Initialized data ---
.data
		.global sopa_nfil
		.global sopa_ncol
		.global sopa_matriz
		.global sopa_palabras
	sopa_nfil:	.byte	15			@; número de filas
	sopa_ncol:	.byte	8			@; número de columnas
	sopa_matriz:					@; matriz de letras
		.ascii	"puzzlexc"
		.ascii	"uqsgjmhz"
		.ascii	"udrzaroa"
		.ascii	"kdoceugz"
		.ascii	"dummcxae"
		.ascii	"rkpgobwn"
		.ascii	"hjevmhxu"
		.ascii	"vpcvbrmb"
		.ascii	"udataqea"
		.ascii	"sgblaxbl"
		.ascii	"etefuyvo"
		.ascii	"wwzeocqn"
		.ascii	"cbayamhj"
		.ascii	"ehszrhre"
		.ascii	"zjqkqlwz"
	sopa_palabras:					@; lista de palabras a buscar
		.ascii	"PUZZLE.","BALON.","COMBA.","ARO.","ROMPECABEZAS.","."

.end
