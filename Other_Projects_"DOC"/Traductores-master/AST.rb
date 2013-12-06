#Gabriela Limonta 10-10385
#John Delgado 10-10196
module Rangex; end

require 'Type'
require 'SymTable'
require 'Ubicacion'

# Se crea una nueva clase que engloba a todos los errores de contexto
class ContextError < RuntimeError
end

# Se crea un error de tipo para cuando los tipos de una operación no son adecuados, con su to_s correspondiente para ser impreso en pantalla.
class ErrorDeTipo < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final, la operación donde ocurrió el error
  # y los tipos que habían en el operando izquierdo y derecho.
  def initialize(inicio, final, operacion, tipo_izq, tipo_der)
    @inicio = inicio
    @final = final
    @operacion = operacion
    @tipo_izq = tipo_izq
    @tipo_der = tipo_der
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error (línea y columna de inicio y final), la operación y los tipos.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: se intenta hacer la operacion #{@operacion} entre operandos de tipos \"#{@tipo_izq}\" y \"#{@tipo_der}\""
  end
end

# Se crea un error de tipo unario para cuando el tipo de una operación unaria no es adecuado, con su to_s correspondiente para ser impreso en pantalla.
class ErrorDeTipoUnario < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final, la operación donde ocurrió el error
  # y el tipo que habia en el operando.
  def initialize(incio, final, operacion, tipo)
    @inicio = inicio
    @final = final
    @operacion = operacion
    @tipo = tipo
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error (línea y columna de inicio y final), la operación y el tipo del operando.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: se intenta hacer la operacion #{@operacion} a un operando de tipo \"#{@tipo}\""
  end
end

# Se crea un error de no declaración de variable para cuando se intenta utilizar una variable que no ha sido declarada anteriormente.
class NoDeclarada < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final y el nombre de la variable que no fue declarada.
  def initialize(inicio, final, nombre)
    @inicio = inicio
    @final = final
    @nombre = nombre
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error (línea y columna de inicio y final) y el nombre de la variable que no fue declarada.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: la variable \"#{@nombre}\" no se encuentra declarada"
  end
end

# Se crea un error de tipo para las funciones, se utiliza cuando se le pasa un operando con tipo incorrecto a alguna de las funciones del lenguaje.
class ErrorDeTipoFuncion < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final, el nombre de la función y el tipo del operando
  def initialize(inicio, final, nombre_funcion,tipo)
    @inicio = inicio
    @final = final
    @nombre_funcion = nombre_funcion
    @tipo = tipo
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error (línea y columna de inicio y final), el nombre de la función, el tipo recibido y el tipo esperado.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la linea #{@final.linea}, columna #{@final.columna}: el argumento de la #{@nombre_funcion} es de tipo \"#{@tipo}\" y se esperaba tipo \"Range\""
  end
end

# Se crea un error para cuando se intenta modificar la variable de un for.
class ErrorModificarIteracion < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final y el nombre de la variable que se intentó modificar.
  def initialize(inicio, final, nombre)
    @inicio = inicio
    @final = final
    @nombre = nombre
  end

  # Se define el to_s correspondiente que imprime le rango donde ocurre el error (línea y columna de inicio y final) y el nombre de la variable que se intenta modificar.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la linea #{@final.linea}, columna #{@final.columna}: se intenta modificar la variable \"#{@nombre}\" que pertenece a una iteración"
  end
end

# Se crea un error para cuando se intenta hacer una asignación entre una variable y una expresión de tipos distintos.
class ErrorDeTipoAsignacion < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final, el tipo de la expresión, el nombre de la variable y el tipo de la variable.
  def initialize(inicio, final, tipo_asig, nombre, tipo_var)
    @inicio = inicio
    @final = final
    @tipo_asig = tipo_asig
    @nombre = nombre
    @tipo_var = tipo_var
  end

  # Se define el to_s correspondiente que imprime le rango donde ocurre el error (línea y columna de inicio y final), el tipo de la expresión, el nombre de la variable y el tipo de la misma.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la linea #{@final.linea}, columna #{@final.columna}: se intenta asignar algo del tipo \"#{@tipo_asig}\" a la variable \"#{@nombre}\" de tipo \"#{@tipo_var}\""
  end
end

# Se crea un error para cuando la condicion de un condicional es de tipo distinto a booleano.
class ErrorCondicionCondicional < ContextError
  def initialize(inicio, final, tipo)
  # Se encarga de inicializar con la ubicación de inicio y final y el tipo de la condición.
    @inicio = inicio
    @final = final
    @tipo = tipo
  end

  # Se define el to_s correspondiente que imprime le rango donde ocurre el error (línea y columna de inicio y final) y el tipo de la condición.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la linea #{@final.linea}, columna #{@final.columna}: la condición es de tipo \"#{@tipo}\""
  end
end

# Se crea un error para cuando la expresión de un case es de un tipo no adecuado.
class ErrorExpresionCase < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final y el tipo de la expresión.
  def initialize(inicio, final, tipo)
    @inicio = inicio
    @final = final
    @tipo = tipo
  end

  # Se define el to_s correspondiente que imprime le rango donde ocurre el error (línea y columna de inicio y final) y el tipo de la expresión.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la linea #{@final.linea}, columna #{@final.columna}: la expresión del case es de tipo \"#{@tipo}\""
  end
end

# Se crea un error para cuando el rango de una iteración es de un tipo diferente a range.
class ErrorRangoIteracion < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final y el tipo del rango.
  def initialize(inicio, final, tipo)
    @inicio = inicio
    @final = final
    @tipo = tipo
  end

  # Se define el to_s correspondiente que imprime le rango donde ocurre el error (línea y columna de inicio y final) y el tipo del rango.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la linea #{@final.linea}, columna #{@final.columna}: el rango de la iteración es de tipo \"#{@tipo}\""
  end
end

# Se crea un error para cuando la condición de la iteración es diferente de bool.
class ErrorCondicionIteracion < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final y el tipo de la condición.
  def initialize(inicio, final, tipo)
    @inicio = inicio
    @final = final
    @tipo = tipo
  end

  # Se define el to_s correspondiente que imprime le rango donde ocurre el error (línea y columna de inicio y final) y el tipo de la condición.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la linea #{@final.linea}, columna #{@final.columna}: la condición de la iteración es de tipo \"#{@tipo}\""
  end
