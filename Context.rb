module Brainiac end

require_relative 'AST'
require_relative 'ContextErrors'
require_relative 'SymTable'

class TipoError; end

#
#Redifinicion de las clases para anilisis de contexto
#

class AST

  attr_reader :line, :column, :type

  def set_line(l)
    @line = l
    self
  end

  def set_column(c)
    @column = c
    self
  end
end

class Programa
  def check
    @attr_value[0][1].check(nil)
  end
end

class Alcance
  def check(padre)
    tabla = SymTable::new(padre)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla) if @attr_value[0][1].empty?
  end
end

class Declaraciones
  def check(tabla)
    for dec in @attr_value[0][1]
      dec.check(tabla)
    end
  end

  def empty?
    return False
  end
end

class Declaracion
  def check(tabla)
    for var in @attr_value[0][1]
      tabla.insert(var.attr_value[0][1], @attr_value[1][1].class)
    end
  rescue RedefineError => r
    $ErroresContexto << r
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
      $ErroresContexto << NoDeclarada::new(@line,
                                           @column,
                                           @attr_value[0][1].text)
    else
      @attr_value[1][1].check(tabla)
      unless variable[:tipo].eql? @attr_value[1][1].type then
        $ErroresContexto << ErrorDeTipoAsignacion::new(@line,
                                                       @column,
                                                       @attr_value[1][1].type.name_tk,
                                                       @attr_value[0][1].text,
                                                       variable[:tipo].name_tk)
      end
    end
  end
end

class CondicionalIf
  def check(tabla)
    @attr_value[0][1].check(tabla)
    unless TkBoolean.eql? @attr_value[0][1].type then
      $ErroresContexto << ErrorCondicionCondicional::new(@line,
                                                         @column,
                                                         @attr_value[0][1].type.name_tk)
    end
    @attr_value[1][1].check(tabla)
  end
end

class CondicionalElse
  def check(tabla)
    @attr_value[0][1].check(tabla)
    unless TkBoolean.eql?(@attr_value[0][1].type) then
      $ErroresContexto << ErrorCondicionCondicional::new(@line,
                                                         @column,
                                                         @attr_value[0][1].type.name_tk)
    end
    @attr_value[1][1].check(tabla)
    @attr_value[2][1].check(tabla)
  end
end

class IteracionI
  def check(tabla)
    @attr_value[0][1].check(tabla)
    unless TkBoolean.eql?(@attr_value[0][1].type) then
      $ErroresContexto << ErrorCondicionIteracion::new(@line,
                                                       @column,
                                                       @attr_value[0][1].type.name_tk)
    end
    @attr_value[1][1].check(tabla)
  end
end

class IteracionDId
  def check(tabla)
    variable = tabla.find(@attr_value[0][1].text)
    if variable.nil? then
      $ErroresContexto << NoDeclarada::new(@line,
                                           @column,
                                           @attr_value[0][1].text)
    end
    @attr_value[1][1].check(tabla)
    @attr_value[2][1].check(tabla)
    unless TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorLimiteIteracion::new(@line,
                                                    @column,
                                                    @attr_value[1][1].type.name_tk)
    end
    unless TkInteger.eql?@attr_value[2][1].type then
      $ErroresContexto << ErrorLimiteIteracion::new(@line,
                                                    @column,
                                                    @attr_value[2][1].type.name_tk)
    end
    @attr_value[3][1].check(tabla)
  end
end

class IteracionDExpA
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql?(@attr_value[0][1].type) then
      $ErroresContexto << ErrorLimiteIteracion::new(@line,
                                                    @column,
                                                    @attr_value[1][1].type.name_tk)
    end
    unless TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorLimiteIteracion::new(@line,
                                                    @column,
                                                    @attr_value[2][1].type.name_tk)
    end
    @attr_value[2][1].check(tabla)
  end
end

