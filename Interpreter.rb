require_relative 'Context'
require_relative 'DynamicErrors'
require_relative 'Execution'

class Programa
  def exec
    @attr_value[0][1].exec(ValueTable::new)
  end
end

class Alcance
  def exec(tabla)    
    unless @attr_value[0][1].class.eql? Array then
      @attr_value[0][1].exec(tabla)
    end
    @attr_value[1][1].exec(tabla)
  end
end

class Declaraciones
  def exec(tabla)
    for dec in @attr_value[0][1]
      dec.exec(tabla)
    end
  end
end

class Declaracion
  def exec(tabla)
    for var in @attr_value[0][1]
      tabla.insert(var.attr_value[0][1].text)
    end
  end
end

class Instrucciones
  def exec(tabla)
    for inst in @attr_value[0][1]
      inst.exec(tabla)
    end
  end
end

class Asignacion
  def exec(tabla)
    tabla.update(@attr_value[0][1].text, @attr_value[1][1].exec(tabla))
  end
end

class CondicionalIf
  def exec(tabla)
    if @attr_value[0][1].exec(tabla) then
      @attr_value[1][1].exec(tabla)
    end
  end
end

class CondicionalElse
  def exec(tabla)
    if @attr_value[0][1].exec(tabla) then
      @attr_value[1][1].exec(tabla)
    else
      @attr_value[2][1].exec(tabla)
    end
  end
end

class IteracionI
  def exec(tabla)
    while @attr_value[0][1].exec(tabla) do
      @attr_value[1][1].exec(tabla)      
    end
  end
end

class IteracionDId
  def exec(tabla)
    variable = tabla.find(@attr_value[0][1].text)
    i = @attr_value[1][1].exec(tabla)
    j = @attr_value[2][1].exec(tabla)
    raise LimetesInvalidos::new(@line, @column) if i>j
    variable[:valor] = i
    variable[:elastico] = false
    while i <= j do
      @attr_value[3][1].exec(tabla)
      i += 1
      variable[:valor] += 1
    end
    variable[:elastico] = true
  end
end

class IteracionDExpA
  def exec(tabla)
    i = @attr_value[0][1].exec(tabla)
    j = @attr_value[1][1].exec(tabla)
    raise LimetesInvalidos::new(@line, @column) if i>j
    while i <= j do
      @attr_value[2][1].exec(tabla)
      i += 1
    end
  end
end

class ES
  def exec(tabla)
    if @attr_value[0][1].class.eql?TkRead then
      tabla.find(@attr_value[1][1].text)[:valor] = STDIN.gets.chomp
    else
      salida = @attr_value[1][1].exec(tabla)
      unless salida.class.eql? Band then
        puts @attr_value[1][1].exec(tabla)
      else
        salida.p_all
      end
    end
  end
end

class Ejecucion
  def exec(tabla)
    unless Variable.eql? @attr_value[1][1].class then
      raise EjecucionInvalida::new(@line,
                                   @column,
                                   @attr_value[1][1].class)
    end
    variable = @attr_value[1][1].exec(tabla)
    @attr_value[0][1].text.each_char {|c| 
      case c
      when '>'
        variable.right
      when '<'
        variable.left
      when '.'
        print variable.dot.chr
      when ','
        variable.coma
      when '+'
        variable.plus
      when '-'
        variable.minus
      end
    }
  end
end

class SecInterna
  def exec(tabla)
    @attr_value[0][1].exec(tabla)
  end
end

class True
  def exec(tabla)
    true
  end
end

class False
  def exec(tabla)
    false
  end
end

class Entero
  def exec(tabla)
    Integer(@attr_value[0][1].text)
  end
end

class Variable
  def exec(tabla)
    variable = tabla.find(@attr_value[0][1].text)
    raise NoInicializada::new(@line, @column, @attr_value[0][1].text) if variable[:valor].nil?

    begin
      Integer(variable[:valor])
    rescue ArgumentError
      variable[:valor]
    rescue TypeError
      variable[:valor]
    end
  end
end

class ConstructorTape
  def exec(tabla)
    begin
      length = Integer(@attr_value[0][1].text[1])
    rescue ArgumentError
      variable = tabla.find(@attr_value[0][1].text[1])
      length = variable[:valor]
    end
    raise CintaMalConstruida::new(@line, @column) if length <= 0
    Band::new(length)
  end
end
                                                                                                                
class Division
  def exec(tabla)
    divisor = @attr_value[1][1].exec(tabla)
    raise DivisionCero::new(@line, @column) if divisor.eql?0
    return (@attr_value[0][1].exec(tabla) / divisor)
  end
end

class Suma; def exec(tabla);           return (@attr_value[0][1].exec(tabla) + @attr_value[1][1].exec(tabla));  end; end
                                                                                                                
class Resta; def exec(tabla);          return (@attr_value[0][1].exec(tabla) - @attr_value[1][1].exec(tabla));  end; end
                                                                                                                
class Multiplicacion; def exec(tabla); return (@attr_value[0][1].exec(tabla) * @attr_value[1][1].exec(tabla));  end; end
                                                                                                                
class Modulo; def exec(tabla);         return (@attr_value[0][1].exec(tabla) % @attr_value[1][1].exec(tabla));  end; end
                                                                                                                
class Menor; def exec(tabla);          return (@attr_value[0][1].exec(tabla) < @attr_value[1][1].exec(tabla));  end; end
                                                                                                                
class Mayor; def exec(tabla);          return (@attr_value[0][1].exec(tabla) > @attr_value[1][1].exec(tabla));  end; end

class MenorOIgual; def exec(tabla);    return (@attr_value[0][1].exec(tabla) <= @attr_value[1][1].exec(tabla)); end; end

class MayorOIgual; def exec(tabla);    return (@attr_value[0][1].exec(tabla) >= @attr_value[1][1].exec(tabla)); end; end

class Menos_Unario; def exec(tabla);   return (-@attr_value[0][1].exec(tabla));    end; end

class Negacion; def exec(tabla);       return (!@attr_value[0][1].exec(tabla));    end; end

class Inspeccion; def exec(tabla);     return (@attr_value[0][1].exec(tabla)).dot; end; end

class Conjuncion; def exec(tabla);     return (@attr_value[0][1].exec(tabla) and @attr_value[1][1].exec(tabla));     end; end
                                                                                                                     
class Disyuncion; def exec(tabla);     return (@attr_value[0][1].exec(tabla) or @attr_value[1][1].exec(tabla));      end; end
                                                                                                                     
class Igual; def exec(tabla);          return (@attr_value[0][1].exec(tabla) == @attr_value[1][1].exec(tabla));      end; end
                                                                                                                     
class Inequivalencia; def exec(tabla); return (@attr_value[0][1].exec(tabla) != @attr_value[1][1].exec(tabla));      end; end

class Concatenacion; def exec(tabla);  return (@attr_value[0][1].exec(tabla).concat(@attr_value[1][1].exec(tabla))); end; end