end

# Se crea un error para cuando el rango de un caso es de un tipo diferente a range.
class ErrorRangoCaso < ContextError
  # Se encarga de inicializar con la ubicación de inicio y final y el tipo del rango.
  def initialize(inicio, final, tipo)
    @inicio = inicio
    @final = final
    @tipo = tipo
  end

  # Se define el to_s correspondiente que imprime le rango donde ocurre el error (línea y columna de inicio y final) y el tipo del rango.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la linea #{@final.linea}, columna #{@final.columna}: el rango del caso es del tipo \"#{@tipo}\" en vez de range"
  end
end

# Se crea una clase para englobar a todos los errores que puedan ocurrir en la verificación dinámica.
class DynamicError < RuntimeError
end

# Se crea una clase para los errores de overflow que puedan existir en la verificación dinámica.
class ErrorOverflow < DynamicError
  # Se inicializa con la ubicación de inicio y final.
  def initialize(inicio, final)
    @incio = inicio
    @final = final
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error y un mensaje informativo.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: El resultado no puede representarse en 32 bits"
  end
end

# Se crea una clase para cuando existe un rango inválido en el programa.
class RangoInvalido < DynamicError
  # Se inicializa con la ubicación de inicio y final.
  def initialize(inicio, final)
    @inicio = inicio
    @final = final
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error y un mensaje informativo.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: El rango es inválido."
  end
end

# Se crea una clase para cuando existe un error de división entre cero.
class DivisionCero < DynamicError
  # Se inicializa con la ubicación de inicio y final.
  def initialize(inicio, final)
    @inicio = inicio
    @final = final
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error y un mensaje informativo.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: Intento de división entre cero."
  end
end

# Se crea una clase para cuando existe un rango vacio en el programa.
class RangoVacio < DynamicError
  # Se inicializa con la ubicación de inicio y final.
  def initialize(inicio, final)
    @inicio = inicio
    @final = final
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error y un mensaje informativo.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: El rango es vacio."
  end
end

# Se crea una clase de error para cuando una variable no se encuentra inicializada.
class NoInicializada < DynamicError
  # Se inicializa con la ubicación de inicio y final y el nombre de la variable.
  def initialize(inicio, final, nombre)
    @inicio = inicio
    @final = final
    @nombre = nombre
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error y el nombre de la variable que no ha sido inicializada.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: La variable \"#{@nombre}\" no ha sido inicializada."
  end
end

# Se crea una clase de error para cuando el rango de la función rtoi tiene mas de un elemento.
class RangoRtoi < DynamicError
  # Se inicializa con la ubicación de inicio y final.
  def initialize(inicio, final)
    @inicio = inicio
    @final = final
  end

  # Se define el to_s correspondiente que imprime el rango donde ocurre el error y un mensaje informativo.
  def to_s
    "Error entre la línea #{@inicio.linea}, columna #{@inicio.columna} y la línea #{@final.linea}, columna #{@final.columna}: El rango de la función rtoi tiene mas de un elemento."
  end
end



# Se encarga de crear una nueva clase dada la superclase,
# el nombre de la nueva clase y los atributos que tendrá
# la misma.
def generaClase(superclase, nombre, atributos)
  #Creamos una nueva clase que herede de superclase
  clase = Class::new(superclase) do
    #Asignamos los atributos
    @atributos = atributos

    # Queremos que el campo atributos sea una variable de la clase y no de cada subclase
    # por lo que declaramos atributos en la clase singleton
    class << self
      attr_accessor :atributos
    end

    # Se encarga de inicializar el elemento de la clase
    def initialize(*argumentos)
      # Se levanta una excepcion si el numero de argumentos es diferente
      # al numero de atributos que debe tener.
      raise ArgumentError::new("wrong number of arguments (#{ argumentos.length } for #{ self.class.atributos.length })") if argumentos.length != self.class.atributos.length

      # En hijos se tendrá un arreglo que contiene pares de nombres de atributos y su valor correspondiente.
      @hijos = [self.class.atributos, argumentos].transpose

      @inicio = nil
      @final = nil
    end

    def method_missing(nombre, *argumentos)
      par = @hijos.map {|nombre_, contenido| [nombre_.sub(/\A[.-]/, ''), contenido] }.assoc(nombre.to_s.gsub(/_/, ' '))
      raise NoMethodError::new("undefined method `#{nombre}' for #{self.class.name}") if par.nil?
      par[1]
    end
  end

  # Se le asigna el nombre a la clase
  Object::const_set nombre, clase
end

# A continuación generamos todas las clases necesarias para cubrir el lenguaje.
generaClase(Object, 'AST', [])
  generaClase(AST, 'Declaracion'  , ['variables', 'tipo'])
  generaClase(AST, 'Programa'     , ['instruccion'])
  generaClase(AST, 'Caso'         , ['rango', 'instruccion'])
  generaClase(AST, 'Expresion'    , [])
    generaClase(Expresion, 'Modulo'         , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Por'            , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Mas'            , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Resta'          , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Construccion'   , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Division'       , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Desigual'       , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Menor_Que'      , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Menor_Igual_Que', ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Interseccion'   , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Igual'          , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Mayor_Que'      , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Mayor_Igual_Que', ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Pertenece'      , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'And'            , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Or'             , ['operando izquierdo', 'operando derecho'])
    generaClase(Expresion, 'Not'            , ['operando'])
    generaClase(Expresion, 'Menos_Unario'   , ['operando'])
    generaClase(Expresion, 'Entero'         , ['valor'])
    generaClase(Expresion, 'True'           , [])
    generaClase(Expresion, 'False'          , [])
    generaClase(Expresion, 'Variable'       , ['nombre'])
    generaClase(Expresion, 'Funcion_Bottom' , ['argumento'])
    generaClase(Expresion, 'Funcion_Length' , ['argumento'])
    generaClase(Expresion, 'Funcion_Rtoi'   , ['argumento'])
    generaClase(Expresion, 'Funcion_Top'    , ['argumento'])
  generaClase(AST, 'Instruccion', [])
    generaClase(Instruccion, 'Asignacion'      , ['var', 'expresion'])
    generaClase(Instruccion, 'Bloque'          , ['declaraciones', '-instrucciones'])
    generaClase(Instruccion, 'Read'            , ['variable'])
    generaClase(Instruccion, 'Write'           , ['elementos'])
    generaClase(Instruccion, 'Writeln'         , ['elementos'])
    generaClase(Instruccion, 'Condicional_Else', ['condicion', 'verdadero', 'falso'])
    generaClase(Instruccion, 'Condicional_If'  , ['condicion', 'verdadero'])
    generaClase(Instruccion, 'Case'            , ['exp', 'casos'])
    generaClase(Instruccion, 'Iteracion_Det'   , ['variable', 'rango', 'instruccion'])
    generaClase(Instruccion, 'Iteracion_Indet' , ['condicion', 'instruccion'])

