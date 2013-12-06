#Gabriela Limonta 10-10385
#John Delgado 10-10196

require 'Token'
require 'Ubicacion'

class LexerException < RuntimeError
  attr_reader :lexer

  def initialize(lexer)
    @lexer = lexer
  end
end

# Clase Lexer que guarda la lista de tokens reconodicos, errores encontrados
# de cierta entrada y la posicion actual (fila, columna)
class Lexer
  attr_reader :tokens, :errores

  def to_exception
    LexerException::new self
  end

  # Se encarga de inicializar el lexer en el string de entrada dado.
  def initialize(entrada)
    @tokens  = []
    @errores = []
    @entrada = entrada
    @linea   = 1
    @columna = 1
  end

  # Se encarga de consumir el string de entrada en cierta longitud.
  def consume(longitud)
    # Si la longitud es cero retornamos nil
    return if longitud.zero?

    # Guardamos los n primeros caracteres.
    consumido = @entrada[0, longitud]
    # Guardamos el numero de saltos de lineas encontrados
    lineas    = (consumido + ' ').lines.to_a.length.pred
    # y se lo sumamos a la cantidad de lineas del lexer
    @linea    += lineas
    # la entrada ahora será la cola desde la longitud dada hasta
    # la longitud original de la entrada
    @entrada  = @entrada[longitud, @entrada.length]

    # Si la cantidad de lineas es cero entonces aumentamos
    # el valor de columna tanto como longitud sea dada
    if lineas.zero? then
      @columna  += longitud
    else
      # sino agregamos la cantidad pertinente a columna.
      consumido =~ /\n(.*)\z/
      @columna  = 1 + $1.length
    end
  end

  # Se encarga de reconocer que token hace match con la entrada del lexer.
  def yylex
    # Buscamos los espacios en blanco y los consumimos
    @entrada =~ /\A(\s|\n|\/\/.*)*/
    consume($&.length)

    # Si la entrada esta vacia retornamos nil
    return nil if @entrada.empty?

    # Creamos por defecto una clase Error Lexicográfico
    new_token_class = ErrorLexicografico
    new_token_text  = @entrada[0].chr

    # Para cada tipo de token vamos a revisar a ver si sus expresiones
    # regulares hacen match
    $tokens.each do |token|
      if @entrada =~ token.regex then
        # Si tenemos un hit entonces cambiamos la clase por defecto que
        # habiamos creado como error y le ponemos como texto lo leido en entrada.
        new_token_class = token
        new_token_text  = $&
        break
      end
    end

    # Si no hicimos match con ningun token anteriormente procedemos a revisar el
    # caso especial del tokenID en caso de tener un hit cambiamos la clase a TkId
    if new_token_class == ErrorLexicografico and @entrada =~ TkId.regex then
      new_token_class = TkId
      new_token_text  = $&
    end

    # Creamos el nuevo token
    new_token = new_token_class.new(@linea, @columna, new_token_text)

    # Consumimos la longitud del texto que hizo match
    consume(new_token_text.length)

    # Si el nuevo token es un error lexicografico lo agregamos a la lista de
    # errores y si no lo es lo agregamos a la lista de tokens reconocidos.
    if new_token.is_a? ErrorLexicografico then
      @errores << new_token
      raise new_token
    else
      @tokens << new_token
      return new_token
    end
  end

  # Se encarga de crear el string de salida con los to_s de cada token para imprimir el estado
  # del lexer. Si hay errores imprime estos solamente, si no hay errores imprime los tokens reconocidos.
  def to_s
    (if @errores.empty? then @tokens else @errores end).map { |token| token.to_s }.join "\n"
  end
end
