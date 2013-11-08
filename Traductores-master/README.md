Proyecto de Traductores CI-3725
===================================
Interpretador del lenguaje RangeX
===================================

Gabriela Limonta. Carnet 10-10385.
John Delgado. Carnet 10-1085.

Primera entrega (Lexer)
-----------------------

Para esta primera entrega se realiza la implementación en lenguaje ruby (version 1.8.7) de un lexer para el lenguaje RangeX.

Se lee de la entrada un archivo que contiene el programa en rangex que se proceerá luego a tokenizar.
Se crea una clase Objeto de Texto que guarda los atributos linea, columna y texto. Entonces se tiene que un Token es solamente un Objeto de Texto que además tiene asociada a su clase una expresión regular (regex). También se tiene que un error es un Objeto de Texto.

Se crea además una clase Lexer que contiene como atributos una lista de tokens reconocidos, una lista de errores, el string de entrada, la linea y la columna.
Para esta clase se definen varios metodos. El primero de ellos es consume; dada una longitud se encarga de consumir el string de entrada en esa cantidad de caracteres.
Luego se encuentra yylex; este se encarga de tokenizar. Revisa para cada expresión regular si alguna de ellas hace match con el string de entrada, en caso de ser así agrega el token a la lista de tokens reconocidos y si no hace match con alguna lo agrega a la lista de errores.
Finalmente se tiene un metodo to_s que lleva a un string algun elemento de esta clase.

Con esto implementado solo queda el main del programa que consiste en leer el archivo de entrada, crear un objeto de tipo Lexer, ejecutar el método yylex mientras aun haya entrada que consumir y finalmente se imprimen los tokens y su ubicación (linea, columna) en caso de no haber errores, si hay errores se imprimen solamente los errores y en donde están ubicados.

Segunda Entrega (Parser)
--------------------------

Para esta segunda entrega se continua utilizando el lenguaje Ruby (version 1.8.7) junto con el generador de analizadores sintácticos Racc (version 1.4.5) para la realización de un parser del lenguaje RangeX.

Se incluye ademas un makefile que ejecuta racc sobre el archivo Parser.y y genera Parser.rb.

