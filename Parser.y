#Parser

class Parser

  token ',' ';' '(' ')' '-' '::' '/='  '+' '.' '*' ']' '{' '<=' 
        '>=' ':=' 'and' 'done' 'read' 'tape' 'write' 'cinta' '%' '~' 
        '<' '>' '=' 'to' 'do' 'if' 'true' 'false' 'else' 'while' 
        'or' 'ident' '/' '&' '#' '}' '[' 'at' 'end' 'then' 'integer' 
        'boolean' 'num' 'declare' 'execute' 'for' 'from' 'consttape' 
        UMINUS

  prechigh
    right 'at'
    right '#'
    right '~'
    nonassoc UMINUS
    left '*' '/' '%'
    left '+' '-'
    left '&'
    nonassoc '<' '>' '<=' '>='
    nonassoc '=' '/='
    nonassoc 'and'
    nonassoc 'or'
    nonassoc ':='
    right 'then' 'else'
  preclow

  convert
    'declare'   'TkDeclare'
    'execute'   'TkExecute'
    'done'      'TkDone'
    'read'      'TkRead'
    'write'     'TkWrite'
    'while'     'TkWhile' 
    'do'        'TkDo' 
    'if'        'TkIf'
    'else'      'TkElse'
    'then'      'TkThen'
    'end'       'TkEnd'
    'for'       'TkFor'
    'from'      'TkFrom'
    'at'        'TkAt'
    'tape'      'TkTape'
    'to'        'TkTo'
    'true'      'TkTrue'
    'false'     'TkFalse'
    'integer'   'TkInteger'
    'boolean'   'TkBoolean'
    'cinta'     'TkCinta'                 
    'consttape' 'TkConstructorTape' 
    ','         'TkComa'                  
    '.'         'TkPunto'        
    ';'         'TkPuntoYComa'             
    '('         'TkParAbre'                
    ')'         'TkParCierra'              
    '['         'TkCorcheteAbre'           
    ']'         'TkCorcheteCierra'         
    '{'         'TkLlaveAbre'              
    '}'         'TkLlaveCierra'            
    '::'        'TkType'                   
    '-'         'TkMenos'                 
    '+'         'TkMas'                   
    '*'         'TkMult'                   
    '/'         'TkDiv'                    
    '%'         'TkMod'                    
    'and'       'TkConjuncion'             
    'or'        'TkDisyuncion'             
    '~'         'TkNegacion'               
    '<'         'TkMenor'                  
    '<='        'TkMenorIgual'             
    '>'         'TkMayor'                  
    '>='        'TkMayorIgual'             
    '='         'TkIgual'                  
    '/='        'TkDesigual'               
    '&'         'TkConcat'                 
    '#'         'TkInspeccion'            
    ':='        'TkAsignacion'
    'ident'     'TkIdent'
    'num'       'TkNum'
  end

  start Programa
  
