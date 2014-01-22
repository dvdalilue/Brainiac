# -*- coding: utf-8 -*-
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
    "Error cerca de la línea #{@linea} y columna #{@columna}: se intenta hacer la operacion #{@operacion} entre operandos de tipos \"#{@tipo_izq}\" y \"#{@tipo_der}\""
  end
end

class ErrorDeTipoUnario < ContextError
  def initialize(linea, columna, operacion, tipo)
    @linea = linea
    @columna = columna
    @operacion = operacion
    @tipo = tipo
  end

  def to_s
    "Error cerca de la línea #{@linea} y columna #{@columna}: se intenta hacer la operacion #{@operacion} a un operando de tipo \"#{@tipo}\""
  end
end

class NoDeclarada < ContextError
  def initialize(linea, columna, nombre)
    @linea = linea
    @columna = columna
    @nombre = nombre
  end

  def to_s
    "Error cerca de la línea #{@linea} y columna #{@columna}: la variable \"#{@nombre}\" no se encuentra declarada"
  end
end

class ErrorModificarIteracion < ContextError
  def initialize(linea, columna, nombre)
    @linea = linea
    @columna = columna
    @nombre = nombre
  end

  def to_s
    "Error cerca de la línea #{@linea} y columna #{@columna}: se intenta modificar la variable \"#{@nombre}\" que pertenece a una iteración"
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
    "Error cerca de la línea #{@linea} y columna #{@columna}: se intenta asignar algo del tipo \"#{@tipo_asig}\" a la variable \"#{@nombre}\" de tipo \"#{@tipo_var}\""
  end
end

class ErrorCondicionCondicional < ContextError
  def initialize(linea, columna, tipo)
    @linea = linea
    @columna = columna
    @tipo = tipo
  end

  def to_s
    "Error cerca de la línea #{@linea} y columna #{@columna}: la condición es de tipo \"#{@tipo}\""
  end
end

class ErrorExpresionCase < ContextError
  def initialize(linea, columna, tipo)
    @linea = linea
    @columna = columna
    @tipo = tipo
  end

  def to_s
    "Error cerca de la línea #{@linea} y columna #{@columna}: la expresión del case es de tipo \"#{@tipo}\""
  end
end

class ErrorCondicionIteracion < ContextError
  def initialize(linea, columna, tipo)
    @linea = linea
    @columna = columna
    @tipo = tipo
  end

  def to_s
    "Error cerca de la línea #{@linea} y columna #{@columna}: la condición de la iteración es de tipo \"#{@tipo}\""
  end
end