# Modificamos la clase AST para agregarle el to_s y to_string
class AST
  attr_reader :inicio, :final

  def set_inicio(i)
    @inicio = i
    self
  end

  def set_final(f)
    @final = f
    self
  end

  # Se encarga de pasar a string el AST llamando a to_string con profundidad cero
  # y eliminando cualquier salto de línea del inicio y cualquier cantidad de
  # espacios en blancos.
  def to_s
    (to_string 0).sub(/\A[\n ]*/, '').gsub(/\s+$/, '')
  end

  # Se encarga de pasar a string el AST a la profundidad indicada.
  def to_string(profundidad)
    # Creamos un string con el nombre de la clase en mayusculas
    # continuado por el string generado por to_string de sus hijos.
    @hijos.inject("\n" + self.class.to_s.upcase) do |acum, cont|
      # Se utiliza un formato que permite ignorar la impresion de ciertos
      # nombres de atributos y/o elementos de alguna clase. Por ejemplo:
      # No se deben imprimir las declaraciones ni la palabra 'instrucciones'
      # para un bloque. De este modo se le coloca un . a lo que no queremos imprimir
      # (declaraciones) y un - a los titulos de atributos que no queremos imprimir
      # (instrucciones)
      case cont[0]
        # Si el primer caracter es un '.' se genera solamente lo que se lleva acumulado
        when /\A\./
          acum
        # Si el primer caracter es un '-' se genera el string acumulado mas el to_string
        # del contenido del atributo
        when /\A-/
          acum + cont[1].to_string(1)
        # En cualquier otro caso se genera el string que contiene el nombre del atributo
        # seguido por dos puntos y luego el to_string del contenido del atributo
        else
          acum + "\n  #{cont[0]}: #{ cont[1].to_string(2) }"
        end
    # Por ultimo se identa adecuadamente sustituyendo el inicio del string por la cantidad
    # de espacios en blanco necesarios (2*profundidad)
    end.gsub(/^/, '  '*profundidad)
  end
end

# Modificamos la clase Programa para agregar un to_string diferente
class Programa
  # Se encarga de imprimir el contenido del programa
  # sin imprimir la palabra 'PROGRAMA' en el AST
  def to_string(profundidad)
    @hijos[0][1].to_string(profundidad)
  end

  # Se encarga de la verificación estática del programa.
  def check
    # Llama al check de la instrucción del programa con una tabla de símbolos vacia.
    self.instruccion.check(SymTable::new)
    # Asigna la ubicación final al objeto de la clase.
    @final = self.instruccion.final
  end

  # Se encarga de la verificación dinámica del programa.
  def run
    # Llama al run de la instrucción del programa con una tabla de símbolos nueva.
    self.instruccion.run(SymTable::new)
  end
end

# Se modifica la clase Expresión para agregar nuevas cosas.
class Expresion
  # Se agrega un type que permite saber el tipo de la expresión.
  attr_reader :type

  # Se agrega en la clase singleton un atributo llamado tipos_correctos que almacena en forma de diccionario
  # las combinaciones de tipos correctas que puede recibir una expresión.
  class << self
    attr_accessor :tipos_correctos
  end

  # Se encarga de chequear los tipos de la expresión evaluada y toma como parametro la clase de error que va a
  # utilizar para crear un nuevo error en caso de haberlo, agrega un error a la lista de errores de contexto si hay,
  # en efecto, un error de tipos y asigna el tipo de la expresión a TypeError. Si la expresión tiene tipos correctos,
  # se asigna el tipo resultante.
  def check_types(clase_error = ErrorDeTipo)
    # Se guarda en la variable tiposHijos todos los tipos de los hijos de la clase que sean del tipo expresión.
    tiposHijos = @hijos.reject {|_, hijo| !(hijo.is_a? Expresion)}.map {|_, hijo| hijo.type}

    # Se almacena en type el tipo resultante de utilizar, en los operadores, los tipos encontrados en los hijos de la clase.
    @type = self.class.tipos_correctos[tiposHijos]
    # Si type da nil es porque la combinación de hijos no se encuentra en el diccionario de tipos correctos y por ende hay un error de tipo.
    if @type.nil? then
      # Se asigna TypeError al tipo.
      @type = Rangex::TypeError
      # Se crea un nuevo error de contexto solamente si alguno de los operandos no era de tipo TypeError antes. Esto es para evitar
      # replicar los errores y agregar errores de contexto de mas.
      unless tiposHijos.include?(Rangex::TypeError) then
        $ErroresContexto << clase_error::new(inicio, final, self.class.name.gsub(/_/,' '), *tiposHijos)
      end
    end
  end

  # Se encarga de detectar si existe overflow en una operación. Toma como parametro el resultado de la operación e indica si existe overflow en la misma.
  def detectar_overflow(resultado)
    # Se levanta una excepcion si existe overflow en el resultado y sino se devuelve el resultado.
    raise ErrorOverflow::new(@inicio, @final) if (resultado > 2**31 - 1 or resultado < -2**31)
    resultado
  end
end