rule

     Programa: Alcance                                                                 {result = Programa::new(val[0]).set_line(val[0].line).set_column(val[0].column)           }
             ;                                                                         
                                                                                       
      Alcance: 'declare' Declaracion 'execute' Instruccion 'done'                      {result = Alcance::new(val[1], val[3]).set_line(val[0].line).set_column(val[3].column)    }
             | 'execute' Instruccion 'done'                                            {result = Alcance::new([], val[1]).set_line(val[0].line).set_column(val[2].column)        }
             ;

  Declaracion: ListaDecla                                                              {result = Declaraciones::new(val[0]).set_line(val[0][0].line).set_column(val[0][0].column)      }
             ;                                                                         
                                                                                       
   ListaDecla: Declare                                                                 {result = [val[0]]                        }
             | Declare ';' ListaDecla                                                  {result = [val[0]] + val[2]               }
             ;                                                                         
                                                                                       
      Declare: ListaIdent '::' Tipo                                                    {result = Declaracion::new(val[0], val[2]).set_line(val[0][0].line).set_column(val[1].column)}
             ;                                                                         
                                                                                       
   ListaIdent: 'ident'                                                                 {result = [Variable::new(val[0]).set_line(val[0].line).set_column(val[0].column)]         }
             | 'ident' ',' ListaIdent                                                  {result = [Variable::new(val[0]).set_line(val[0].line).set_column(val[0].column)] + val[2]}
             ;                                                                         
                                                                                       
         Tipo: 'boolean'                                                               {result = val[0]                          }
             | 'integer'                                                               {result = val[0]                          }
             | 'tape'                                                                  {result = val[0]                          }
             ;                                                                         
                                                                                       
  Instruccion: ListaInstr                                                              {result = Instrucciones::new(val[0]).set_line(val[0][0].line).set_column(val[0][0].column)      }
             ;                                                                         
                                                                                       
   ListaInstr: Instruc                                                                 {result = [val[0]]                        }
             | Instruc ';' ListaInstr                                                  {result = [val[0]] + val[2]               }
             ;                                                                         
                                                                                       
      Instruc: 'ident' ':=' Expresion                                                  {result = Asignacion::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column) }
             | Condicional                                                             {result = val[0]                          }
             | 'while' Expresion 'do' Instruccion 'done'                               {result = IteracionI::new(val[1], val[3]).set_line(val[0].line).set_column(val[0].column) }
             | 'cinta' 'at' Expresion                                                  {result = Ejecucion::new(val[0], val[2]).set_line(val[0].line).set_column(val[0].column)  }
             | IteracionD                                                              {result = val[0]                          }
             | IO                                                                      {result = val[0]                          }
             | Alcance                                                                 {result = SecInterna::new(val[0]).set_line(val[0].line).set_column(val[0].column)         }
             ;

  Condicional: 'if' Expresion 'then' Instruccion 'done'                                {result = CondicionalIf::new(val[1], val[3]).set_line(val[0].line).set_column(val[3].column)               }
             | 'if' Expresion 'then' Instruccion 'else' Instruccion 'done'             {result = CondicionalElse::new(val[1], val[3], val[5]).set_line(val[0].line).set_column(val[3].column)     }
             ;

   IteracionD: 'for' Expresion 'to' Expresion 'do' Instruccion 'done'                  {result = IteracionDExpA::new(val[1], val[3], val[5]).set_line(val[0].line).set_column(val[0].column)      }
             | 'for' 'ident' 'from' Expresion 'to' Expresion 'do' Instruccion 'done'   {result = IteracionDId::new(val[1], val[3], val[5], val[7]).set_line(val[0].line).set_column(val[0].column)}
             ;

           IO: 'read' 'ident'                                                          {result = ES::new(val[0], val[1]).set_line(val[0].line).set_column(val[0].column)            }
             | 'write' Expresion                                                       {result = ES::new(val[0], val[1]).set_line(val[0].line).set_column(val[0].column)            }
             ;                                                                       
                                                                                     
    Expresion: 'num'                                                                   {result = Entero::new(val[0]).set_line(val[0].line).set_column(val[0].column)                }
             | 'ident'                                                                 {result = Variable::new(val[0]).set_line(val[0].line).set_column(val[0].column)              }
             | Expresion '+' Expresion                                                 {result = Suma::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)          }
             | Expresion '-' Expresion                                                 {result = Resta::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)         }
             | Expresion '*' Expresion                                                 {result = Multiplicacion::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)}
             | Expresion '/' Expresion                                                 {result = Division::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)      }
             | Expresion '%' Expresion                                                 {result = Modulo::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)        }
             | '-' Expresion =UMINUS                                                   {result = Menos_Unario::new(val[1]).set_line(val[0].line).set_column(val[0].column)          }
             | 'true'                                                                  {result = True::new().set_line(val[0].line).set_column(val[0].column)                        }
             | 'false'                                                                 {result = False::new().set_line(val[0].line).set_column(val[0].column)                       }
             | '~' Expresion                                                           {result = Negacion::new(val[1]).set_line(val[0].line).set_column(val[0].column)              }
             | Expresion 'and' Expresion                                               {result = Conjuncion::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)    }
             | Expresion 'or' Expresion                                                {result = Disyuncion::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)    }
             | Expresion '=' Expresion                                                 {result = Igual::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)         }
             | Expresion '/=' Expresion                                                {result = Inequivalencia::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)}
             | Expresion '<' Expresion                                                 {result = Menor::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)         }
             | Expresion '>' Expresion                                                 {result = Mayor::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)         }
             | Expresion '<=' Expresion                                                {result = MenorOIgual::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)   }
             | Expresion '>=' Expresion                                                {result = MayorOIgual::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column)   }
             | '#' Expresion                                                           {result = Inspeccion::new(val[1]).set_line(val[0].line).set_column(val[0].column)            }
             | '(' Expresion ')'                                                       {result = val[1]                             }
             | 'consttape'                                                             {result = ConstructorTape::new(val[0]).set_line(val[0].line).set_column(val[0].column)       }
             | Expresion '&' Expresion                                                 {result = Concatenacion::new(val[0], val[2]).set_line(val[0].line).set_column(val[1].column) }
             ;


---- header ----

require_relative 'Lexer'
require_relative 'Interpreter2'

class SyntacticError < RuntimeError

  def initialize(tok)
    @token = tok
  end

  def to_s
    "Error Sintactico del Token '#{@token.text}' en la linea #{@token.line} y columna #{@token.column}."   
  end
end

---- inner ----

    def on_error(id, token, stack)
      raise SyntacticError::new(token)
    end
   
    def next_token
     token = @lexer.lex_catch
     return [false,false] unless token
     return [token.class,token]
    end
   
    def parse(lexer)
      @yydebug = true
      @lexer = lexer
      @tokens = []
      ast = do_parse
      return ast
    end