Para el reconocimiento de este lenguaje se diseñó una gramática libre de contexto que se presenta a continuación.

    Simbolo inicial: Programa.
    
           Programa->'program' Instruccion                                { result = Programa::new(val[1])                         }
                   ;
        Instruccion->'id' '=' Expresion                                   { result = Asignacion::new(val[0], val[2])               }
                   | 'begin' Declaraciones Instrucciones 'end'            { result = Bloque::new(val[1], val[2])                   }
                   | 'read' 'id'                                          { result = Read::new(val[1])                             }
                   | 'write' ElementosSalida                              { result = Write::new(val[1])                            }
                   | 'writeln' ElementosSalida                            { result = Writeln::new(val[1])                          }
                   | 'if' Expresion 'then' Instruccion 'else' Instruccion { result = Condicional_Else::new(val[1], val[3], val[5]) }
                   | 'if' Expresion 'then' Instruccion                    { result = Condicional_If::new(val[1], val[3])           }
                   | 'case' Expresion 'of' Casos 'end'                    { result = Case::new(val[0], val[3])                     }
                   | 'for' 'id' 'in' Expresion 'do' Instruccion           { result = Iteracion_Det::new(val[1], val[3], val[5])    }
                   | 'while' Expresion 'do' Instruccion                   { result = Iteracion_Indet::new(val[1], val[3])          }
                   ;
              Casos->Caso                                                 { result = [val[0]]                                      }
                   | Casos ';' Caso                                       { result = val[0] + [val[2]]                             }
                   ;
               Caso->Expresion '->' Instruccion                           { result = Caso::new(val[0], val[2])                     }
                   ;
      Declaraciones->'declare' LDeclaraciones                             { result = Declaraciones::new(val[1])                    }
                   |                                                      { result = Declaraciones::new([])                        }
                   ;
     LDeclaraciones->Declaracion                                          { result = [val[0]]                                      }
                   | LDeclaraciones ';' Declaracion                       { result = val[0] + [val[2]]                             }
                   ;
        Declaracion->Variables 'as' Tipo                                  { result = Declaracion::new(val[0], val[2])              }
                   ;
               Tipo->'int'                                                { result = val[0]                                        }
                   | 'bool'                                               { result = val[0]                                        }
                   | 'range'                                              { result = val[0]                                        }
                   ;
          Variables->Variables ',' 'id'                                   { result = val[0] + [val[2]]                             }
                   | 'id'                                                 { result = [val[0]]                                      }
                   ;
      Instrucciones->Instruccion                                          { result = [val[0]]                                      }
                   | Instrucciones ';' Instruccion                        { result = val[0] + [val[2]]                             }
                   ;
    ElementosSalida->ElementoSalida                                       { result = [val[0]]                                      }
                   | ElementosSalida ',' ElementoSalida                   { result = val[0] + [val[2]]                             }
                   ;
     ElementoSalida->'str'                                                { result = val[0]                                        }
                   | Expresion                                            { result = val[0]                                        }
                   ;
          Expresion->'num'                                                { result = Entero::new(val[0])                           }
                   | 'true'                                               { result = True::new()                                   }
                   | 'false'                                              { result = False::new()                                  }
                   | 'id'                                                 { result = Variable::new(val[0])                         }
                   | 'bottom' '(' Expresion ')'                           { result = Funcion_Bottom::new(val[2])                   }
                   | 'length' '(' Expresion ')'                           { result = Funcion_Length::new(val[2])                   }
                   | 'rtoi'   '(' Expresion ')'                           { result = Funcion_Rtoi::new(val[2])                     }
                   | 'top'    '(' Expresion ')'                           { result = Funcion_Top::new(val[2])                      }
                   | Expresion '%'   Expresion                            { result = Modulo::new(val[0], val[2])                   }
                   | Expresion '*'   Expresion                            { result = Multiplicacion::new(val[0], val[2])           }
                   | Expresion '+'   Expresion                            { result = Suma::new(val[0], val[2])                     }
                   | Expresion '-'   Expresion                            { result = Resta::new(val[0], val[2])                    }
                   | Expresion '..'  Expresion                            { result = Construccion::new(val[0], val[2])             }
                   | Expresion '/'   Expresion                            { result = Division::new(val[0], val[2])                 }
                   | Expresion '/='  Expresion                            { result = Desigual::new(val[0], val[2])                 }
                   | Expresion '<'   Expresion                            { result = Menor_Que::new(val[0], val[2])                }
                   | Expresion '<='  Expresion                            { result = Menor_Igual_Que::new(val[0], val[2])          }
                   | Expresion '<>'  Expresion                            { result = Interseccion::new(val[0], val[2])             }
                   | Expresion '=='  Expresion                            { result = Igual::new(val[0], val[2])                    }
                   | Expresion '>'   Expresion                            { result = Mayor_Que::new(val[0], val[2])                }
                   | Expresion '>='  Expresion                            { result = Mayor_Igual_Que::new(val[0], val[2])          }
                   | Expresion '>>'  Expresion                            { result = Pertenece::new(val[0], val[2])                }
                   | Expresion 'and' Expresion                            { result = And::new(val[0], val[2])                      }
                   | Expresion 'or'  Expresion                            { result = Or::new(val[0], val[2])                       }
                   | 'not' Expresion                                      { result = Not::new(val[1])                              }
                   | '-'   Expresion =UMINUS                              { result = Menos_Unario::new(val[1])                     }
                   | '(' Expresion ')'                                    { result = val[1]                                        }
                   ;

Para mayor comodidad y legibilidad utilizamos las palabras y simbolos del lenguaje en vez de escribir allí los tokens.
A continuacion se presenta a que token corresponde cada palabra reservada y simbolo:


        '('       corresponde a: 'TkAbreParentesis'
        ')'       corresponde a: 'TkCierraParentesis'
        ','       corresponde a: 'TkComa'
        '/='      corresponde a: 'TkDesigual'
        '/'       corresponde a: 'TkDivision'
        '..'      corresponde a: 'TkDosPuntos'
        '->'      corresponde a: 'TkFlecha'
        'id'      corresponde a: 'TkId'
        '=='      corresponde a: 'TkIgual'
        '<>'      corresponde a: 'TkInterseccion'
        '>='      corresponde a: 'TkMayorIgualQue'
        '>'       corresponde a: 'TkMayorQue'
        '<='      corresponde a: 'TkMenorIgualQue'
        '<'       corresponde a: 'TkMenorQue'
        '%'       corresponde a: 'TkModulo'
        '*'       corresponde a: 'TkMultiplicacion'
        'num'     corresponde a: 'TkNum'
        '>>'      corresponde a: 'TkPertenece'
        ';'       corresponde a: 'TkPuntoYComa'
        '-'       corresponde a: 'TkResta'
        'str'     corresponde a: 'TkString'
        '+'       corresponde a: 'TkSuma'
        '='       corresponde a: 'TkAsignacion'
        'and'     corresponde a: 'TkAnd'
        'as'      corresponde a: 'TkAs'
        'begin'   corresponde a: 'TkBegin'
        'bool'    corresponde a: 'TkBool'
        'bottom'  corresponde a: 'TkBottom'
        'case'    corresponde a: 'TkCase'
        'declare' corresponde a: 'TkDeclare'
        'do'      corresponde a: 'TkDo'
        'else'    corresponde a: 'TkElse'
        'end'     corresponde a: 'TkEnd'
        'false'   corresponde a: 'TkFalse'
        'for'     corresponde a: 'TkFor'
        'if'      corresponde a: 'TkIf'
        'in'      corresponde a: 'TkIn'
        'int'     corresponde a: 'TkInt'
        'length'  corresponde a: 'TkLength'
        'not'     corresponde a: 'TkNot'
        'of'      corresponde a: 'TkOf'
        'or'      corresponde a: 'TkOr'
        'program' corresponde a: 'TkProgram'
        'range'   corresponde a: 'TkRange'
        'read'    corresponde a: 'TkRead'
        'rtoi'    corresponde a: 'TkRtoi'
        'then'    corresponde a: 'TkThen'
        'top'     corresponde a: 'TkTop'
        'true'    corresponde a: 'TkTrue'
        'while'   corresponde a: 'TkWhile'
        'write'   corresponde a: 'TkWrite'
        'writeln' corresponde a: 'TkWriteln'


