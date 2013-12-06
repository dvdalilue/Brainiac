#Gabriela Limonta 10-10385
#John Delgado 10-10196

class Parser
  #Declaramos los tokens
  token '<=' '<>' '<' '==' '=' '>=' '>>' '>' '-' ',' ';' '/=' '..' '(' ')'
        '*' '%' '+' 'and' 'as' 'begin' 'bool' 'bottom' 'case' 'declare' 'do'
        'else' 'end' 'false' 'for' 'id' 'if' 'in' 'int' 'length' 'not'
        'of' 'or' 'program' 'range' 'read' 'rtoi' 'str' 'then' 'top' 'true'
        'while' 'write' 'writeln' UMINUS

  #Declaramos la precedencia de los operadores
  prechigh
    nonassoc UMINUS
    left     '..'
    left     '*' '/' '%'
    left     '+' '-'
    left     '<>'
    nonassoc '<' '<=' '>=' '>'
    left     '==' '/='
    nonassoc '>>'
    left     'not'
    left     'and'
    left     'or'
    right    'then' 'else'
  preclow

  convert
    '('       'TkAbreParentesis'
    ')'       'TkCierraParentesis'
    ','       'TkComa'
    '/='      'TkDesigual'
    '/'       'TkDivision'
    '..'      'TkDosPuntos'
    '->'      'TkFlecha'
    'id'      'TkId'
    '=='      'TkIgual'
    '<>'      'TkInterseccion'
    '>='      'TkMayorIgualQue'
    '>'       'TkMayorQue'
    '<='      'TkMenorIgualQue'
    '<'       'TkMenorQue'
    '%'       'TkModulo'
    '*'       'TkPor'
    'num'     'TkNum'
    '>>'      'TkPertenece'
    ';'       'TkPuntoYComa'
    '-'       'TkResta'
    'str'     'TkString'
    '+'       'TkMas'
    '='       'TkAsignacion'
    'and'     'TkAnd'
    'as'      'TkAs'
    'begin'   'TkBegin'
    'bool'    'TkBool'
    'bottom'  'TkBottom'
    'case'    'TkCase'
    'declare' 'TkDeclare'
    'do'      'TkDo'
    'else'    'TkElse'
    'end'     'TkEnd'
    'false'   'TkFalse'
    'for'     'TkFor'
    'if'      'TkIf'
    'in'      'TkIn'
    'int'     'TkInt'
    'length'  'TkLength'
    'not'     'TkNot'
    'of'      'TkOf'
    'or'      'TkOr'
    'program' 'TkProgram'
    'range'   'TkRange'
    'read'    'TkRead'
    'rtoi'    'TkRtoi'
    'then'    'TkThen'
    'top'     'TkTop'
    'true'    'TkTrue'
    'while'   'TkWhile'
    'write'   'TkWrite'
    'writeln' 'TkWriteln'
  end

  start Programa
#Aqui declaramos la gramatica
rule
       Programa: 'program' Instruccion                                { result = Programa        .new(val[1]                ).set_inicio(val[0].inicio)                         }
               ;
    Instruccion: 'id' '=' Expresion                                   { result = Asignacion      .new(val[0], val[2]        ).set_inicio(val[0].inicio)                         }
               | 'begin' Declaraciones Instrucciones 'end'            { result = Bloque          .new(val[1], val[2]        ).set_inicio(val[0].inicio).set_final(val[3].final) }
               | 'begin'               Instrucciones 'end'            { result = Bloque          .new([]    , val[1]        ).set_inicio(val[0].inicio).set_final(val[2].final) }
               | 'read' 'id'                                          { result = Read            .new(val[1]                ).set_inicio(val[0].inicio).set_final(val[1].final) }
               | 'write' ElementosSalida                              { result = Write           .new(val[1]                ).set_inicio(val[0].inicio)                         }
               | 'writeln' ElementosSalida                            { result = Writeln         .new(val[1]                ).set_inicio(val[0].inicio)                         }
               | 'if' Expresion 'then' Instruccion 'else' Instruccion { result = Condicional_Else.new(val[1], val[3], val[5]).set_inicio(val[0].inicio)                         }
               | 'if' Expresion 'then' Instruccion                    { result = Condicional_If  .new(val[1], val[3]        ).set_inicio(val[0].inicio)                         }
               | 'case' Expresion 'of' Casos 'end'                    { result = Case            .new(val[1], val[3]        ).set_inicio(val[0].inicio).set_final(val[4].final) }
               | 'for' 'id' 'in' Expresion 'do' Instruccion           { result = Iteracion_Det   .new(val[1], val[3], val[5]).set_inicio(val[0].inicio)                         }
               | 'while' Expresion 'do' Instruccion                   { result = Iteracion_Indet .new(val[1], val[3]        ).set_inicio(val[0].inicio)                         }
               ;
          Casos: Caso                                                 { result = [val[0]]                                                                                        }
               | Casos Caso                                           { result = val[0] + [val[1]]                                                                               }
               ;
           Caso: Expresion '->' Instruccion ';'                       { result = Caso            .new(val[0], val[2]        )                          .set_final(val[3].final) }
               ;
  Declaraciones: 'declare' Declaracion                                { result = [val[1]]                                                                                        }
               | Declaraciones ';' Declaracion                        { result = val[0] + [val[2]]                                                                               }
               ;
    Declaracion: Variables 'as' Tipo                                  { result = Declaracion     .new(val[0], val[2]        )                                                   }
               ;
           Tipo: 'int'                                                { result = val[0]                                                                                          }
               | 'bool'                                               { result = val[0]                                                                                          }
               | 'range'                                              { result = val[0]                                                                                          }
               ;
      Variables: Variables ',' 'id'                                   { result = val[0] + [val[2]]                                                                               }
               | 'id'                                                 { result = [val[0]]                                                                                        }
               ;
  Instrucciones: Instruccion                                          { result = [val[0]]                                                                                        }
               | Instrucciones ';' Instruccion                        { result = val[0] + [val[2]]                                                                               }
               ;
