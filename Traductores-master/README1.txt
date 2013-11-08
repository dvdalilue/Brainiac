Gabriela Limonta. Carnet 10-10385. John Delgado. Carnet 10-1085.

Primera entrega de traductores CI-3725 (Lexer)

Para esta primera entrega se realiza la implementación en lenguaje ruby
(version 1.8.7) de un lexer para el lenguaje Rangex. Se lee de la
entrada un archivo que contiene el programa en rangex que se proceerá
luego a tokenizar.

Se crea una clase Objeto de Texto que guarda los atributos linea,
columna y texto. Entonces se tiene que un Token es solamente un Objeto
de Texto que además tiene asociada a su clase una expresión regular
(regex). También se tiene que un error es un Objeto de Texto.

Se crea además una clase Lexer que contiene como atributos una lista de
tokens reconocidos, una lista de errores, el string de entrada, la linea
y la columna. Para esta clase se definen varios metodos. El primero de
ellos es consume; dada una longitud se encarga de consumir el string de
entrada en esa cantidad de caracteres. Luego se encuentra yylex; este se
encarga de tokenizar. Revisa para cada expresión regular si alguna de
ellas hace match con el string de entrada, en caso de ser así agrega el
token a la lista de tokens reconocidos y si no hace match con alguna lo
agrega a la lista de errores. Finalmente se tiene un metodo to\_s que
lleva a un string algun elemento de esta clase.

Con esto implementado solo queda el main del programa que consiste en
leer el archivo de entrada, crear un objeto de tipo Lexer, ejecutar el
método yylex mientras aun haya entrada que consumir y finalmente se
imprimen los tokens y su ubicación (linea, columna) en caso de no haber
errores, si hay errores se imprimen solamente los errores y en donde
están ubicados.