# Se modifica la clase Modulo para agregar nuevos metodos.
class Modulo
  # Se indican los tipos correctos que acepta esta expresión.
  @tipos_correctos = { [Rangex::Int, Rangex::Int] => Rangex::Int }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llama al check del operando izquierdo y asigna la ubicación de inicio de la expresión.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    # Llama al check del operando derecho y asigna la ubicación final de la expresión.
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Por ultimo se llama a check_types para revisar que los tipos de los operandos sean correctos
    check_types
  end

  # Se encarga de la verificacion dinamica del programa.
  def run(tabla)
    # Se hace la operación de modulo y se llama a detectar overflow.
    detectar_overflow(self.operando_izquierdo.run(tabla) % self.operando_derecho.run(tabla))
  end
end

# Se modifica la clase Caso para agregar nuevos metodos.
class Caso
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos al check del rango y luego asignamos la ubicación de inicio.
    self.rango.check(tabla)
    @inicio = self.rango.inicio
    # Si el tipo del rango es algo diferente a range se reporta un error de contexto y se asigna TypeError al tipo.
    if Rangex::Range != self.rango.type then
      @type = Rangex::TypeError
      $ErroresContexto << ErrorRangoCaso::new(@inicio, @final, self.rango.type)
    end
    # Finalmente hacemos check de la instrucción.
    self.instruccion.check(tabla)
  end

  # Se encarga de la verificacion dinamica del programa.
  def run(tabla, expresion)
    # Si la expresión está dentro del rango se ejecuta la instrucción.
    if expresion >= self.rango.run(tabla)[0] and expresion <= self.rango.run(tabla)[1] then
      self.instruccion.run(tabla)
    end
  end
end

# Se modifica la clase Por para agregar nuevos metodos.
class Por
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = {
    [Rangex::Int  , Rangex::Int] => Rangex::Int  ,
    [Rangex::Range, Rangex::Int] => Rangex::Range
  }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si el operando izquierdo es un entero entonces hacemos la operación multiplicación llamando a detectar overflow con el resultado de la misma.
    if Rangex::Int == self.operando_izquierdo.type then
      detectar_overflow(self.operando_izquierdo.run(tabla) * self.operando_derecho.run(tabla))
    else
      # Sino es porque estamos hablando de un rango y un entero. Revisamos si el entero es positivo o negativo.
      unless self.operando_derecho.run(tabla) < 0 then
        # Si es positivo se multiplica cada cota por el entero, llamando a detectar_overflow para estas multiplicaciones y se devuelve el rango.
        cota_inf = detectar_overflow(self.operando_izquierdo.run(tabla)[0] * self.operando_derecho.run(tabla))
        cota_sup = detectar_overflow(self.operando_izquierdo.run(tabla)[1] * self.operando_derecho.run(tabla))
        [cota_inf, cota_sup]
      else
        # Si es negativo, se multiplica cada cota por el entero (invirtiendo las cotas), llamando a detectar_overflow para estas multiplicaciones y se devuelve el rango.
        cota_inf = detectar_overflow(self.operando_izquierdo.run(tabla)[1] * self.operando_derecho.run(tabla))
        cota_sup = detectar_overflow(self.operando_izquierdo.run(tabla)[0] * self.operando_derecho.run(tabla))
        [cota_inf, cota_sup]
      end
    end
  end
end

# Se modifica la clase Mas para agregar nuevos metodos.
class Mas
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = {
    [Rangex::Int  , Rangex::Int  ] => Rangex::Int  ,
    [Rangex::Range, Rangex::Range] => Rangex::Range
  }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si el operando izquierdo es un entero entonces hacemos una suma y llamamos a detectar overflow con el resultado de esa operación.
    if Rangex::Int == self.operando_izquierdo.type then
      detectar_overflow(self.operando_izquierdo.run(tabla) + self.operando_derecho.run(tabla))
    else
      # Sino se trata de una unión, en cuyo caso buscamos la menor de las cotas inferiores y la mayor de las cotas superiores para que sean nuestras nuevas cotas.
      cota_inf = [self.operando_izquierdo.run(tabla)[0], self.operando_derecho.run(tabla)[0]].min
      cota_sup = [self.operando_izquierdo.run(tabla)[1], self.operando_derecho.run(tabla)[1]].max
      # Si la cota superior es mayor a la inferior, se devuelve un rango. Sino, se crea una nueva excepción para el error del rango válido.
      unless cota_inf > cota_sup then
        [cota_inf, cota_sup]
      else
        raise RangoInvalido::new(@inicio, @final)
      end
    end
  end
end

# Se modifica la clase Resta para agregar nuevos métodos.
class Resta
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Int, Rangex::Int] => Rangex::Int }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se hace la operación de resta y se llama a detectar overflow.
    detectar_overflow(self.operando_izquierdo.run(tabla) - self.operando_derecho.run(tabla))
  end
end

# Se modifica la clase Construccion para agregar nuevos métodos.
class Construccion
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Int, Rangex::Int] => Rangex::Range }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si la cota inferior es mayor a la superior se tira una excepción de rango inválido
    if self.operando_izquierdo.run(tabla) > self.operando_derecho.run(tabla) then
      raise RangoInvalido::new(@inicio, @final)
    else
      # Sino se devuelve el rango conformado por los dos enteros en los operandos.
      [self.operando_izquierdo.run(tabla), self.operando_derecho.run(tabla)]
    end
  end
end

# Se modifica la clase Division para agregar nuevos métodos.
class Division
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Int, Rangex::Int] => Rangex::Int }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si el divisor no es cero entonces se hace la operación division y se llama a detectar_overflow
    unless self.operando_derecho.run(tabla).zero? then
      detectar_overflow(self.operando_izquierdo.run(tabla) / self.operando_derecho.run(tabla))
    else
      # En cambio si el operador derecho es cero entonces se levanta una excepción
      raise DivisionCero::new(@inicio, @final)
    end
  end
end

