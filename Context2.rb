module Brainiac end

require_relative 'AST2'
require_relative 'ContextErrors'
require_relative 'SymTable'

class TipoError; def self.name_tk; 'desconocido' end; end

#
#Redifinicion de las clases para anilisis de contexto
#

#
# Todos son redefinidas con un metodo check, que verifica
# los errores de contexto. Va recorriendo de izquierda a derecha.

# Dependiendo de la clase, existen diferentes tipos de errores.

# El attr_reader "type" en AST va a estar en todos, dado que es
# el padre. Este atributo sirve para los errores de tipo. 

# "type" es sintetizado, se hace check primero para ver que tipo es.
# La informacion va de los hijos al padre.

# Se usa la tabla de simbolos para guardar los identificadores y su tipo.

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
    @alcance.check(SymTable::new(nil))
  end
end

class Alcance
  def check(tabla)
    unless @declaraciones.class.eql? Array then
      @declaraciones.check(tabla)
    end
    @secuenciacion.check(tabla)
  end
end

class Declaraciones
  def check(tabla)
    for dec in @lista_declaraciones
      dec.check(tabla)
    end
  end
end

class Declaracion
  def check(tabla)
    for var in @lista
      tabla.insert(var.var, @tipo.class)
    end
  rescue RedefineError => r
    $ErroresContexto << r
  end
end

class Instrucciones
  def check(tabla)
    for inst in @instrucciones
      inst.check(tabla)
    end
  end
end

class Asignacion
  def check(tabla)
    variable = tabla.find(@var.text)
    if variable.nil? then
      $ErroresContexto << NoDeclarada::new(@var.line,
                                           @var.column,
                                           @var.text)
    else
      @value.check(tabla)
      unless variable[:tipo].eql? @value.type then
        $ErroresContexto << ErrorDeTipoAsignacion::new(@var.line,
                                                       @var.column,
                                                       @value.type.name_tk,
                                                       @var.text,
                                                       variable[:tipo].name_tk)
      end
    end
  end
end

class CondicionalIf
  def check(tabla)
    @condicion.check(tabla)
    unless TkBoolean.eql? @condicion.type then
      $ErroresContexto << ErrorCondicionCondicional::new(@line,
                                                         @column,
                                                         @condicion.type.name_tk)
    end
    @exito.check(tabla)
  end
end

class CondicionalElse
  def check(tabla)
    @condicion.check(tabla)
    unless TkBoolean.eql? @condicion.type then
      $ErroresContexto << ErrorCondicionCondicional::new(@line,
                                                         @column,
                                                         @condicion.type.name_tk)
    end
    @exito.check(tabla)
    @fracaso.check(tabla)
  end
end

class IteracionI
  def check(tabla)
    @condicion.check(tabla)
    unless TkBoolean.eql? @condicion.type then
      $ErroresContexto << ErrorCondicionIteracion::new(@line,
                                                       @column,
                                                       @condicion.type.name_tk)
    end
    @instruccion.check(tabla)
  end
end

class IteracionDId
  def check(tabla)
    variable = tabla.find(@identificador.text)
    if variable.nil? then
      $ErroresContexto << NoDeclarada::new(@identificador.line,
                                           @identificador.column,
                                           @identificador.text)
    end
    @condicionA.check(tabla)
    @condicionB.check(tabla)
    unless TkInteger.eql? @condicionA.type then
      $ErroresContexto << ErrorLimiteIteracion::new(@line,
                                                    @column,
                                                    @condicionA.type.name_tk)
    end
    unless TkInteger.eql?@condicionB.type then
      $ErroresContexto << ErrorLimiteIteracion::new(@line,
                                                    @column,
                                                    @condicionB.type.name_tk)
    end
    @instruccion.check(tabla)
  end
end

class IteracionDExpA
  def check(tabla)
    @condicionA.check(tabla)
    @condicionB.check(tabla)
    unless TkInteger.eql? @condicionA.type then
      $ErroresContexto << ErrorLimiteIteracion::new(@line,
                                                    @column,
                                                    @condicionA.type.name_tk)
    end
    unless TkInteger.eql?@condicionB.type then
      $ErroresContexto << ErrorLimiteIteracion::new(@line,
                                                    @column,
                                                    @condicionB.type.name_tk)
    end
    @instruccion.check(tabla)
  end
end

