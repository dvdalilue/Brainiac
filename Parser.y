class parser

token 
',' '.' ';' '(' ')' '::' '/=' '/\' 'declare' 'execute' 'from' 'consttape'
'-' '+' '*' ']' '{' '<=' '>=' ':=' 'done' 'read' 'tape' 'write' 'cinta'
'%' '~' '<' '>' '=' 'to' 'do' 'if' 'true' 'false' 'else' 'while' 'ident'
'/' '&' '#' '}' '[' 'at' '\/' 'end' 'integer' 'boolean' UMINUS 'num'

prechigh
  right 'at'
  right '~' '#'
  nonassoc UMINUS
  left '*' '/' '%'
  left '+' '-'
  left '&'
  nonassoc '<' '>' '<=' '>='
  nonassoc '=' '/='
  nonassoc '/\'
  nonassoc '\/'
  nonassoc ':=' '::'
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
  'end'       'TkEnd'
  'from'      'TkFrom'
  'at'        'TkAt'
  'tape'      'TkTape'
  'to'        'TkTo'
  'true'      'TkTrue'
  'fasle'     'TkFalse'
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
  '/\'        'TkConjuncion'             
  '\/'        'TkDisyuncion'             
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

     Programa: Alcance {puts 'Programa'}
             ;

      Alcance: 'declare' Declaracion 'execute' Intruccion 'done' {puts 'Programa'}
             | 'execute' Intruccion 'done' {puts 'Programa'}
             ;

  Declaracion: ListaIdent '::' Tipo {puts 'Programa'}
             | Declaracion ';' Declaracion {puts 'Programa'}
             ;

   ListaIdent: 'ident' {puts 'Programa'}
             | ListaIdent ',' ListaIdent {puts 'Programa'}
             ;

         Tipo: 'boolean' {puts 'Programa'}
             | 'integer' {puts 'Programa'}
             | 'tape' {puts 'Programa'}
             ;

   Intruccion: 'ident' ':=' Expresion {puts 'Programa'}
             | Condicional {puts 'Programa'}
             | 'while' ExpresionB 'do' Instruccion 'done' {puts 'Programa'}
             | IteracionD {puts 'Programa'}
             | IO {puts 'Programa'}
             | Alcance {puts 'Programa'}
             | Instruccion ';' Instruccion {puts 'Programa'}
             ;

  Condicional: 'if' ExpresionB 'then' Instruccion 'done' {puts 'Programa'}
             | 'if' ExpresionB 'then' Instruccion 'else' Instruccion 'done' {puts 'Programa'}
             ;

   IteracionD: 'for' ExpresionA 'to' ExpresionA 'do' Instruccion 'done' {puts 'Programa'}
             | 'for' 'ident' 'from' ExpresionA 'to' ExpresionA 'do' Instruccion 'done' {puts 'Programa'}
             ;

           IO: 'read' 'ident' {puts 'Programa'}
             | 'write' Expresion {puts 'Programa'}
             ;

    Expresion: ExpresionA {puts 'Programa'}
             | ExpresionB {puts 'Programa'}
             | ExpresionC {puts 'Programa'}
             ;

   ExpresionA: 'num' {puts 'Programa'}
             | 'ident' {puts 'Programa'}
             | ExpresionA '+' ExpresionA {puts 'Programa'}
             | ExpresionA '-' ExpresionA {puts 'Programa'}
             | ExpresionA '*' ExpresionA {puts 'Programa'}
             | ExpresionA '/' ExpresionA {puts 'Programa'}
             | ExpresionA '%' ExpresionA {puts 'Programa'}
             | '-' ExpresionA = UMINUS {puts 'Programa'}
             | '(' ExpresionA ')' {puts 'Programa'}
             ;

   ExpresionB: 'true' {puts 'Programa'}
             | 'false' {puts 'Programa'}
             | 'ident' {puts 'Programa'}
             | '~' ExpresionB  {puts 'Programa'}
             | ExpresionB '/\' ExpresionB {puts 'Programa'}
             | ExpresionB '\/' ExpresionB {puts 'Programa'}
             | ExpresionB '=' ExpresionB {puts 'Programa'}
             | ExpresionB '/=' ExpresionB {puts 'Programa'}
             | ExpresionA '<' ExpresionA {puts 'Programa'}
             | ExpresionA '>' ExpresionA {puts 'Programa'}
             | ExpresionA '<=' ExpresionA {puts 'Programa'}
             | ExpresionA '>=' ExpresionA {puts 'Programa'}
             | ExpresionA '=' ExpresionA {puts 'Programa'}
             | ExpresionA '/=' ExpresionA {puts 'Programa'}
             | '(' ExpresionB ')' {puts 'Programa'}
             ;

   ExpresionC: '#' Tape {puts 'Programa'}
             | '#' 'consttape'  {puts 'Programa'}
             | Tape {puts 'Programa'}
             ;

         Tape: 'ident' {puts 'Programa'}
             | 'cinta' 'at' Tape {puts 'Programa'}
             | Tape '&' Tape {puts 'Programa'}
             | Tape '&' 'consttape' {puts 'Programa'}
             | 'consttape' '&' Tape {puts 'Programa'}
             | '(' Tape ')' {puts 'Programa'}
             ;

---- header

require_relative 'Lexer'
#require_relative 'AST'

module Brainiac
class SyntacticError < RunTimeError

def iniatialize(tk)
@tk = tk
end

def to_s
  "Error Sintactico del Token #{@tk.inspect} en la linea #{@tk.linea} y columna #{@tk.columna}"   
end
end
end

---- inner

def next_token
  token = @lexer.lex_catch
  return [false,false] unless token
  return [token.class,token]
end

def parse(lexer)
  @yydebug = true
  @lexer = lexer
  

end