ElementosSalida: ElementoSalida                                       { result = [val[0]]                                                                                        }
               | ElementosSalida ',' ElementoSalida                   { result = val[0] + [val[2]]                                                                               }
               ;
 ElementoSalida: 'str'                                                { result = val[0]                                                                                          }
               | Expresion                                            { result = val[0]                                                                                          }
               ;
      Expresion: 'num'                                                { result = Entero          .new(val[0]                ).set_inicio(val[0].inicio).set_final(val[0].final) }
               | 'true'                                               { result = True            .new(                      ).set_inicio(val[0].inicio).set_final(val[0].final) }
               | 'false'                                              { result = False           .new(                      ).set_inicio(val[0].inicio).set_final(val[0].final) }
               | 'id'                                                 { result = Variable        .new(val[0]                ).set_inicio(val[0].inicio).set_final(val[0].final) }
               | 'bottom' '(' Expresion ')'                           { result = Funcion_Bottom  .new(val[2]                ).set_inicio(val[0].inicio).set_final(val[3].final) }
               | 'length' '(' Expresion ')'                           { result = Funcion_Length  .new(val[2]                ).set_inicio(val[0].inicio).set_final(val[3].final) }
               | 'rtoi'   '(' Expresion ')'                           { result = Funcion_Rtoi    .new(val[2]                ).set_inicio(val[0].inicio).set_final(val[3].final) }
               | 'top'    '(' Expresion ')'                           { result = Funcion_Top     .new(val[2]                ).set_inicio(val[0].inicio).set_final(val[3].final) }
               | Expresion '%'   Expresion                            { result = Modulo          .new(val[0], val[2]        )                                                   }
               | Expresion '*'   Expresion                            { result = Por             .new(val[0], val[2]        )                                                   }
               | Expresion '+'   Expresion                            { result = Mas             .new(val[0], val[2]        )                                                   }
               | Expresion '-'   Expresion                            { result = Resta           .new(val[0], val[2]        )                                                   }
               | Expresion '..'  Expresion                            { result = Construccion    .new(val[0], val[2]        )                                                   }
               | Expresion '/'   Expresion                            { result = Division        .new(val[0], val[2]        )                                                   }
               | Expresion '/='  Expresion                            { result = Desigual        .new(val[0], val[2]        )                                                   }
               | Expresion '<'   Expresion                            { result = Menor_Que       .new(val[0], val[2]        )                                                   }
               | Expresion '<='  Expresion                            { result = Menor_Igual_Que .new(val[0], val[2]        )                                                   }
               | Expresion '<>'  Expresion                            { result = Interseccion    .new(val[0], val[2]        )                                                   }
               | Expresion '=='  Expresion                            { result = Igual           .new(val[0], val[2]        )                                                   }
               | Expresion '>'   Expresion                            { result = Mayor_Que       .new(val[0], val[2]        )                                                   }
               | Expresion '>='  Expresion                            { result = Mayor_Igual_Que .new(val[0], val[2]        )                                                   }
               | Expresion '>>'  Expresion                            { result = Pertenece       .new(val[0], val[2]        )                                                   }
               | Expresion 'and' Expresion                            { result = And             .new(val[0], val[2]        )                                                   }
               | Expresion 'or'  Expresion                            { result = Or              .new(val[0], val[2]        )                                                   }
               | 'not' Expresion                                      { result = Not             .new(val[1]                ).set_inicio(val[0].inicio)                         }
               | '-'   Expresion =UMINUS                              { result = Menos_Unario    .new(val[1]                ).set_inicio(val[0].inicio)                         }
               | '(' Expresion ')'                                    { result = val[1]                                                                                          }
               ;

---- header ----

require 'Lexer'
require 'AST'
require 'Ubicacion'

#Creamos una clase para los errores sintacticos
class ErrorSintactico < RuntimeError
  #Se encarga de inicializar un error sintactico indicandole
  #en que token ocurrió el mismo
  def initialize(token)
    @token = token
  end

  #Se encarga de pasar el error sintactico a string para imprimirlo en pantalla
  def to_s
    "Error de sintaxis en linea #{@token.linea}, columna #{@token.columna}, token '#{@token.texto}' inesperado."
  end
end

---- inner ----

    #En caso de que haya un error se crea un
    #nuevo error sintactico y levantamos una excepcion
    def on_error(id, token, stack)
      raise ErrorSintactico.new(token)
    end

    #Se encarga de buscar el proximo token usando el yylex del lexer.
    #Retorna el par [clase, token]
    def next_token
      token = @lexer.yylex
      return [false, false] unless token
      return [token.class, token]
    end

    #Se encarga de hacer el parse del lexer utilizando
    #el metodo parse que crea racc.
    def parse(lexer)
      @yydebug = true # DEBUG
      @lexer  = lexer
      @tokens = []
      begin
        # Hacemos parse para generar el ast
        ast = do_parse
      # Si hay un error lexicografico se hace rescue
      # para manejar la excepcion del error
      rescue ErrorLexicografico => error
        t = false
        # Mientras el lexer siga leyendo e identificando tokens o
        # errores en el texto de entrada el programa corre
        while (!t) do
          begin
            t = lexer.yylex.nil?
          rescue ErrorLexicografico => error
          end
        end
        # Finalmente se tira una excepcion con el lexer que ya ha sido llenado con todos los errores lexicográficos
        raise lexer.to_exception
      end
      # Se retorna el AST
      return ast
    end
