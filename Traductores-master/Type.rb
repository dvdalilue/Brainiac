#Gabriela Limonta 10-10385
#John Delgado 10-10196

#Modulo que define las clases de los posibles tipos basicos que
#existen en Rangex
module Rangex
  class Type
    # Agregamos en la clase singleton un to_s que permite imprimir el nombre de la clase ignorando el nombre del Modulo.
    class << self
      def to_s
        name.sub(/Rangex::/, '')
      end
    end

    # Redefinimos == para que los tipos puedan ser comparables
    def ==(otro)
      otro.class == self.class
    end

    # Agregamos un to_s que devuelve el nombre de la clase
    def to_s
      self.class.name
    end

    # Agregamos un inspect que devuelve el to_s de la clase
    def inspect
      to_s
    end
  end

#Se crean clases para los distintos tipos: Int, Bool, Range y TypeError que representa un error de tipos
  class Int   < Type; end
  class Bool  < Type; end
  class Range < Type; end
  class TypeError < Type; end
end