class ES
  def check(tabla)
    if @attr_value[0][1].eql?TkRead then
      variable = tabla.find(@attr_value[1][1].text)
      if variable.nil? then
        $ErroresContexto << NoDeclarada::new(@line,
                                             @column,
                                             @attr_value[0][1].text)
      else
        unless variable[:tipo].eql? TkBoolean or
            variable[:tipo].eql? TkInteger then
          $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                     @column,
                                                     'READ',
                                                     variable[:tipo].name_tk)
        end
      end
    else
      @attr_value[1][1].check(tabla)
      if TipoError.eql? @attr_value[1][1].type then
        $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                             @column,
                                             'READ',
                                             'no declarada')
      end
    end
  end
end

class SecInterna
  def check(tabla)
    tabla2 = SymTable::new(tabla)
    @attr_value[0][1].check(tabla2)
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

class Variable
  def check(tabla)
    variable = tabla.find(@attr_value[0][1].text)
    if variable.nil? then
      @type = TipoError
      $ErroresContexto << NoDeclarada::new(@line,
                                           @column,
                                           @attr_value[0][1].text)
    else
      @type = variable[:tipo]
    end
  end
end

class Suma
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'SUMA',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkInteger
  end
end

class Resta
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'RESTA',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkInteger
  end
end

class Multiplicacion
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MULTIPLICACION',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkInteger
  end
end

class Division
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'DIVISION',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkInteger
  end
end

class Modulo
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MODULO',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkInteger
  end
end

class Menor
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MENOR',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkBoolean
  end
end

class Mayor
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MAYOR',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkBoolean
  end
end

class MenorOIgual
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MenorOIgual',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkBoolean
  end
end

class MayorOIgual
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MayorOIgual',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkBoolean
  end
end

class Menos_Unario
  def check(tabla)
    @attr_value[0][1].check(tabla)
    unless TkInteger.eql? @attr_value[0][1].type then
      $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                 @column,
                                                 'MENOS UNARIO',
                                                 @attr_value[0][1].type.name_tk)
    end
    @type = TkInteger
  end
end

class Negacion
  def check(tabla)
    @attr_value[0][1].check(tabla)
    unless TkBoolean.eql? @attr_value[0][1].type then
      $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                 @column,
                                                 'NEGACION',
                                                 @attr_value[0][1].type.name_tk)
    end
    @type = TkBoolean
  end
end

class Inspeccion
  def check(tabla)
    @attr_value[0][1].check(tabla)
    unless TkTape.eql? @attr_value[0][1].type then
      $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                 @column,
                                                 'INSPECCION',
                                                 @attr_value[0][1].type.name_tk)
    end
    @type = TkTape
  end
end

class Conjuncion
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkBoolean.eql? @attr_value[0][1].type and 
        TkBoolean.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'CONJUNCION',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkBoolean
  end
end

class Disyuncion
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkBoolean.eql? @attr_value[0][1].type and 
        TkBoolean.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'DISYUNCION',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkBoolean
  end
end

class Igual
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    if TkBoolean.eql? @attr_value[0][1].type and 
        TkBoolean.eql? @attr_value[1][1].type then
      @type = TkBoolean
    elsif TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      @type = TkBoolean
    else
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'IGUAL',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
      @type = TipoError
    end
  end
end

class Inequivalencia
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    if TkBoolean.eql? @attr_value[0][1].type and 
        TkBoolean.eql? @attr_value[1][1].type then
      @type = TkBoolean
    elsif TkInteger.eql? @attr_value[0][1].type and 
        TkInteger.eql? @attr_value[1][1].type then
      @type = TkBoolean
    else
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'INEQUIVALENCIA',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
      @type = TipoError
    end
  end
end

class Concatenacion
  def check(tabla)
    @attr_value[0][1].check(tabla)
    @attr_value[1][1].check(tabla)
    unless TkTape.eql? @attr_value[0][1].type and
        TkTape.eql? @attr_value[1][1].type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'CONCATENACION',
                                           @attr_value[0][1].type.name_tk,
                                           @attr_value[1][1].type.name_tk)
    end
    @type = TkTape
  end
end
