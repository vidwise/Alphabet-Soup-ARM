@;=== Datos para el programa que resuelve sopas de letras  ===
@;= sopa1.s : diez animales (solo horizontales y verticales, cruzadas)
@;= {0,0,0,5,0,5,0,0,0}

@;--- .data. Non-zero Initialized data ---
.data
		.global sopa_nfil
		.global sopa_ncol
		.global sopa_matriz
		.global sopa_palabras
	sopa_nfil:	.byte	15			@; número de filas
	sopa_ncol:	.byte	10			@; número de columnas
	sopa_matriz:					@; matriz de letras
		.ascii	"qrkawbdloc"
		.ascii	"holsvsjnok"
		.ascii	"xavestruza"
		.ascii	"hkjdxgjtux"
		.ascii	"xdidotsreu"
		.ascii	"ymrzaguila"
		.ascii	"hcaykscaee"
		.ascii	"mhfripeafg"
		.ascii	"yiamloboai"
		.ascii	"kmfkuurqnp"
		.ascii	"npggitarti"
		.ascii	"cakstigren"
		.ascii	"tnqtbbdovt"
		.ascii	"bcnqleonym"
		.ascii	"oecyeftnub"
	sopa_palabras:					@; lista de palabras a buscar
		.ascii	"AGUILA.","AVESTRUZ.","CEBRA.","CHIMPANCE.","ELEFANTE."
		.ascii	"JIRAFA.","LEON.","LOBO.","NUTRIA.","TIGRE.","."

.end
