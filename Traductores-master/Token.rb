#Gabriela Limonta 10-10385
#John Delgado 10-10196

require 'Type'
require 'Ubicacion'

# Un objeto de texto es una generalización de un fragmento textual en una posición
# determinada de un texto. Instancias de esta idea son los errores lexicográficos y los tokens.
class ObjetoDeTexto
  attr_accessor :linea, :columna, :texto

  # Se encarga de asignar el inicio del objeto de texto como una ubicación
  def inicio
    Ubicacion::new(@linea, @columna)
  end

  # Se encarga de asignar el final del objeto de texto como una ubicación
  def final
    # El final sera el mismo inicio si la longitud es cero
    return self.inicio if texto.length.zero?

    # Se actualizan las líneas y columnas que abarca el objeto de texto y finalmente se crea la nueva ubicación
    lineas = (texto + ' ').lines.to_a.length.pred

    if lineas.zero? then
      Ubicacion::new(linea, columna + texto.length)
    else
      texto =~ /\n(.*)\z/
      Ubicacion::new(linea + lineas, 1 + $1.lenght)
    end
  end
end

# Un error lexicográfico es un objeto que guarda la posición de un error en un contexto
# del programa
class ErrorLexicografico < Exception
  # Se encarga de inicializar un error lexicografico indicandole
  # en que posicion está y por que texto está conformado
  def initialize(linea, columna, texto)
    @linea   = linea
    @columna = columna
    @texto   = texto
  end

  # Se encarga de pasar el error lexicográfico a string para imprimir
  # en pantalla.
  def to_s
    "Error: caracter inesperado \"#{@texto}\" en línea #{@linea}, columna #{@columna}."
  end
end

# La clase token es un objeto de texto que ademas de tener un contexto
# tiene una expresión regular que permite identificar al token dentro
# del contexto mayor
class Token < ObjetoDeTexto
  # Queremos que el campo regex sea una variable de la clase y no de cada subclase
  # en particular de Token por lo que declaramos regex en la clase singleton de Token
  class << self #Clase singleton
    attr_accessor :regex
  end

  attr_accessor :linea, :columna
end

# Se define un diccionario que contiene las expresiones regulares para cada
# token existente.
tokens = {
  'AbreParentesis'    => /\A\(/                      ,
  'CierraParentesis'  => /\A\)/                      ,
  'Coma'              => /\A,/                       ,
  'Desigual'          => /\A\/=/                     ,
  'Division'          => /\A\/(?!=)/                 ,
  'DosPuntos'         => /\A\.\./                    ,
  'Flecha'            => /\A->/                      ,
  'Id'                => /\A([a-zA-Z_][a-z0-9A-Z_]*)/,
  'Igual'             => /\A==/                      ,
  'Interseccion'      => /\A<>/                      ,
  'MayorIgualQue'     => /\A>=/                      ,
  'MayorQue'          => /\A>(?![=>])/               ,
  'MenorIgualQue'     => /\A<=/                      ,
  'MenorQue'          => /\A<(?![=>])/               ,
  'Modulo'            => /\A%/                       ,
  'Por'               => /\A\*/                      ,
  'Num'               => /\A[0-9]+/                  ,
  'Pertenece'         => /\A>>/                      ,
  'PuntoYComa'        => /\A;/                       ,
  'Resta'             => /\A-(?!>)/                  ,
  'String'            => /\A"([^"\\]|\\[n\\"])*"/    ,
  'Mas'               => /\A\+/                      ,
  'Asignacion'        => /\A=(?!=)/                  ,
}

# Se definen las palabras reservadas.
reserved_words = %w(and as begin bool bottom case declare do else end false for if in int length not of or program range read rtoi then top true while write writeln)

# Guardamos aqui dentro del diccionario de tokens las expresiones para las palabras reservadas.
reserved_words.each do |w|
  tokens[w.capitalize] = /\A#{w}\b/
end

# Para cada token vamos creando las nuevas subclases para cada token.
tokens.each do |name, regex|
  clase = Class::new(Token) do
    #Asignamos la expresion regular
    @regex = regex

    # Se encarga de inicializar el token en el contexto.
    def initialize(linea, columna, texto)
      @linea   = linea
      @columna = columna
      @texto   = texto
    end
  end

  # Le damos nombre a la nueva sub clase creada
  Object::const_set "Tk#{name}", clase
end

# Creamos un arreglo de tokens cuyos elementos del arreglo son las
# subclases para cada token.
$tokens = []
ObjectSpace.each_object(Class) do |o|
  $tokens << o if o.ancestors.include? Token and o != TkId and o != Token
end

#Modificamos la clase Token para facilitar la impresión del AST.
class Token
  # Para la mayoria de los tokens el texto que contienen será nulo
  # excepciones de esto son TkId, TkString y TkNum donde se guarda
  # el valor del token.
  def text
    ''
  end

  # Se encarga de pasar el token a string para que imprima por pantalla.
  def to_s
    "#{self.class.name} #{text}(Línea #{@linea}, Columna #{@columna})"
  end

  # Se encarga de pasar el token a string para que pueda imprimirse por
  # pantalla en el AST con la identación adecuada.
  # devuelve el texto del token.
  def to_string(profundidad)
    @texto
  end
end

# Modificamos la clase TkString para agregar el metodo text
class TkString
  # Se encarga de devolver el texto del string mas un espacio en blanco
  # para mayor legibilidad al imprimirlo en pantalla.
  def text
    @texto + ' '
  end
end

# Modificamos la clase TkId para agregar el metodo text
class TkId
  # Se encarga de devolver el texto del identificador mas un espacio en blanco
  # para mayor legibilidad al imprimirlo en pantalla.
  def text
    @texto.inspect + ' '
  end
end

# Modificamos la clase TkNum para agregar el metodo text
class TkNum
  # Se encarga de devolver el numero como texto mas un espacio en blanco
  # para mayor legibilidad al imprimirlo en pantalla.
  def text
    @texto.inspect + ' '
  end
end

# Modificamos la clase Array para agregar un metodo to_string que permita imprimir listas
# con identación adecuada al resto del formato de salida.
class Array
  # Se encarga de construir un string con la lista para imprimirlo por pantalla.
  def to_string(profundidad)
    inject('') do |acum, objeto|
      acum + "\n" + '  '*profundidad + '- ' + objeto.to_string(profundidad.succ).sub(/\A[\n ]*/, '')
    end
  end

  # Se encarga de retornar la ubicación de inicio de un array
  def inicio
    return nil if self.empty?
    self.first.inicio
  end

  # Se encarga de retornar la ubicación final de un array
  def final
    return nil if self.empty?
    self.last.final
  end
end

# Se agregan nuevos metodos to_type para los tipos del lenguaje, esto devuelve el tipo de dato correspondiente
class TkInt  ; def to_type; Rangex::Int  ; end; end
class TkBool ; def to_type; Rangex::Bool ; end; end
class TkRange; def to_type; Rangex::Range; end; end
