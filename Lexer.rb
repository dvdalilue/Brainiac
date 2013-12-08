module Brainiac

  require_relative 'Classs'
  #Clase fundamental que realiza el recorrido de la entrada
  #Diferencia de los tokens y errores
  #Para luego ser impresos en pantalla
  class Lexer
    #Inicializacion con la entrada como Stirng
    def initialize(input)
      @tokens = [] # Arreglo de tokens
      @errors = [] #Arreglo de errores
      @input = input
      @line = 1
      @column = 1
      @comment = 0
    end
    #Ignora la palabra que se analizo o espacios en blanco
    def lex_ignore(length)
      
      return if length.eql?0 #Si no hay nada regresa

      word = @input[0..length] # Se crea un aux de lo que se quiere ignorar
      lineas = (word + ' ').lines.to_a.length.pred #Se saca el numero de lineas, 
      #convirtiendo en arreglo de las palabras separadas \n y midiendolo
      @line += lineas
      @input = @input[length..@input.length] # Se omite la solicitado

      if lineas.eql?0 then
        @column  += length #Se suma las columnas omitidas a las que habia
      else
        @column = 1 #Sino se colocan en 1 por salto de linea
      end
    end
    #Convierte en token la frase
    def tokenize(nphrase)

      nct = LexicographError #Se define una var con el nombre de la clase
      ntt = nphrase         #Consigo el texto para esa clase

      if nphrase =~ /\A\$-.*/
        @comment = 1 #Verifica si es inicio de comentario
      else
        $tokens.each { |key, value|
          if nphrase =~ value       #Sino busca con quien hacer match en las regexp
            nct = "Tk" + "#{key}"
            ntt = $&
            break
          end
        }
        if nct == "TkError"
          nct = LexicographError  #Si hubo match con error se le coloca esta clase
        else      
          nct = Object.const_get(nct)  #Debe buscar la clase en todos los objetos correspondiente al string que se localizo
        end
        newtk = nct.new(ntt,@line,@column) # se crea la nueva instancia de la clase
        if newtk.is_a? LexicographError 
          @errors << newtk  #Si es un error se guarda en este arreglo
        else
          @tokens << newtk #Sino en este, por ser token
          if ntt.length < nphrase.length
            @column  += ntt.length  #Caso especial en el que los tokens estan pegados
            tokenize(nphrase[ntt.length..nphrase.length]) #Se ignora y se tokeniza lo que falta
          end
        end
      end
    end
    #Va agarrando la palabras separadas por espacio o por saltos de linea
    def lex_catch

      return false if @input.eql?(nil) #retorna si la entrada se acabo, con false

      @input.match(/\A(\s)*/) #ignora los espacios y saltos de linea
      lex_ignore($&.length)
      @input.match(/\A[\w\p{punct}]*\s/) #Busca la proxima palabra

      if !$&.eql?nil
        mlength = $&.length 
        if @comment == 0
          tokenize(@input[0..($&.length-2)]) #Se tokeniza si no estamos en comentario
        elsif $& =~ /\A.*-\$/
          @comment = 0 #Si se consigue cierre de comentario, cambiamos el flag
        end
        lex_ignore(mlength) #Ignora la palabra analizada
      end
    end

    def to_s #Dependiendo de si hubo errores o no, cambia la salida
      (if @errors.empty? then @tokens else @errors end).map { |tk| puts tk.to_s }
    end
  end
end
