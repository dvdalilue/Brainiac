#
# Hash para la ejecucion, guarda la variable con su valor
# ademas de atributo elastico(si se puede modificar)

class ValueTable
  def initialize(padre = nil)
    @padre = padre
    @table = {}
  end

  def insert(variable)
    @table[variable] = {:valor => nil, :elastico => true}
  end

  def update(variable, valor)
    find(variable)[:valor] = valor
  end

  def elasticized(variable)
    find(variable)[:elastico] = true
  end

  def d_elasticized(variable)
    find(variable)[:elastico] = false
  end

  def find(variable)
    if @table.has_key?(variable) then
      return @table[variable]
    elsif @padre.nil? then
      return nil
    end
    @padre.find(variable)
  end
end

#
# Clase de para interaccion de las cintas, con todos los metodos
# especificados.
#

class Band

  attr_reader :cinta

  def initialize(length)
    @cinta = Array::new(length, 0)
    @actual = 0
  end

  def dot
    @cinta[@actual]
  end

  def coma
    print "\nIntrodusca El Valor Para La Cinta(Solo importara el primer caracter, sin exiten mas solo seran ignorados): "
    @cinta[@actual] = STDIN.gets.chomp.chr.ord
  end
  
  def plus
    @cinta[@actual] += 1
  end

  def minus
    @cinta[@actual] -= 1
  end

  def right
    if @actual == (@cinta.length - 1) then
      @actual = 0
    else
      @actual +=1 
    end
  end

  def left
    if @actual == 0 then
      @actual = @cinta.length - 1
    else
      @actual -= 1  
    end
  end

  def concat(tape)
    @cinta + tape.cinta
  end

  def p_all
    puts "#{@cinta}"
  end
end
