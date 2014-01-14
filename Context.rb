require_relative 'AST'
require_relative 'ContextErrors'

#
#Redifinicion de las clases para anilisis de contexto
#

class AST

  attr_reader :linea, :columna

  def set_linea(l)
    @linea = l
    self
  end

  def set_columna(c)
    @columna = f
    self
  end

end

class Programa

  def check
    self.alcance.check#(SymTable::new)
    @linea = self.alcance.linea
    @columna = self.alcance.columna
  end
end

class Alcance
  def check
    begin
      tabla2 = self.declaraciones.inject(SymTable::new(tabla)) do |acum, declaracion|
        declaracion.variables.inject(acum) do |acum2, variable|
          acum2.insert(variable, declaracion.tipo.to_type)
        end
      end

      self.instrucciones.each do |instruccion|
        instruccion.check(tabla2)
      end
    rescue RedefinirError => r
      $ErroresContexto << r
    end
  end
end

class Asignacion
  def check(tabla)
    begin
      variable = tabla.find(self.var.texto)

      if variable.nil? then
        $ErroresContexto << NoDeclarada::new(@linea, @columna, self.var.texto)
      else
        unless variable[:es_mutable] then
          $ErroresContexto << ErrorModificarIteracion::new(@linea, @columna, self.var.texto)
        end
      end
    rescue RedefinirError => r
      $ErroresContexto << r
    end

    self.expresion.check(tabla)
    @columna = self.expresion.columna
    unless [variable[:tipo], Brainiac::TypeError].include?(self.expresion.type) then
      $ErroresContexto << ErrorDeTipoAsignacion::new(@linea, @columna, self.expresion.type, self.var.texto, variable[:tipo])
    end
  end
end

class CondicionalIf
  def check(tabla)
    self.condicion.check(tabla)
    unless [Brainiac::Bool, Brainiac::TypeError].include?(self.condicion.type) then
      $ErroresContexto << ErrorCondicionCondicional::new(@linea, @columna, self.condicion.type)
    end

    self.verdadero.check(tabla)
    @columna = self.verdadero.columna
  end
end

class CondicionalElse
  def check(tabla)
    self.condicion.check(tabla)
    unless [Brainiac::Bool, Brainiac::TypeError].include?(self.condicion.type) then
      $ErroresContexto << ErrorCondicionCondicional::new(@linea, @columna, self.condicion.type)
    end

    self.verdadero.check(tabla)
    self.falso.check(tabla)
    @columna = self.falso.columna
  end
end

class IteracionI
  def check(tabla)
    self.condicion.check(tabla)
    unless [Brainiac::Bool, Brainiac::TypeError].include?(self.condicion.type) then
      $ErroresContexto << ErrorCondicionIteracion::new(@linea, @columna, self.condicion.type)
    end

    self.instruccion.check(tabla)
    @columna = self.instruccion.columna
  end
end


class IteracionDExpA
  def check(tabla)
    self.rango.check(tabla)
    unless [Brainiac::Range, Brainiac::TypeError].include?(self.rango.type) then
      $ErroresContexto << ErrorRangoIteracion::new(@linea, @columna, self.rango.type)
    end
    tabla2 = SymTable::new(tabla).insert(self.variable, Brainiac::Int, false)

    self.instruccion.check(tabla2)
    @columna = self.instruccion.columna
  end
end

class IteracionDId
  def check(tabla)
    self.rango.check(tabla)
    unless [Brainiac::Range, Brainiac::TypeError].include?(self.rango.type) then
      $ErroresContexto << ErrorRangoIteracion::new(@linea, @columna, self.rango.type)
    end
    tabla2 = SymTable::new(tabla).insert(self.variable, Brainiac::Int, false)

    self.instruccion.check(tabla2)
    @columna = self.instruccion.columna
  end
end

class Read
  def check(tabla)
    begin
      variable = tabla.find(self.variable.texto)
    rescue RedefinirError => r
      $ErroresContexto << r
    end

    if variable.nil? then
      $ErroresContexto << NoDeclarada::new(@linea, @columna, self.var.texto)
    end
    unless variable[:es_mutable]
      $ErroresContexto << ErrorModificarIteracion::new(@linea, @columna, self.var.texto)
    end
  end
end

class Write
  def check(tabla)
    self.elementos.each do |elemento|
      elemento.check(tabla) unless elemento.is_a?(TkString)
    end
    @columna = self.elementos.columna
  end
end

