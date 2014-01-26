require_relative 'Context2'
require_relative 'DynamicErrors'
require_relative 'Execution'

#
# Redifinicion de las clases del AST con un metodo
# exec, para realizar la ejecucion.

# ....
#

class Programa
  def exec
    @alcance.exec(ValueTable::new)
  end
end

class Alcance
  def exec(tabla)    
    unless @declaraciones.class.eql? Array then
      @declaraciones.exec(tabla)
    end
    @secuenciacion.exec(tabla)
  end
end

class Declaraciones
  def exec(tabla)
    for dec in @lista_declaraciones
      dec.exec(tabla)
    end
  end
end

class Declaracion
  def exec(tabla)
    for var in @lista
      tabla.insert(var.var.text)
    end
  end
end

class Instrucciones
  def exec(tabla)
    for inst in @instrucciones
      inst.exec(tabla)
    end
  end
end

class Asignacion
  def exec(tabla)
    raise VariableIneslastica::new(@var.line,
                                   @var.column,
                                   @var.text) if tabla.find(@var.text)[:elastico] == false
    tabla.update(@var.text, @value.exec(tabla))
  end
end

class CondicionalIf
  def exec(tabla)
    if @condicion.exec(tabla) then
      @exito.exec(tabla)
    end
  end
end

class CondicionalElse
  def exec(tabla)
    if @condicion.exec(tabla) then
      @exito.exec(tabla)
    else
      @fracaso.exec(tabla)
    end
  end
end

class IteracionI
  def exec(tabla)
    while @condicion.exec(tabla) do
      @instruccion.exec(tabla)      
    end
  end
end

class IteracionDId
  def exec(tabla)
    variable = tabla.find(@identificador.text)
    i = @condicionA.exec(tabla)
    j = @condicionB.exec(tabla)
    raise LimetesInvalidos::new(@identificador.line, @identificador.column) if i>j
    variable[:valor] = i
    variable[:elastico] = false
    while i <= j do
      @instruccion.exec(tabla)
      i += 1
      variable[:valor] += 1
    end
    variable[:elastico] = true
  end
end

class IteracionDExpA
  def exec(tabla)
    i = @condicionA.exec(tabla)
    j = @condicionB.exec(tabla)
    raise LimetesInvalidos::new(@line, @column) if i>j
    while i <= j do
      @instruccion.exec(tabla)
      i += 1
    end
  end
end

class ES
  def exec(tabla)
    if @operancion.class.eql?TkRead then
      raise VariableIneslastica::new(@var.line,
                                     @var.column,
                                     @var.text) if tabla.find(@expresion.text)[:elastico] == false
      tabla.find(@expresion.text)[:valor] = STDIN.gets.chomp
    else
      salida = @expresion.exec(tabla)
      unless salida.class.eql? Band then
        puts @expresion.exec(tabla)
      else
        salida.p_all
      end
    end
  end
end

class Ejecucion
  def exec(tabla)
    unless Variable.eql? @expresion.class then
      raise EjecucionInvalida::new(@line,
                                   @column,
                                   @expresion.class)
    end
    variable = @expresion.exec(tabla)
    @cinta.text.each_char {|c| 
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
    @alcance.exec(tabla)
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
    Integer(@numero.text)
  end
end

class Variable
  def exec(tabla)
    variable = tabla.find(@var.text)
    raise NoInicializada::new(@var.line, @var.column, @var.text) if variable[:valor].nil?
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
      len = Integer(@length.text[1])
    rescue ArgumentError
      variable = tabla.find(@length.text[1])
      len = variable[:valor]
    end
    raise CintaMalConstruida::new(@length.line, @length.column) if len <= 0
    Band::new(len)
  end
end
                                                                                                                
class Division
  def exec(tabla)
    divisor = @opDer.exec(tabla)
    raise DivisionCero::new(@line, @column) if divisor.eql?0
    return (@opIzq.exec(tabla) / divisor)
  end
end

class Suma; def exec(tabla);           return (@opIzq.exec(tabla) + @opDer.exec(tabla));  end; end
                                                                                                                
class Resta; def exec(tabla);          return (@opIzq.exec(tabla) - @opDer.exec(tabla));  end; end
                                                                                                                
class Multiplicacion; def exec(tabla); return (@opIzq.exec(tabla) * @opDer.exec(tabla));  end; end
                                                                                                                
class Modulo; def exec(tabla);         return (@opIzq.exec(tabla) % @opDer.exec(tabla));  end; end
                                                                                                                
class Menor; def exec(tabla);          return (@opIzq.exec(tabla) < @opDer.exec(tabla));  end; end
                                                                                                                
class Mayor; def exec(tabla);          return (@opIzq.exec(tabla) > @opDer.exec(tabla));  end; end

class MenorOIgual; def exec(tabla);    return (@opIzq.exec(tabla) <= @opDer.exec(tabla)); end; end

class MayorOIgual; def exec(tabla);    return (@opIzq.exec(tabla) >= @opDer.exec(tabla)); end; end

class Menos_Unario; def exec(tabla);   return (-@op.exec(tabla));    end; end

class Negacion; def exec(tabla);       return (!@op.exec(tabla));    end; end

class Inspeccion; def exec(tabla);     return (@tape.exec(tabla)).dot; end; end

class Conjuncion; def exec(tabla);     return (@opIzq.exec(tabla) and @opDer.exec(tabla));     end; end
                                                                                                                     
class Disyuncion; def exec(tabla);     return (@opIzq.exec(tabla) or @opDer.exec(tabla));      end; end
                                                                                                                     
class Igual; def exec(tabla);          return (@opIzq.exec(tabla) == @opDer.exec(tabla));      end; end
                                                                                                                     
class Inequivalencia; def exec(tabla); return (@opIzq.exec(tabla) != @opDer.exec(tabla));      end; end

class Concatenacion; def exec(tabla);  return (@tape1.exec(tabla).concat(@tape2.exec(tabla))); end; end