# Se modifica la clase Desigual para agregar nuevos métodos.
class Desigual
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = {
    [Rangex::Int  , Rangex::Int  ] => Rangex::Bool,
    [Rangex::Range, Rangex::Range] => Rangex::Bool,
    [Rangex::Bool , Rangex::Bool ] => Rangex::Bool
  }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si el operando izquierdo es de tipo range entonces se realiza la operacion desigual para las cotas inferiores y las superiores de ambos rangos.
    if Rangex::Range == self.operando_izquierdo.type then
      self.operando_izquierdo.run(tabla)[0] != self.operando_derecho.run(tabla)[0] and self.operando_izquierdo.run(tabla)[1] != self.operando_derecho.run(tabla)[1]
    # En cambio si es Int o Bool se realiza desigual directamente sobre los operadores.
    else
      self.operando_izquierdo.run(tabla) != self.operando_derecho.run(tabla)
    end
  end
end

# Se modifica la clase Menor_Que para agregar nuevos métodos.
class Menor_Que
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = {
    [Rangex::Int  , Rangex::Int  ] => Rangex::Bool,
    [Rangex::Range, Rangex::Range] => Rangex::Bool
  }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si estamos trabajando con enteros se realiza la operación < sobre los operandos.
    if Rangex::Int == self.operando_izquierdo.type then
      self.operando_izquierdo.run(tabla) < self.operando_derecho.run(tabla)
    # Si es un rango se verifica que la cota superior del izquierdo sea menor a la cota inferior del derecho.
    else
      self.operando_izquierdo.run(tabla)[1] < self.operando_derecho.run(tabla)[0]
    end
  end
end

# Se modifica la clase Menor_Igual_Que para agregar nuevos métodos.
class Menor_Igual_Que
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = {
    [Rangex::Int  , Rangex::Int  ] => Rangex::Bool,
    [Rangex::Range, Rangex::Range] => Rangex::Bool
  }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si estamos trabajando con enteros se realiza la operación <= sobre los operandos.
    if Rangex::Int == self.operando_izquierdo.type then
      self.operando_izquierdo.run(tabla) <= self.operando_derecho.run(tabla)
    else
    # Si es un rango se verifica que la cota superior del izquierdo sea menor o igual a la cota inferior del derecho.
      self.operando_izquierdo.run(tabla)[1] <= self.operando_derecho.run(tabla)[0]
    end
  end
end

# Se modifica la clase Interseccion para agregar nuevos métodos.
class Interseccion
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Range, Rangex::Range] => Rangex::Range }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    rango_izq = self.operando_izquierdo.run(tabla)
    rango_der = self.operando_derecho.run(tabla)
    # La nueva cota inferior será el máximo entre las cotas inferiores derecha e izquierda.
    cota_inferior = [rango_izq[0], rango_der[0]].max
    # La nueva cota superior será el mínimo entre las cotas superiores derecha e izquierda.
    cota_superior = [rango_izq[1], rango_der[1]].min

    # Si la cota superior es mayor a la inferior se devuelve el rango creado con las nuevas cotas.
    unless cota_inferior > cota_superior then
      [cota_inferior, cota_superior]
    # Si la cota inferior es mayor a la superior se levanta una excepción.
    else
      raise RangoVacio::new(@inicio, @final)
    end
  end
end

# Se modifica la clase Igual para agregar nuevos métodos.
class Igual
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = {
    [Rangex::Int  , Rangex::Int  ] => Rangex::Bool,
    [Rangex::Range, Rangex::Range] => Rangex::Bool,
    [Rangex::Bool , Rangex::Bool ] => Rangex::Bool
  }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si el operando izquierdo es de tipo range entonces se realiza la operacion igual para las cotas inferiores y las superiores de ambos rangos.
    if Rangex::Range == self.operando_izquierdo.type then
      self.operando_izquierdo.run(tabla)[0] == self.operando_derecho.run(tabla)[0] and self.operando_izquierdo.run(tabla)[1] == self.operando_derecho.run(tabla)[1]
    # En cambio si es Int o Bool se realiza igual directamente sobre los operadores.
    else
      self.operando_izquierdo.run(tabla) == self.operando_derecho.run(tabla)
    end
  end
end

# Se modifica la clase Mayor_Que para agregar nuevos métodos.
class Mayor_Que
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = {
    [Rangex::Int  , Rangex::Int  ] => Rangex::Bool,
    [Rangex::Range, Rangex::Range] => Rangex::Bool
  }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si estamos trabajando con enteros se realiza la operación > sobre los operandos.
    if Rangex::Int == self.operando_izquierdo.type then
      self.operando_izquierdo.run(tabla) > self.operando_derecho.run(tabla)
    # Si es un rango se verifica que la cota inferior del izquierdo sea mayor a la cota superior del derecho.
    else
      self.operando_izquierdo.run(tabla)[0] > self.operando_derecho.run(tabla)[1]
    end
  end
end

# Se modifica la clase Mayor_Igual_Que para agregar nuevos métodos.
class Mayor_Igual_Que
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = {
    [Rangex::Int  , Rangex::Int  ] => Rangex::Bool,
    [Rangex::Range, Rangex::Range] => Rangex::Bool
  }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si estamos trabajando con enteros se realiza la operación >= sobre los operandos.
    if Rangex::Int == self.operando_izquierdo.type then
      self.operando_izquierdo.run(tabla) >= self.operando_derecho.run(tabla)
    # Si es un rango se verifica que la cota inferior del izquierdo sea mayor o igual a la cota superior del derecho.
    else
      self.operando_izquierdo.run(tabla)[0] >= self.operando_derecho.run(tabla)[1]
    end
  end
end

# Se modifica la clase Pertenece para agregar nuevos métodos.
class Pertenece
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Int, Rangex::Range] => Rangex::Bool }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # El operando izquierdo es el entero y el derecho el rango.
    entero = self.operando_izquierdo.run(tabla)
    rango = self.operando_derecho.run(tabla)
    # Se devuelve true en caso de que el entero pertenezca al rango y false en caso contrario.
    (rango[0] <= entero and entero <= rango[1])
  end
end

# Se modifica la clase And para agregar nuevos métodos.
class And
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Bool, Rangex::Bool] => Rangex::Bool }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se realiza la operación and entre los operandos.
    (self.operando_izquierdo.run(tabla) and self.operando_derecho.run(tabla))
  end