class Expresion
  attr_reader :type

  class << self
    attr_accessor :tipos_correctos
  end

  def check_types(clase_error = ErrorDeTipo)
    tiposHijos = @hijos.reject {|_, hijo| !(hijo.is_a? Expresion)}.map {|_, hijo| hijo.type}
    @type = self.class.tipos_correctos[tiposHijos]
    if @type.nil? then
      @type = Brainiac::TypeError
      unless tiposHijos.include?(Brainiac::TypeError) then
        $ErroresContexto << clase_error::new(linea, columna, self.class.name.gsub(/_/,' '), *tiposHijos)
      end
    end
  end
end

class Entero
  def check(tabla)
    @type = Brainiac::Int
  end
end

class True
  def check(tabla)
    @type = Brainiac::Bool
  end
end

class False
  def check(tabla)
    @type = Brainiac::Bool
  end
end

class Variable
  def check(tabla)
    begin
      variable = tabla.find(self.nombre.texto)
    rescue RedefinirError => r
      $ErroresContexto << r
    end

    if variable.nil? then
      @type = Brainiac::TypeError
      $ErroresContexto << NoDeclarada::new(@linea, @columna, self.nombre.texto)
    else
      @type = variable[:tipo]
    end
  end
end

class Suma
  @tipos_correctos = {
    [Brainiac::Int  , Brainiac::Int  ] => Brainiac::Int  ,
    [Brainiac::Range, Brainiac::Range] => Brainiac::Range
  }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Resta
  @tipos_correctos = { [Brainiac::Int, Brainiac::Int] => Brainiac::Int }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Multiplicacion
  @tipos_correctos = {
    [Brainiac::Int  , Brainiac::Int] => Brainiac::Int  ,
    [Brainiac::Range, Brainiac::Int] => Brainiac::Range
  }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Division
  @tipos_correctos = { [Brainiac::Int, Brainiac::Int] => Brainiac::Int }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Modulo
  @tipos_correctos = { [Brainiac::Int, Brainiac::Int] => Brainiac::Int }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_type
  end
end

class Menos_Unario
  @tipos_correctos = { [Brainiac::Int] => Brainiac::Int }

  def check(tabla)
    self.operando.check(tabla)
    @columna = self.operando_derecho.columna
    check_types(ErrorDeTipoUnario)
  end
end

class Negacion
  @tipos_correctos = { [Brainiac::Bool] => Brainiac::Bool }

  def check(tabla)
    self.operando.check(tabla)
    @columna = self.operando.columna
    check_types(ErrorDeTipoUnario)
  end
end

class Conjuncion
  @tipos_correctos = { [Brainiac::Bool, Brainiac::Bool] => Brainiac::Bool }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Disyuncion
  @tipos_correctos = { [Brainiac::Bool, Brainiac::Bool] => Brainiac::Bool }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Igual
  @tipos_correctos = {
    [Brainiac::Int  , Brainiac::Int  ] => Brainiac::Bool,
    [Brainiac::Range, Brainiac::Range] => Brainiac::Bool,
    [Brainiac::Bool , Brainiac::Bool ] => Brainiac::Bool
  }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Inequevalencia
  @tipos_correctos = {
    [Brainiac::Int  , Brainiac::Int  ] => Brainiac::Bool,
    [Brainiac::Range, Brainiac::Range] => Brainiac::Bool,
    [Brainiac::Bool , Brainiac::Bool ] => Brainiac::Bool
  }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Menor
  @tipos_correctos = {
    [Brainiac::Int  , Brainiac::Int  ] => Brainiac::Bool,
    [Brainiac::Range, Brainiac::Range] => Brainiac::Bool
  }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Mayor
  @tipos_correctos = {
    [Brainiac::Int  , Brainiac::Int  ] => Brainiac::Bool,
    [Brainiac::Range, Brainiac::Range] => Brainiac::Bool
  }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class MenorOIgual
  @tipos_correctos = {
    [Brainiac::Int  , Brainiac::Int  ] => Brainiac::Bool,
    [Brainiac::Range, Brainiac::Range] => Brainiac::Bool
  }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class MayorOIgual
  @tipos_correctos = {
    [Brainiac::Int  , Brainiac::Int  ] => Brainiac::Bool,
    [Brainiac::Range, Brainiac::Range] => Brainiac::Bool
  }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end













class Construccion
  @tipos_correctos = { [Brainiac::Int, Brainiac::Int] => Brainiac::Range }

  def check(tabla)
    self.operando_izquierdo.check(tabla)
    @linea = self.operando_izquierdo.linea
    self.operando_derecho.check(tabla)
    @columna = self.operando_derecho.columna
    check_types
  end
end

class Caso
  def check(tabla)
    self.rango.check(tabla)
    if Brainiac::Range != self.rango.type then
      @type = Brainiac::TypeError
      $ErroresContexto << ErrorRangoCaso::new(@linea, @columna, self.rango.type)
    end
    @linea = self.rango.linea
    self.instruccion.check(tabla)
  end
end

