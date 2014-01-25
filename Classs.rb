###########################
#Declaracion de las clases#
###########################

require_relative 'Tokens'
#Clase general para guardar un texto, linea y columna
class PhraseS

  attr_accessor :text, :line, :column # Puede ser leido y escribir en ellos

  def initialize(text, line, column)
    @text = text
    @line = line
    @column = column
  end
end
# Clase de error lexicografico con todo de la PhraseS

class LexicographError < PhraseS

  def to_s #Salida especial del enunciado
    "Error: Caracter inesperado \"#{@text}\" en la fila #{@line}, columna #{@column}"
  end
end

#Clase para Token con todo de PhraseS

class Token < PhraseS

  class << self
    attr_accessor :regex #Esta seccion es para que la clase "redefinir la clase" 
  end                   #Se conoce como sigleton

  def to_s #Salida especificada
    "#{self.class.name}#{if self.class.name.eql?("TkIdent") then "(\"#{@text}\")" end}#{if self.class.name.eql?("TkNum") then "(#{@text})" end} "
  end

  def self.name_tk
    return self.name.sub(/Tk/, '')
  end
end

#######################################
#Declaracion de clases para cada token#
#######################################

#Creacion de clases de manera dinamica para cada token

$tokens.each do |id,regex|

  newclass = Class::new(Token) do #Creacion dinamica "Magic"

    @regex = regex #Se le asigna la regexp respectiva a la clase
    
    def initialize(text, line, column)
      @text = text
      @line = line
      @column = column
    end
  end
  Object::const_set("Tk#{id}", newclass) #Se renombra la clase como Tk<nombre>
end
