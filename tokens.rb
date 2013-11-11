
###########################
#Enumeracion de los Tokens#
###########################

tokens = {

  'Coma'            =>  /\A,/            ,
  'Punto'           =>  /\A./            , 
  'PuntoYComa'      =>  /\A;/            , 
  'ParAbre'         =>  /\A\(/           , 
  'ParCierra'       =>  /\A\)/           , 
  'CorcheteAbre'    =>  /\A\[/           , 
  'CorcheteCierra'  =>  /\A\]/           , 
  'LlaveAbre'       =>  /\A\{/           , 
  'LlaveCierra'     =>  /\A\}/           , 
  'Type'            =>  /\A\:\:/         , 
  'Menos'           =>  /\A\-/           ,
  'Mas'             =>  /\A\+/           ,
  'Mult'            =>  /\A\*/           , 
  'Div'             =>  /\A\/(?!=)/      , 
  'Mod'             =>  /\A\%/           , 
  'Conjuncion'      =>  /\A\/\\/         , 
  'Disyuncion'      =>  /\A\\\//         , 
  'Negacion'        =>  /\A\~/           , 
  'Menor'           =>  /\A\<(?!=)/      , 
  'MenorIgual'      =>  /\A\<=/          , 
  'Mayor'           =>  /\A\>(?!=)/      , 
  'MayorIgual'      =>  /\A\>=/          , 
  'Igual'           =>  /\A\=/           , 
  'Desigual'        =>  /\A\/=/          , 
  'Concat'          =>  /\A\&/           , 
  'Inspeccion'      =>  /\A\#/           ,
  'Asignacion'      =>  /\A\:=/          ,
  'Ident'           =>  /\A[0-9a-zA-Z_]*/,
  'Num'             =>  /\A[0-9]*/       ,

}

reserved_words = %w(declare execute done read while do if else end)

reserved_words.each do |s|
  tokens[s.capitalize] = /\A#{s}\b/
end

###########################
#Declaracion de las clases#
###########################

class PhraseS

  attr_accessor :text, :line, :column

  def initialize(text, line, column)
    @text = text
    @line = line
    @column = column
  end

  
end

class LexicographError < PhraseS

  def initialize(text, line, column)
    super(text, line, column)
  end

  def to_s
    "Error: Caracter inesperado "#{@text}" en la fila #{@line}, columna #{@column}"
  end

end

class Token < PhraseS

  def initialize(text, line, column,regex)
    super(text, line, column)
    @regex = regex
  end

  def to_s
    "#{self.class.name} #{if self.class.name.eql?(TkIdent) then (" + @text + ") end}"
  end

end

class Lexer

  def initialize(input)
    @tokens = []
    @errors = []
    @input = input
    @line = 0
    @column = 0
  end

  def lex_tokens
    @tokens
  end

  def lex_errors
    @errors
  end

  def lex_ignore(length)
    @input = @input[length..@input.length]
  end

  def lex_catch

    return false if @input.eql?(nil)

    @input.match(/\A\s*/)
    lex_ignore($&.length)

    @input.match(/\A[\w\p{punct}]*\s/)

    if $&.eql?nil
      lex_ignore(1)
    else
      puts "*#{@input[0..($&.length-2)]}"
      lex_ignore($&.length)
    end
  end
end

#######################################
#Declaracion de clases para cada token#
#######################################

tokens.each do |id,regex|

  newclass = Class::new(Token) do

    @regex = regex
    
    def initialize(text, line, column)
      @text = text
      @line = line
      @column = column
    end
  end

  Object::const_set("Tk#{id}", newclass)

end


###############################
#Definicion del Main del Lexer#
###############################

def main
  
  input = File::read(ARGV[0])

  goon = true

  lexer = Lexer::new (input)

  while (goon) do
    goon = lexer.lex_catch
  end
end

main
