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

     Programa: Alcance                                                                 {result = Programa::new(val[0])}
             ;                                                                         
                                                                                       
      Alcance: 'declare' Declaracion 'execute' Instruccion 'done'                      {result = Alcance::new(val[1], val[3])}
             | 'execute' Instruccion 'done'                                            {result = Alcance::new([], val[1])}
             ;

  Declaracion: ListaDecla                                                              {result = Declaraciones::new(val[0])}
             ;                                                                         
                                                                                       
   ListaDecla: Declare                                                                 {result = [val[0]]}
             | Declare ';' ListaDecla                                                  {result = [val[0]] + val[2]}
             ;                                                                         
                                                                                       
      Declare: ListaIdent '::' Tipo                                                    {result = Declaracion::new(val[0], val[2])}
             ;                                                                         
                                                                                       
   ListaIdent: 'ident'                                                                 {result = [Variable::new(val[0])]}
             | 'ident' ',' ListaIdent                                                  {result = [Variable::new(val[0])] + val[2]}
             ;                                                                         
                                                                                       
         Tipo: 'boolean'                                                               {result = val[0]}
             | 'integer'                                                               {result = val[0]}
             | 'tape'                                                                  {result = val[0]}
             ;                                                                         
                                                                                       
  Instruccion: ListaInstr                                                              {result = Instrucciones::new(val[0])}
             ;                                                                         
                                                                                       
   ListaInstr: Instruc                                                                 {result = [val[0]]}
             | Instruc ';' ListaInstr                                                  {result = [val[0]] + val[2]}
             ;                                                                         
                                                                                       
      Instruc: 'ident' ':=' Expresion                                                  {result = Asignacion::new(val[0], val[2])}
             | Condicional                                                             {result = val[0]}
             | 'while' Expresion 'do' Instruccion 'done'                               {result = IteracionI::new(val[1], val[3])}
             | 'cinta' 'at' Expresion                                                  {result = Ejecucion::new(val[0], val[2])}
             | IteracionD                                                              {result = val[0]}
             | IO                                                                      {result = val[0]}
             | Alcance                                                                 {result = SecInterna::new(val[0])}
             ;

  Condicional: 'if' Expresion 'then' Instruccion 'done'                                {result = CondicionalIf::new(val[1], val[3])}
             | 'if' Expresion 'then' Instruccion 'else' Instruccion 'done'             {result = CondicionalElse::new(val[1], val[3], val[5])}
             ;

   IteracionD: 'for' Expresion 'to' Expresion 'do' Instruccion 'done'                  {result = IteracionDExpA::new(val[1], val[3], val[5])}
             | 'for' 'ident' 'from' Expresion 'to' Expresion 'do' Instruccion 'done'   {result = IteracionDId::new(val[1], val[3], val[5], val[7])}
             ;

           IO: 'read' 'ident'                                                          {result = ES::new(val[0], val[1])}
             | 'write' Expresion                                                       {result = ES::new(val[0], val[1])}
             ;                                                                       
                                                                                     
    Expresion: 'num'                                                                   {result = Entero::new(val[0])}
             | 'ident'                                                                 {result = Variable::new(val[0])}
             | Expresion '+' Expresion                                                 {result = Suma::new(val[0], val[2])}
             | Expresion '-' Expresion                                                 {result = Resta::new(val[0], val[2])}
             | Expresion '*' Expresion                                                 {result = Multiplicacion::new(val[0], val[2])}
             | Expresion '/' Expresion                                                 {result = Division::new(val[0], val[2])}
             | Expresion '%' Expresion                                                 {result = Modulo::new(val[0], val[2])}
             | '-' Expresion =UMINUS                                                   {result = Menos_Unario::new(val[1])}
             | 'true'                                                                  {result = True::new()}
             | 'false'                                                                 {result = False::new()}
             | '~' Expresion                                                           {result = Negacion::new(val[1])}
             | Expresion 'and' Expresion                                               {result = Conjuncion::new(val[0], val[2])}
             | Expresion 'or' Expresion                                                {result = Disyuncion::new(val[0], val[2])}
             | Expresion '=' Expresion                                                 {result = Igual::new(val[0], val[2])}
             | Expresion '/=' Expresion                                                {result = Inequevalencia::new(val[0], val[2])}
             | Expresion '<' Expresion                                                 {result = Menor::new(val[0], val[2])}
             | Expresion '>' Expresion                                                 {result = Mayor::new(val[0], val[2])}
             | Expresion '<=' Expresion                                                {result = MenorOIgual::new(val[0], val[2])}
             | Expresion '>=' Expresion                                                {result = MayorOIgual::new(val[0], val[2])}
             | '#' Expresion                                                           {result = Inspeccion::new(val[1])}
             | '(' Expresion ')'                                                       {result = val[1]}
             | 'consttape'                                                             {result = val[0]}
             | Expresion '&' Expresion                                                 {result = Concatenacion::new(val[0], val[2])}
             ;


---- header ----

require_relative 'Lexer'
require_relative 'AST'

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
      begin
        ast = do_parse
        return ast
      rescue LexicographError => e
        puts e
      end
    end
