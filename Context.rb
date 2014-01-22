require_relative 'AST'
require_relative 'ContextErrors'
require_relative 'SymTable'

class TkTipoError
end

#
#Redifinicion de las clases para anilisis de contexto
#

class AST

  attr_reader :linea, :columna, :type

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
    @attr_value[0][1].check(nil)
    @linea = @attr_value[0][1].linea
    @columna = @attr_value[0][1].columna
  end
end

class Alcance
  def check(padre)
    tabla = SymTable::new(padre)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    @linea = 15
    @columna = 20
  end
end

class Declaraciones
  def check(tabla)
    for dec in @attr_value[0][1]
      dec.check(tabla)
    end
  end
end

class Declaracion
  def check(tabla)
    begin
      for var in @attr_value[0][1]
        tabla.insert(var.attr_value[0][1], @attr_value[1][1])
      end
    rescue RedefinirError => r
      $ErroresContexto << r
    end
  end
end

class Instrucciones
  def check(tabla)
    for inst in @attr_value[0][1]
      inst.check(tabla)
    end
  end
end

class Asignacion
  def check(tabla)
    variable = tabla.find(@attr_value[0][1].text)
    if variable.nil? then
      $ErroresContexto << NoDeclarada::new(@linea,
                                           @columna,
                                           @attr_value[0][1].text)
    else
      @attr_value[1][1].check(tabla)
      if [variable[:tipo]].include?(@attr_value[1][1].type) then
       $ErroresContexto << ErrorDeTipoAsignacion::new(@linea,
                                                      @columna,
                                                      @attr_value[1][1].type,
                                                      @attr_value[0][1].text,
                                                      variable[:tipo])
      end
    end
  end
end

class True
  def check(tabla)
    @type = TkBoolean
  end
end

class False
  def check(tabla)
    @type = TkBoolean
  end
end

class Entero
  def check(tabla)
    @type = TkInteger
  end
end

class CondicionalIf
  def check(tabla)
    @attr_value[0][1].check(tabla)

    if [TkBoolean].include?(@attr_value[0][1].type) then
      $ErroresContexto << ErrorCondicionCondicional::new(@linea,
                                                         @columna,
                                                         @attr_value[0][1].type)
    end
    @attr_value[1][1].check(tabla)
  end
end

class CondicionalElse
  def check(tabla)
    @attr_value[0][1].check(tabla)

    if [TkBoolean].include?(@attr_value[0][1].type) then
      $ErroresContexto << ErrorCondicionCondicional::new(@linea,
                                                         @columna,
                                                         @attr_value[0][1].type)
    end
    @attr_value[1][1].check(tabla)
    @attr_value[2][1].check(tabla)
  end
end

class Menos_Unario
  def check(tabla)
    @attr_value[0][1].check(tabla)
    unless [TkInteger].include?(@attr_value[0][1].type) then
      $ErroresContexto << ErrorDeTipoUnario::new(@linea,
                                                 @columna,
                                                 'menos unario',
                                                 @attr_value[0][1].type)
    end
    
  end
end

class Variable
  def check(tabla)
    variable = tabla.find(@attr_value[0][1].text)

    if variable.nil? then
      @type = TkTipoError
      $ErroresContexto << NoDeclarada::new(@linea,
                                           @columna,
                                           @attr_value[0][1].text)
    else
      @type = variable[:tipo]
    end
  end
end