end

# Se modifica la clase Or para agregar nuevos métodos.
class Or
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Bool, Rangex::Bool] => Rangex::Bool }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para los operandos izquierdo y derecho y asignamos la ubicación de inicio y final.
    self.operando_izquierdo.check(tabla)
    @inicio = self.operando_izquierdo.inicio
    self.operando_derecho.check(tabla)
    @final = self.operando_derecho.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se realiza la operación or entre los operandos.
    (self.operando_izquierdo.run(tabla) or self.operando_derecho.run(tabla))
  end
end

# Se modifica la clase Not para agregar nuevos métodos.
class Not
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Bool] => Rangex::Bool }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para el operando y agregamos la ubicación final.
    self.operando.check(tabla)
    @final = self.operando.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types(ErrorDeTipoUnario)
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se realiza la operación not sobre el operando.
    (not self.operando.run(tabla))
  end
end

# Se modifica la clase Menos_Unario para agregar nuevos métodos.
class Menos_Unario
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Int] => Rangex::Int }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para el operando y agregamos la ubicación final.
    self.operando.check(tabla)
    @final = self.operando.final
    # Finalmente chequeamos que los tipos estén bien.
    check_types(ErrorDeTipoUnario)
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se realiza la operación menos unario sobre el operando y se llama a detectar_overflow.
    detectar_overflow(-self.operando.run(tabla))
  end
end

# Se modifica la clase Entero para agregar nuevos métodos.
class Entero
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Asigna Int al tipo.
    @type = Rangex::Int
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Llama a detectar_overflow para el valor del entero.
    detectar_overflow(self.valor.texto.to_i)
  end
end

# Se modifica la clase True para agregar nuevos métodos.
class True
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Asigna Bool al tipo.
    @type = Rangex::Bool
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Devuelve true.
    true
  end
end

# Se modifica la clase False para agregar nuevos métodos.
class False
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Asigna Bool al tipo.
    @type = Rangex::Bool
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Devuelve false.
    false
  end
end

# Se modifica la clase Variable para agregar nuevos métodos.
class Variable
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Buscamos la variable en la tabla de símbolos y rescatamos en caso de que exista un error en el find y agregamos el error a la lista de errores de contexto.
    begin
      variable = tabla.find(self.nombre.texto)
    rescue RedefinirError => r
      $ErroresContexto << r
    end

    # Si la variable es nil entonces asignamos TypeError y agregamos un nuevo error a los errores de contexto que indique que no está declarada.
    if variable.nil? then
      @type = Rangex::TypeError
      $ErroresContexto << NoDeclarada::new(@inicio, @final, self.nombre.texto)
    else
      # Sino se le asigna el tipo correspondiente a type.
      @type = variable[:tipo]
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Buscamos la variable en la tabla de simbolos.
    variable = tabla.find(self.nombre.texto)
    # Si su valor es nil es porque no está inicializada, de modo que levantamos una excepción. Sino devolvemos su valor.
    if variable[:valor].nil? then
      raise NoInicializada::new(@inicio, @final, self.nombre.texto)
    else
      variable[:valor]
    end
  end
end

# Se modifica la clase Funcion_Bottom para agregar nuevos métodos.
class Funcion_Bottom
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Range] => Rangex::Int }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para el operando.
    self.argumento.check(tabla)
    # Finalmente chequeamos que los tipos estén bien.
    check_types(ErrorDeTipoFuncion)
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se devuelve la cota inferior del rango.
    self.argumento.run(tabla)[0]
  end
end

# Se modifica la clase Funcion_Length para agregar nuevos métodos.
class Funcion_Length
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Range] => Rangex::Int }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para el operando.
    self.argumento.check(tabla)
    # Finalmente chequeamos que los tipos estén bien.
    check_types(ErrorDeTipoFuncion)
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Devuelve la cota superior menos la cota inferior mas 1, esta es la longitud.
    1 + self.argumento.run(tabla)[1] - self.argumento.run(tabla)[0]
  end
end

# Se modifica la clase Funcion_Top para agregar nuevos métodos.
class Funcion_Top
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Range] => Rangex::Int }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para el operando.
    self.argumento.check(tabla)
    # Finalmente chequeamos que los tipos estén bien.
    check_types(ErrorDeTipoFuncion)
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se devuelve la cota superior del rango.
    self.argumento.run(tabla)[1]
  end
end

# Se modifica la clase Funcion_Rtoi para agregar nuevos métodos.
class Funcion_Rtoi
  # Se indica el diccionario de tipos correctos para la operación.
  @tipos_correctos = { [Rangex::Range] => Rangex::Int }

  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Llamamos a la operación check para el operando.
    self.argumento.check(tabla)
    # Finalmente chequeamos que los tipos estén bien.
    check_types(ErrorDeTipoFuncion)
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si las cotas superior e inferior son iguales se devuelve alguna de ellas
    if self.argumento.run(tabla)[0] == self.argumento.run(tabla)[1] then
      self.argumento.run(tabla)[0]
    else
      # Sino se tira una excepción.
      raise RangoRtoi::new(@inicio, @final)
    end
  end
end

# Se modifica la clase Asignacion para agregar nuevos métodos.
class Asignacion
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Buscamos la variable en la tabla de símbolos
    begin
      variable = tabla.find(self.var.texto)

      # Llamamos a check de la expresión y asignamos la ubicación final.
      self.expresion.check(tabla)
      @final = self.expresion.final

      # Si la variable es nil es porque no fue declarada y agregamos un error de contexto.
      if variable.nil? then
        $ErroresContexto << NoDeclarada::new(@inicio, @final, self.var.texto)
      else
        # Si la variable no es mutable entonces agregamos un error de contexto ( cuando intentamos modificar la variable de una iteración )
        unless variable[:es_mutable] then
          $ErroresContexto << ErrorModificarIteracion::new(@inicio, @final, self.var.texto)
        end
      end
    # Se hace rescue del error de redefinir que puede ocurrir en la tabla de símbolos.
    rescue RedefinirError => r
      $ErroresContexto << r
    end

    # A menos que la variable sea nil o el tipo de la expresión sea el que corresponde o TypeError se agrega un error de tipos a la lista de errores de contexto.
    unless variable.nil? or [variable[:tipo], Rangex::TypeError].include?(self.expresion.type) then
      $ErroresContexto << ErrorDeTipoAsignacion::new(@inicio, @final, self.expresion.type, self.var.texto, variable[:tipo])
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Buscamos la variable en la tabla de simbolos.
    variable = tabla.find(self.var.texto)
    # Al valor de la variable le asignamos el run de la expresión.
    variable[:valor] = self.expresion.run(tabla)
  end