class ES
  def check(tabla)
    if @operancion.class.eql? TkRead then
      begin
        variable = tabla.find(@expresion.text)
      rescue NoMethodError
        
      end
      if variable.nil? then
        $ErroresContexto << NoDeclarada::new(@expresion.line,
                                             @expresion.column,
                                             @expresion.text)
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
      @expresion.check(tabla)
      if TipoError.eql? @expresion.type then
        $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                   @column,
                                                   'WRITE',
                                                   'no declarada')
      end
    end
  end
end

class Ejecucion
  def check(tabla)
    @expresion.check(tabla)
    unless TkTape.eql? @expresion.type then
      $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                 @column,
                                                 'EJECUCION',
                                                 @expresion.type.name_tk)
    end
  end
end

class SecInterna
  def check(tabla)
    @alcance.check(SymTable::new(tabla))
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
    variable = tabla.find(@var.text)
    if variable.nil? then
      @type = TipoError
      $ErroresContexto << NoDeclarada::new(@var.line,
                                           @var.column,
                                           @var.text)
    else
      @type = variable[:tipo]
    end
  end
end

class ConstructorTape
  def check(tabla)
    begin
      Integer(@length.text[1])
    rescue ArgumentError
      variable = tabla.find(@length.text[1])
      if variable.nil? then
        $ErroresContexto << NoDeclarada::new(@length.line,
                                             @length.column,
                                             @length.text)
      end
      unless TkInteger.eql? variable[:tipo] then
        $ErroresContexto << ErrorDeTipoUnario::new(@length.line,
                                                   @length.column,
                                                   'CONSTRUCTOR_TAPE',
                                                   variable[:tipo].name_tk)
      end
    end
    @type = TkTape
  end
end

class Suma
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'SUMA',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkInteger
  end
end

class Resta
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'RESTA',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkInteger
  end
end

class Multiplicacion
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
   unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MULTIPLICACION',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkInteger
  end
end

class Division
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'DIVISION',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkInteger
  end
end

class Modulo
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MODULO',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkInteger
  end
end

class Menor
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MENOR',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkBoolean
  end
end

class Mayor
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MAYOR',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkBoolean
  end
end

class MenorOIgual
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MenorOIgual',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkBoolean
  end
end

class MayorOIgual
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'MayorOIgual',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkBoolean
  end
end

class Menos_Unario
  def check(tabla)
    @op.check(tabla)
    unless TkInteger.eql? @op.type then
      $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                 @column,
                                                 'MENOS UNARIO',
                                                 @op.type.name_tk)
    end
    @type = TkInteger
  end
end

class Negacion
  def check(tabla)
    @op.check(tabla)
    unless TkBoolean.eql? @op.type then
      $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                 @column,
                                                 'NEGACION',
                                                 @op.type.name_tk)
    end
    @type = TkBoolean
  end
end

class Inspeccion
  def check(tabla)
    @tape.check(tabla)
    unless [TkConstructorTape, TkTape].include? @tape.type then
      $ErroresContexto << ErrorDeTipoUnario::new(@line,
                                                 @column,
                                                 'INSPECCION',
                                                 @tape.type.name_tk)
    end
    @type = TkInteger
  end
end

class Conjuncion
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkBoolean.eql? @opIzq.type and 
        TkBoolean.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'CONJUNCION',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkBoolean
  end
end

class Disyuncion
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    unless TkBoolean.eql? @opIzq.type and 
        TkBoolean.eql? @opDer.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'DISYUNCION',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
    end
    @type = TkBoolean
  end
end

class Igual
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    if TkBoolean.eql? @opIzq.type and 
        TkBoolean.eql? @opDer.type then
      @type = TkBoolean
    elsif TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      @type = TkBoolean
    else
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'IGUAL',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
      @type = TipoError
    end
  end
end

class Inequivalencia
  def check(tabla)
    @opIzq.check(tabla)
    @opDer.check(tabla)
    if TkBoolean.eql? @opIzq.type and 
        TkBoolean.eql? @opDer.type then
      @type = TkBoolean
    elsif TkInteger.eql? @opIzq.type and 
        TkInteger.eql? @opDer.type then
      @type = TkBoolean
    else
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'INEQIVALENCIA',
                                           @opIzq.type.name_tk,
                                           @opDer.type.name_tk)
      @type = TipoError
    end
  end
end

class Concatenacion
  def check(tabla)
    @tape1.check(tabla)
    @tape2.check(tabla)
    unless [TkConstructorTape, TkTape].include? @tape1.type and
        [TkConstructorTape, TkTape].include? @tape2.type then
      $ErroresContexto << ErrorDeTipo::new(@line,
                                           @column,
                                           'CONCATENACION',
                                           @tape1.type.name_tk,
                                           @tape2.type.name_tk)
    end
    @type = TkTape
  end
end
