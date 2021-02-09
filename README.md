# ETS Compiladores Feb2021

Estudiante: Edgar Flores Villa

Boleta: 2014630155

Herramientas: Flex, JFlex, Bison:

Entrada: [código ejemplo](codigo)

# Procesador Léxico y Sintáctico:

para ejecutar el código de los procesos léxico y sintáctico, se neceistan ejecutar los siguientes comandos.

```
	flex -l Lexico.l
	bison -d sintactico.y
	gcc -o CodigoLexicoSintactico sintactico.tab.c lex.yy.c -lm
```
para analizar un código corremos el siguiente comando, que ejecutara el código ejemplo:

```
./CodigoLexicoSemantico < codigo
```

Si existe algún error en el código se mostrará en la consola, si los procesos léxico y sintáctico terminan con éxito, solo se verán la declaración de variables en consola.