end

# Modificamos la clase Bloque para agregar nuevos métodos.
class Bloque
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    #Creamos una nueva tabla de símbolos a la cual le agregamos las declaraciones existentes en el bloque mediante el uso de inject.
    begin
      tabla2 = self.declaraciones.inject(SymTable::new(tabla)) do |acum, declaracion|
        declaracion.variables.inject(acum) do |acum2, variable|
          acum2.insert(variable, declaracion.tipo.to_type)
        end
      end

      # Para cada instruccion se hace check de la instrucción con la nueva tabla de símbolos.
      self.instrucciones.each do |instruccion|
        instruccion.check(tabla2)
      end

    # Se hace rescue de algun error que pudiera aparecer en la tabla de símbolos.
    rescue RedefinirError => r
      $ErroresContexto << r
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    #Creamos una nueva tabla de símbolos a la cual le agregamos las declaraciones existentes en el bloque mediante el uso de inject.
    tabla2 = self.declaraciones.inject(SymTable::new(tabla)) do |acum, declaracion|
      declaracion.variables.inject(acum) do |acum2, variable|
        acum2.insert(variable, declaracion.tipo.to_type)
      end
    end

    # Para cada instrucción se llama a su run.
    self.instrucciones.each do |instruccion|
      instruccion.run(tabla2)
    end
  end
end

# Se modifica la clase Read para agregar nuevos métodos.
class Read
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Buscamos la variable en la tabla de símbolos y hacemos rescue del error de redefinición que pueda aparecer en el find.
    begin
      variable = tabla.find(self.variable.texto)
    rescue RedefinirError => r
      $ErroresContexto << r
    end

    # Si la variable es nil entonces es porque no fue declarada y se agrega un error de contexto.
    if variable.nil? then
      $ErroresContexto << NoDeclarada::new(@inicio, @final, self.var.texto)
    end
    # A menos que la variable sea mutable se agrega un error de contexto.
    unless variable[:es_mutable]
      $ErroresContexto << ErrorModificarIteracion::new(@inicio, @final, self.var.texto)
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Buscamos la variable en la tabla de símbolos
    variable = tabla.find(self.variable.texto)
    # Leemos la entrada
    entrada = STDIN.gets
    # Quitamos los espacios en blanco.
    entrada = entrada.gsub(/\s*/, '')
    # Si la variable es de tipo booleano buscamos que la entrada haga match con true o false y de ser así entonces se lo asignamos al valor.
    # Si no hace match con esto entonces se indica al usuario que no se leyo lo esperado y se llama de nuevo a run.
    if Rangex::Bool == variable[:tipo] then
      entrada = entrada.match(/(true, false)/)
        if "true" == entrada[0] then
          variable[:valor] = true
        elsif "false" == entrada[0] then
          variable[:valor] = false
        else
          puts "La variable es de tipo bool y no se leyo ni true ni false"
          run(tabla)
        end
    # Si la variable es de tipo rango buscamos que la entrada haga match con algun formato en el que se pueden escribir los rangos; bien sea 1..2 o 1,2 por ejemplo.
    # Si hace match se verifica que las cotas estén bien y se le asigna al valor de la variable el nuevo valor. Sino se indica al usuario y se llama a run de nuevo.
    elsif Rangex::Range == variable[:tipo] then
      entrada = entrada.match(/(-?[0-9]+\.\.-?[0-9]+|-?[0-9]+,-?[0-9]+)/)
        unless entrada.nil? then
          unless entrada[0].include?(',') then
            cota_inf = entrada[0].sub(/\.\.-?[0-9]+/, '').to_i
            cota_sup = entrada[0].sub(/-?[0-9]+\.\./, '').to_i
          else
            cota_inf = entrada[0].sub(/,-?[0-9]+/, '').to_i
            cota_sup = entrada[0].sub(/-?[0-9]+,/, '').to_i
          end
          unless cota_inf > cota_sup then
            variable[:valor] = [cota_inf.to_i, cota_sup.to_i]
          else
            puts "Las cotas ingresadas no son validas"
            run(tabla)
          end
        else
          puts "La variable es de tipo range y no se leyo una expresion valida"
          run(tabla)
        end
    # Si es un entero entonces vemos si la entrada hace match con algun entero, de ser así se le asigna al valor de la variable el entero.
    # Sino se le indica al usuario y se llama a run de nuevo.
    else
      entrada = entrada.match(/-?[0-9]+/)
        unless entrada.nil? then
          variable[:valor] = entrada[0].to_i
        else
          puts "La variable es de tipo int y no se leyo una expresion valida"
          run(tabla)
        end
    end
  end
end

