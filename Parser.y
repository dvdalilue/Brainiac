#Parser

class Parser

  token ',' ';' '(' ')' '-' '::' '/='  '+' '.' '*' ']' '{' '<=' 
        '>=' ':=' 'and' 'done' 'read' 'tape' 'write' 'cinta' '%' '~' 
        '<' '>' '=' 'to' 'do' 'if' 'true' 'false' 'else' 'while' 
        'or' 'ident' '/' '&' '#' '}' '[' 'at' 'end' 'integer' 
        'boolean' 'num' 'declare' 'execute' 'from' 'consttape' 
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

     Programa: Alcance                                                                 {result = ASTPrograma::new(val[0])}
             ;                                                                         
                                                                                       
      Alcance: 'declare' Declaracion 'execute' Instruccion 'done'                      {result = ASTAlcance::new(val[1], val[3])}
             | 'execute' Instruccion 'done'                                            {result = ASTAlcance::new([], val[0])}
             ;

  Declaracion: ListaDecla                                                              {result = ASTDeclaraciones::new(val[0])}
             ;                                                                         
                                                                                       
   ListaDecla: Declare                                                                 {result = [val[0]]}
             | Declare ';' ListaDecla                                                  {result = [val[0]] + val[2]}
             ;                                                                         
                                                                                       
      Declare: ListaIdent '::' Tipo                                                    {result = ASTDeclaracion::new(val[0], val[2])}
             ;                                                                         
                                                                                       
   ListaIdent: 'ident'                                                                 {result = [ASTExpresionVariable::new(val[0])]}
             | 'ident' ',' ListaIdent                                                  {result = [ASTExpresionVariable::new(val[0])] + val[2]}
             ;                                                                         
                                                                                       
         Tipo: 'boolean'                                                               {result = val[0]}
             | 'integer'                                                               {result = val[0]}
             | 'tape'                                                                  {result = val[0]}
             ;                                                                         
                                                                                       
  Instruccion: ListaInstr                                                              {result = ASTInstrucciones::new(val[0])}
             ;                                                                         
                                                                                       
   ListaInstr: Instruc                                                                 {result = [val[0]]}
             | Instruc ';' ListaInstr                                                  {result = [val[0]] + val[2]}
             ;                                                                         
                                                                                       
      Instruc: 'ident' ':=' Expresion                                                  {result = ASTInstruccionAsignacion::new(val[0], val[2])}
             | Condicional                                                             {result = val[0]}
             | 'while' Expresion 'do' Instruccion 'done'                               {result = ASTInstruccionIteracionI::new(val[1], val[3])}
             | IteracionD                                                              {result = val[0]}
             | IO                                                                      {result = val[0]}
             | Alcance                                                                 {result = val[0]}
             ;

  Condicional: 'if' Expresion 'then' Instruccion 'done'                                {result = ASTInstruccionCondicionalIf::new(val[1], val[3])}
             | 'if' Expresion 'then' Instruccion 'else' Instruccion 'done'             {result = ASTInstruccionCondicionalElse::new(val[1], val[3], val[5])}
             ;

   IteracionD: 'for' Expresion 'to' Expresion 'do' Instruccion 'done'                  {result = ASTInstruccionIteracionDExpA::new(val[1], val[3], val[5])}
             | 'for' 'ident' 'from' Expresion 'to' Expresion 'do' Instruccion 'done'   {result = ASTInstruccionIteracionDId::new(val[1], val[3], val[5], val[7])}
             ;

           IO: 'read' 'ident'                                                          {result = ASTInstruccionIO::new(val[0], val[1])}
             | 'write' Expresion                                                       {result = ASTInstruccionIO::new(val[0], val[1])}
             ;                                                                       
                                                                                     
    Expresion: 'num'                                                                   {result = ASTExpresionEntero::new(val[0])}
             | 'ident'                                                                 {result = ASTExpresionVariable::new(val[0])}
             | Expresion '+' Expresion                                                 {result = ASTExpresionSuma::new(val[0], val[2])}
             | Expresion '-' Expresion                                                 {result = ASTExpresionResta::new(val[0], val[2])}
             | Expresion '*' Expresion                                                 {result = ASTExpresionMultiplicacion::new(val[0], val[2])}
             | Expresion '/' Expresion                                                 {result = ASTExpresionDivision::new(val[0], val[2])}
             | Expresion '%' Expresion                                                 {result = ASTExpresionModulo::new(val[0], val[2])}
             | '-' Expresion =UMINUS                                                   {result = ASTExpresionMenos_Unario::new(val[1])}
             | 'true'                                                                  {result = ASTExpresionTrue::new}
             | 'false'                                                                 {result = ASTExpresionFalse::new}
             | '~' Expresion                                                           {result = ASTExpresionNegacion::new(val[1])}
             | Expresion 'and' Expresion                                               {result = ASTExpresionConjuncion::new(val[0], val[2])}
             | Expresion 'or' Expresion                                                {result = ASTExpresionDisyuncion::new(val[0], val[2])}
             | Expresion '=' Expresion                                                 {result = ASTExpresionIgual::new(val[0], val[2])}
             | Expresion '/=' Expresion                                                {result = ASTExpresionInequivalencia::new(val[0], val[2])}
             | Expresion '<' Expresion                                                 {result = ASTExpresionMenor::new(val[0], val[2])}
             | Expresion '>' Expresion                                                 {result = ASTExpresionMayor::new(val[0], val[2])}
             | Expresion '<=' Expresion                                                {result = ASTExpresionMenorOIgual::new(val[0], val[2])}
             | Expresion '>=' Expresion                                                {result = ASTExpresionMayorOIgual::new(val[0], val[2])}
             | '#' Expresion                                                           {result = ASTExpresionInspeccion::new(val[1])}
             | '(' Expresion ')'                                                       {result = val[1]}
             | 'consttape'                                                             {result = val[0]}
             | 'cinta' 'at' Expresion                                                  {result = ASTExpresionEjecucion::new(val[0], val[2])}
             | Expresion '&' Expresion                                                 {result = ASTExpresionConcatenacion::new(val[0], val[2])}
             ;


---- header ----

require_relative 'Lexer'
require_relative 'AST'

class SyntacticError < RuntimeError

  def initialize(tok)
    @token = tok
  end

  def to_s
    "Error Sintactico del Token ' #{@token.text} ' en la linea #{@token.line} y columna #{@token.column}."   
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
      rescue LexicographError => error
      
        goon = true
        
        while (goon) do
          goon = @lexer.lex_catch #Se van racogiendo la palabras hasta que diga false
        end
        lexer.to_s #Salida por pantalla como se especifico
      end
      return ast
    end
