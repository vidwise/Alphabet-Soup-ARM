@;=== Datos para el programa que resuelve sopas de letras  ===
@;= sopa3.s : diez palabras relacionadas con valores éticos (N, NE, E, SE, S)
@;= (una palabara no está en la matriz)
@;= {1,2,1,3,1,2,0,0,0}

@;--- .data. Non-zero Initialized data ---
.data
		.global sopa_nfil
		.global sopa_ncol
		.global sopa_matriz
		.global sopa_palabras
	sopa_nfil:	.byte	19			@; número de filas
	sopa_ncol:	.byte	20			@; número de columnas
	sopa_matriz:					@; matriz de letras
		.ascii	"egadcsfpuiqwertyuopp"
		.ascii	"atghjaqoiasdfghjklnm"
		.ascii	"sfilodwhjefvaszipoig"
		.ascii	"esociedadeticcohgroc"
		.ascii	"rfflarwijssseseeguvg"
		.ascii	"dqfhwrwudvaloejeftex"
		.ascii	"agfhetwyfaanoahdhlnw"
		.ascii	"dzpisyatgjajdfghhuee"
		.ascii	"ityuduergmjugffcfczr"
		.ascii	"lrdsxieeuvvaasfufgkl"
		.ascii	"ascocoshdazavellasco"
		.ascii	"nsvmnpgjvniiuyttrewq"
		.ascii	"oebsbnsudgftrrruwedd"
		.ascii	"samiukgbeerhjjkrlnmn"
		.ascii	"rtynukcduniversalesb"
		.ascii	"erkawebssdfghjlnzxcv"
		.ascii	"pelgqvnxaqwertklnopp"
		.ascii	"adnrjbjuytvbcfjnamja"
		.ascii	"valoresxdvbnmglgjlkz"
	sopa_palabras:					@; lista de palabras a buscar
		.ascii	"ETICA.","SOCIEDAD.","PERSONALIDAD.","VALORES.","ORGANISMOS."
		.ascii	"HUMANOS.","JOVENES.","CULTURA.","UNIVERSALES.","PAZ.","."

.end