# Se modifica la clase Write para agregar nuevos métodos.
class Write
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Para cada elemento de la lista se llama a su check a menos que sea un string.
    self.elementos.each do |elemento|
      elemento.check(tabla) unless elemento.is_a?(TkString)
    end
    # Se asigna la ubicación final.
    @final = self.elementos.final
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Para cada elemento de la lista a menos que sea un token string se va a llamar al run de su valor. Si es un array es porque es un rango de modo que se imprime de la forma '4..5'.
    # Sino se hace print de su valor.
    self.elementos.each do |elemento|
      unless elemento.is_a?(TkString) then
        valor = elemento.run(tabla)
        if valor.is_a?(Array) then
          print "#{valor[0]}..#{valor[1]}"
        else
          print valor
        end
        print ' '
      # Si es un string, quitamos las comillas y sustituimos los saltos de línea para que se impriman adecuadamente en pantalla y se procede a imprimir.
      else
        print elemento.texto.gsub(/"/, '').gsub(/\\n/, "\n")
        print ' '
      end
    end
  end
end

# Se modifica la clase Writeln para agregar nuevos métodos.
class Writeln
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Para cada elemento de la lista se llama a su check a menos que sea un string.
    self.elementos.each do |elemento|
      elemento.check(tabla) unless elemento.is_a?(TkString)
    end
  # Se asigna la ubicación final.
  @final = self.elementos.final
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Para cada elemento de la lista a menos que sea un token string se va a llamar al run de su valor. Si es un array es porque es un rango de modo que se imprime de la forma '4..5'.
    # Sino se hace print de su valor.
    self.elementos.each do |elemento|
      unless elemento.is_a?(TkString) then
        valor = elemento.run(tabla)
        if valor.is_a?(Array) then
          print "#{valor[0]}..#{valor[1]}"
        else
          print valor
        end
      # Si es un string, quitamos las comillas y sustituimos los saltos de línea para que se impriman adecuadamente en pantalla y se procede a imprimir.
      else
        print elemento.texto.gsub(/"/, '').gsub(/\\n/, "\n")
      end
    end
    # Finalmente agregamos una linea nueva con puts ya que es la instrucción writeln
    puts ''
  end
end

# Se modifica la clase Condicional_Else para agregar nuevos métodos.
class Condicional_Else
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Se hace check de la condición.
    self.condicion.check(tabla)

    # Se hace check de ambas instrucciones del condicional y se asigna la ubicación final.
    self.verdadero.check(tabla)
    self.falso.check(tabla)
    @final = self.falso.final

    # A menos que la condicion sea un booleano o ya venga con un error de tipos se agrega un nuevo error a la lista de errores de contexto.
    unless [Rangex::Bool, Rangex::TypeError].include?(self.condicion.type) then
      $ErroresContexto << ErrorCondicionCondicional::new(@inicio, @final, self.condicion.type)
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si la condicion es cierta se ejecuta la instrucción en verdadero, en cambio si es falsa se ejecuta la instrucción en falso.
    if self.condicion.run(tabla) then
      self.verdadero.run(tabla)
    else
      self.falso.run(tabla)
    end
  end
end

# Se modifica la clase Condicional_If para agregar nuevos métodos.
class Condicional_If
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Se hace check de la condición.
    self.condicion.check(tabla)

    # Se hace check de la instrucción del condicional y se asigna la ubicación final.
    self.verdadero.check(tabla)
    @final = self.verdadero.final

    # A menos que la condicion sea un booleano o ya venga con un error de tipos se agrega un nuevo error a la lista de errores de contexto.
    unless [Rangex::Bool, Rangex::TypeError].include?(self.condicion.type) then
      $ErroresContexto << ErrorCondicionCondicional::new(@inicio, @final, self.condicion.type)
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Si la condición es cierta se ejecuta la instrucción en veradero.
     self.verdadero.run(tabla) if self.condicion.run(tabla)
  end
end

# Se modifica la clase Case para agregar nuevos métodos.
class Case
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Se hace check de la expresión.
    self.exp.check(tabla)
    # A menos que la condicion sea un entero o que ya venga con un error de tipos se agrega un nuevo error a la lista de errores de contexto.
    unless [Rangex::Int, Rangex::TypeError].include?(self.exp.type) then
      $ErroresContexto << ErrorExpresionCase::new(@inicio, @final, self.exp.type)
    end

    # Para cada uno de los casos se hace check a menos que sea un string.
    self.casos.each do |caso|
      caso.check(tabla) unless caso.is_a?(TkString)
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se hace run re la expresión
    expresion = self.exp.run(tabla)

    # Para cada uno de los casos se hace run con la respectiva expresión.
    self.casos.each do |caso|
      caso.run(tabla, expresion)
    end
  end
end

# Se modifica la clase Iteracion_Det para agregar nuevos métodos.
class Iteracion_Det
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Se hace check del rango.
    self.rango.check(tabla)

    # Se crea una nueva tabla de símbolos igual a la original, mas la variable de iteración.
    tabla2 = SymTable::new(tabla).insert(self.variable, Rangex::Int, false)

    # Se hace check de la instruccion y se asigna la ubicación final.
    self.instruccion.check(tabla2)
    @final = self.instruccion.final

    # A menos que el rango sea un range o ya venga con un error de tipos se agrega un nuevo error a la lista de errores de contexto
    unless [Rangex::Range, Rangex::TypeError].include?(self.rango.type) then
      $ErroresContexto << ErrorRangoIteracion::new(@inicio, @final, self.rango.type)
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Se crea una nueva tabla de símbolos igual a la original, mas la variable de iteración.
    tabla2 = SymTable::new(tabla).insert(self.variable, Rangex::Int, false)
    # Buscamos la variable en la tabla.
    variable = tabla2.find(self.variable.texto)

    # Con la ayuda de la instrucción for de ruby ejecutamos la instruccion del lenguaje RangeX. Para el valor de la variable dentro del rango indicado se realiza la instrución dada.
    for variable[:valor] in self.rango.run(tabla2)[0]..self.rango.run(tabla2)[1] do
      self.instruccion.run(tabla2)
    end
  end
end

# Se modifica la clase Iteracion_Indet para agregar nuevos métodos.
class Iteracion_Indet
  # Se encarga de la verificación estática del programa.
  def check(tabla)
    # Se hace check de la condición.
    self.condicion.check(tabla)

    # Se hace check de la instruccion y se asigna la ubicación final.
    self.instruccion.check(tabla)
    @final = self.instruccion.final

    # A menos que la condición sea un booleano o ya venga con un error de tipos se agrega un nuevo error a la lista de errores de contexto
    unless [Rangex::Bool, Rangex::TypeError].include?(self.condicion.type) then
      $ErroresContexto << ErrorCondicionIteracion::new(@inicio, @final, self.condicion.type)
    end
  end

  # Se encarga de la verificación dinámica del programa.
  def run(tabla)
    # Mientras la condición sea true se ejecuta la instrucción.
    while self.condicion.run(tabla) do
      self.instruccion.run(tabla)
    end
  end
end