Esta gramática junto con sus atributos se pasa a la herramienta racc que permite generar el analizador sintactico.
Se crea una clase Parser que tiene varios metodos que permiten conseguir el nuevo token a analizar, hacer el parse y definir que hacer en caso de error.

Se crea una clase nueva para los errores sintácticos. Se crean ademas nuevas clases para cada uno de los elementos que contiene el arbol de sintaxis abstracta.
Para esto se utiliza metaprogramación. Se declara una funcion generaClase que se encarga de generar una nueva clase indicada a partir del nombre de la clase de quien hereda, los atributos que tenga y el nombre de la clase.
Cada clase tiene un nuevo método to_string que permite pasar a string elementos de las mismas para poder imprimirlos por pantalla comodamente.
En el metodo parse, se realiza el análisis lexicográfico, seguido del parseo de los tokens que esto genera, para finalmente retornar el AST construido.
Si el AST que se devuelve no es nil entonces se imprime la representación del árbol por pantalla en el main de la siguiente manera:

Si se toma la siguiente entrada:

    // (a ** b) % c
    program
      begin
        declare a, b, c, res as int
        read a;
        read b;
        read c;
    
        // exponenciacion rapida O(lg n)
        res = 1;
        begin
          declare n, x as int
          x = a;
          n = b;
          while (n >= 0) do
          begin
            if (n % 2 /= 0) then
            begin
              begin
                res = (res * x) % c;
                n = n - 1
              end;
              x = (x*x) % c;
              n = n / 2
            end
          end
        end;
        write res
      end


Se obtiene la siguiente salida:

    BLOQUE
      - READ
          variable: a
      - READ
          variable: b
      - READ
          variable: c
      - ASIGNACION
          var: res
          val:
            ENTERO
              valor: 1
      - BLOQUE
          - ASIGNACION
              var: x
              val:
                VARIABLE
                  nombre: a
          - ASIGNACION
              var: n
              val:
                VARIABLE
                  nombre: b
          - ITERACION_INDET
              condicion:
                MAYOR_IGUAL_QUE
                  operando izquierdo:
                    VARIABLE
                      nombre: n
                  operando derecho:
                    ENTERO
                      valor: 0
              instruccion:
                BLOQUE
                  - CONDICIONAL_IF
                      condicion:
                        DESIGUAL
                          operando izquierdo:
                            MODULO
                              operando izquierdo:
                                VARIABLE
                                  nombre: n
                              operando derecho:
                                ENTERO
                                  valor: 2
                          operando derecho:
                            ENTERO
                              valor: 0
                      verdadero:
                        BLOQUE
                          - BLOQUE
                              - ASIGNACION
                                  var: res
                                  val:
                                    MODULO
                                      operando izquierdo:
                                        MULTIPLICACION
                                          operando izquierdo:
                                            VARIABLE
                                              nombre: res
                                          operando derecho:
                                            VARIABLE
                                              nombre: x
                                      operando derecho:
                                        VARIABLE
                                          nombre: c
                              - ASIGNACION
                                  var: n
                                  val:
                                    RESTA
                                      operando izquierdo:
                                        VARIABLE
                                          nombre: n
                                      operando derecho:
                                        ENTERO
                                          valor: 1
                          - ASIGNACION
                              var: x
                              val:
                                MODULO
                                  operando izquierdo:
                                    MULTIPLICACION
                                      operando izquierdo:
                                        VARIABLE
                                          nombre: x
                                      operando derecho:
                                        VARIABLE
                                          nombre: x
                                  operando derecho:
                                    VARIABLE
                                      nombre: c
                          - ASIGNACION
                              var: n
                              val:
                                DIVISION
                                  operando izquierdo:
                                    VARIABLE
                                      nombre: n
                                  operando derecho:
                                    ENTERO
                                      valor: 2
      - WRITE
          elementos:
            - VARIABLE
                nombre: res


