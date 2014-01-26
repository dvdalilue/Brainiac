# -*- coding: utf-8 -*-
class DynamicError < RuntimeError
end

class LimetesInvalidos < DynamicError
  def initialize(line, column)
    @line = line
    @column = column
  end

  def to_s
    "Error entre la línea #{@line} y columna #{@column}: Los limites de la iteracion son inválido."
  end
end

class CintaMalConstruida < DynamicError
  def initialize(line, column)
    @line = line
    @column = column
  end
  
  def to_s
    "Error entre la línea #{@line} y columna #{@column}: Construccion errada de cinta, solo naturales(N)."
  end
end

class DivisionCero < DynamicError
  def initialize(line, column)
    @line = line
    @column = column
  end

  def to_s
    "Error entre la línea #{@line} y columna #{@column}: Intento de división entre cero."
  end
end

class NoInicializada < DynamicError
  def initialize(line, column, nombre)
    @line = line
    @column = column
    @nombre = nombre
  end

  def to_s
    "Error entre la línea #{@line} y columna #{@column}: La variable \"#{@nombre}\" no ha sido inicializada."
  end
end

class EjecucionInvalida < DynamicError
  def initialize(line, column, nombre)
    @line = line
    @column = column
    @operacion = nombre
  end

  def to_s
    "Error entre la línea #{@line} y columna #{@column}: La ejecucion no puede efectuarse en la expresion de tipo \"#{@operacion}\"."
  end
end
