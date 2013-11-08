

class FraseS

  attr_accessor :text, :line, :column

  def initialize(text, line, column)
    @text = text
    @line = line
    @column = column
  end

  
end

class ErrorLexicos < FraseS

  def to_s
    "Error: Caracter inesperado "#{@text}" en la fila #{@line}, columna #{@column}"
  end

end


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
  'Id'              =>  /\A[0-9a-zA-Z_]*/,

}

reserved_words = %w(declare execute done read while do if else end)

reserved_words.each do |s|
  tokens[s.capitalize] = /\A#{s}\b/
end

def main
  
  input = File::read(ARGV[0])
  
  puts input

end

main