En caso de haber errores lexicográficos se procederá a imprimir solamente estos como en la primera entrega.
Y en caso de haber errores sintácticos se para la ejecución al encontrar el mismo y se indica por pantalla.

De este modo en el main solamente se crea un nuevo lexer con el archivo de entrada, que se le pasa al parser y devuelve el AST construido y se imprime por salida estándar.


Tercera entrega (Tabla de Símbolos y Verificaciones estáticas)
---------------------------------------------------------------

Para esta tercera entrega se continua utilizando el lenguaje Ruby (version 1.8.7) junto con el generador de analizadores sintácticos Racc (version 1.4.5) para la realización de un parser del lenguaje RangeX que ahora contiene la tabla de símbolos y verificaciones estáticas.

Se implementó una interfaz para manejar las tablas de símbolos y poder chequear la semántica de las variables, es decir poder revisar que cuando se realicen operaciones con dos o mas variables estas sean del tipo requerido por los operadores utilizados.

Se revisa además en esta tabla de símbolos, si las variables están declaradas para poderlas usar o si las mismas pueden ser modificadas.

Se modifico el archivo AST.rb generando las clases pertinentes a los tipos de operaciones entre los operados disponibles en RangeX, para ello se creó un modulo llamado Type.rb que define los tipos básicos de datos que pueden existir en el lenguaje; las clases generadas en el AST.rb contienen un procedimiento llamado check, que se encarga de verificar el sub-arbol de la operación que se esta verificando.

La idea de verificar operaciones hacia abajo del árbol sintáctico es que cuando se llegue a las hojas del mismo, retorne hacia arriba si la operación genera un error o el resultado de la misma, de esta forma se revisa y si hay un problema el programa lo notifica.

Si hay un problema en el chequeo de tipos entonces se genera un error; lo que se hace, básicamente, es llamar al constructor de la clase de error y agregar esa instancia del mismo a una lista en forma de variable global para que luego de la ejecución de todo el chequeo de tipos se imprima esa lista y el programador pueda observar los detalles acerca de los errores.


Cuarta entrega (Interpretador con verificaciones dinámicas)
------------------------------------------------------------

Para esta cuarta entrega se continua utilizando el lenguaje Ruby (version 1.8.7) junto con el generador de analizadores sintácticos Racc (version 1.4.5) para la realización de un interpretador del lenguaje RangeX que contenga verificaciones dinámicas.

A las clases que representan los tipos y los operadores del lenguaje se les agrego una función llamada run, la cual permite ejecutar de forma recursiva la operación que se especifica. En los casos base, int, bool (true y false) y range se devuelve su valor. En el caso del range se devuelve una lista con las cotas del rango. Nos basamos en los tipos y estructuras de control existentes de Ruby, pues la idea es usar Ruby para generar un intérprete de un lenguaje llamado RangeX. Se aprovecha la similitud entre las operaciones y estructuras manejadas en el lenguaje RangeX y las propias de Ruby para facilitar la implementación del intérprete.

Todas las funciones run propias de las clases de los operadores tienen su respectiva implementación como se describió anteriormente y devuelven su valor hacia arriba para que el run del programa pueda terminar.

Para esta entrega se desarrollo también un método que nos permite detectar si hay overflow, para la verificación dinámica de errores, esta se usa en los run correspondientes a las expresiones, por ejemplo, la suma, la multiplicación y la resta. Este metodo esta implementado para verificar si el entero del resultado permanece acotado en un rango representable a 32 bits y si lo es entonces devuelve su valor, en caso contrario levanta un error del tipo overflow para notificar al programador.
Otra de las verificaciones que se hacen en tiempo de ejecución es la división entre cero, errores de rangos y de variables no inicializadas.

Como algo adicional a los requerimientos del proyecto, se modificaron los mensajes de error para ser mas detallados a la hora de indicar la ubicación de un error en el código. Se agrega una clase Ubicacion que contiene una línea y una columna. Dentro de la implementación se utilizan dos ubicaciones; la de inicio y la final, de esta manera se indica precisamente donde empieza el error y donde termina el mismo y además se indica el mensaje de error correspondiente como es pedido en el enunciado del proyecto.
