class ContextError < RuntimeError
end

class ErrorDeTipo < ContextError
  def initialize(linea, columna, operacion, tipo_izq, tipo_der)
    @linea = linea
    @columna = columna
    @operacion = operacion
    @tipo_izq = tipo_izq
    @tipo_der = tipo_der
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: se intenta hacer la operacion #{@operacion} entre operandos de tipos \"#{@tipo_izq}\" y \"#{@tipo_der}\""
  end
end

class ErrorDeTipoUnario < ContextError
  def initialize(incio, columna, operacion, tipo)
    @linea = linea
    @columna = columna
    @operacion = operacion
    @tipo = tipo
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: se intenta hacer la operacion #{@operacion} a un operando de tipo \"#{@tipo}\""
  end
end

class NoDeclarada < ContextError
  def initialize(linea, columna, nombre)
    @linea = linea
    @columna = columna
    @nombre = nombre
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: la variable \"#{@nombre}\" no se encuentra declarada"
  end
end

class ErrorDeTipoFuncion < ContextError
  def initialize(linea, columna, nombre_funcion,tipo)
    @linea = linea
    @columna = columna
    @nombre_funcion = nombre_funcion
    @tipo = tipo
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: el argumento de la #{@nombre_funcion} es de tipo \"#{@tipo}\" y se esperaba tipo \"Range\""
  end
end

class ErrorModificarIteracion < ContextError
  def initialize(linea, columna, nombre)
    @linea = linea
    @columna = columna
    @nombre = nombre
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: se intenta modificar la variable \"#{@nombre}\" que pertenece a una iteración"
  end
end

class ErrorDeTipoAsignacion < ContextError
  def initialize(linea, columna, tipo_asig, nombre, tipo_var)
    @linea = linea
    @columna = columna
    @tipo_asig = tipo_asig
    @nombre = nombre
    @tipo_var = tipo_var
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: se intenta asignar algo del tipo \"#{@tipo_asig}\" a la variable \"#{@nombre}\" de tipo \"#{@tipo_var}\""
  end
end

class ErrorCondicionCondicional < ContextError
  def initialize(linea, columna, tipo)
    @linea = linea
    @columna = columna
    @tipo = tipo
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: la condición es de tipo \"#{@tipo}\""
  end
end

class ErrorExpresionCase < ContextError
  def initialize(linea, columna, tipo)
    @linea = linea
    @columna = columna
    @tipo = tipo
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: la expresión del case es de tipo \"#{@tipo}\""
  end
end

class ErrorRangoIteracion < ContextError
  def initialize(linea, columna, tipo)
    @linea = linea
    @columna = columna
    @tipo = tipo
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: el rango de la iteración es de tipo \"#{@tipo}\""
  end
end

class ErrorCondicionIteracion < ContextError
  def initialize(linea, columna, tipo)
    @linea = linea
    @columna = columna
    @tipo = tipo
  end

  def to_s
    "Error entre la línea #{@linea.linea}, columna #{@linea.columna} y la linea #{@columna.linea}, columna #{@columna.columna}: la condición de la iteración es de tipo \"#{@tipo}\""
  end
end
