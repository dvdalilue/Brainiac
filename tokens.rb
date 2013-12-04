
###########################
#Enumeracion de los Tokens#
###########################

$tokens = {

  'Coma'            =>  /\A,/                     ,
  'Punto'           =>  /\A\./                     , 
  'PuntoYComa'      =>  /\A;/                     , 
  'ParAbre'         =>  /\A\(/                    , 
  'ParCierra'       =>  /\A\)/                    , 
  'CorcheteAbre'    =>  /\A\[/                    , 
  'CorcheteCierra'  =>  /\A\]/                    , 
  'LlaveAbre'       =>  /\A\{/                    , 
  'LlaveCierra'     =>  /\A\}/                    , 
  'Type'            =>  /\A\:\:/                  , 
  'Menos'           =>  /\A\-/                    ,
  'Mas'             =>  /\A\+/                    ,
  'Mult'            =>  /\A\*/                    , 
  'Div'             =>  /\A\/(?!=)/               , 
  'Mod'             =>  /\A\%/                    , 
  'Conjuncion'      =>  /\A\/\\/                  , 
  'Disyuncion'      =>  /\A\\\//                  , 
  'Negacion'        =>  /\A\~/                    , 
  'Menor'           =>  /\A\<(?!=)/               , 
  'MenorIgual'      =>  /\A\<=/                   , 
  'Mayor'           =>  /\A\>(?!=)/               , 
  'MayorIgual'      =>  /\A\>=/                   , 
  'Igual'           =>  /\A\=/                    , 
  'Desigual'        =>  /\A\/=/                   , 
  'Concat'          =>  /\A\&/                    , 
  'Inspeccion'      =>  /\A\#/                    ,
  'Asignacion'      =>  /\A\:=/                   ,
  'Ident'           =>  /\A[a-zA-Z_][0-9a-zA-Z_]*/,
  'Num'             =>  /\A[0-9]*/                ,
  'Cinta'           =>  /\A\{[+-<>.,]*}/          ,

}

reserved_words = %w(declare execute done read while do if else end at tape to)

reserved_words.each do |s|
  $tokens[s.capitalize] = /\A#{s}\b/
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

  class << self
    attr_accessor :regex
  end

  #attr_accessor :line, :column

  def to_s
    "#{self.class.name}#{if self.class.name.eql?("TkIdent") then "(\"#{@text}\")" end}#{if self.class.name.eql?("TkNum") then "(#{@text})" end} "
  end
end

class Lexer

  def initialize(input)
    @tokens = []
    @errors = []
    @input = input
    @line = 1
    @column = 1
    @comment = 0
  end

  def lex_tokens
    @tokens
  end

  def lex_errors
    @errors
  end

  def lex_ignore(length)
    @input = @input[length..@input.length]
    @column += length
  end

  def lookclass(xclass)
    return Object.const_get(xclass)
  end

  def tokenize(somephrase, length)

    newclasstk = LexicographError
    newtoktext = somephrase

    if $tokens.has_key?(somephrase.capitalize)
      newclasstk = "Tk" + "#{somephrase.capitalize}"
    elsif somephrase =~ /\A\$-.*/
      @comment = 1
      newclasstk = "comment"
    else
      $tokens.each { |key, value|
        if @input =~ value
          newclasstk = "Tk" + "#{key}"
          newtoktext = $& #Previous match
          break
        end
      }
    end

    if @comment == 0
      if newclasstk == LexicographError 
        puts "Error lexicografico -- #{somephrase}"
      end
      
      newclasstk = lookclass(newclasstk)
      newtk = newclasstk.new(newtoktext,@line,@colunm)
      
      if newtk.is_a? LexicographError
        @errors << newtk
      else
        @tokens << newtk
      end  
    end
  end

  def lex_catch

    return false if @input.eql?(nil)

    @input.match(/\A\s*/)
    lex_ignore($&.length)

    @input.match(/\A[\w\p{punct}]*\s/)

    if $&.eql?nil
      lex_ignore(1)
      @line += 1
    else
      mlength = $&.length
      if @comment == 0
        tokenize(@input[0..($&.length-2)],$&.length-2)
      else
        if $& =~ /\A\.*\-\$/
          @comment = 0
        end
      end
      lex_ignore(mlength)
    end
  end

  def to_s
    (if !@errors.eql?(nil) then @tokens else @errors end).map { |tk| puts tk.inspect }
  end
end

#######################################
#Declaracion de clases para cada token#
#######################################

$tokens.each do |id,regex|

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

  lexer.to_s
end

main
