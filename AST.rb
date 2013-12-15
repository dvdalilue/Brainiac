#AST

$as_tree = [
            ['AST', [], [
                         ['Programa', %w[alcance], []] ,
                         ['Alcance', %w[declaraciones. secuenciacion], []],
                         ['Declaracion', %w[lista tipo], []],
                         ['Declaraciones', %w[declaraciones], []],
                         ['Instrucciones', %w[instrucciones], []],
                         ['Instruccion', %w[], [
                                                ['Asignacion', %w[var value], []],
                                                ['Condicional', %w[], [
                                                                       ['If', %w[condicion exito], []],
                                                                       ['Else', %w[condicion exito fracaso], []]
                                                                      ]],
                                                ['IteracionI', %w[condicion instruccion], []],
                                                ['IteracionD', %w[condicionA condicionB instruccion], [
                                                                                                       ['Id', %w[identificador], []],
                                                                                                       ['ExpA', %w[], []]
                                                                                                      ]],
                                                ['IO', %w[operancion expresion], []],
                                                ['SecInterna', %w[alcance], []]
                                               ]],
                         ['Expresion', %w[], [
                                              ['Entero', %w[numero], []],
                                              ['Variable', %w[var], []],
                                              ['Suma', %w[opIzq opDer], []],
                                              ['Resta', %w[opIzq opDer], []],
                                              ['Multiplicacion', %w[opIzq opDer], []],
                                              ['Division', %w[opIzq opDer], []],
                                              ['Modulo', %w[opIzq opDer], []],
                                              ['Menos_Unario', %w[op], []],
                                              ['True', %w[], []],
                                              ['False', %w[], []],
                                              ['Negacion', %w[op], []],
                                              ['Conjuncion', %w[opIzq opDer], []],
                                              ['Disyuncion', %w[opIzq opDer], []],
                                              ['Igual', %w[opIzq opDer], []],
                                              ['Inequevalencia', %w[opIzq opDer], []],
                                              ['Menor', %w[opIzq opDer], []],
                                              ['Mayor', %w[opIzq opDer], []],
                                              ['MenorOIgual', %w[opIzq opDer], []],
                                              ['MayorOIgual', %w[opIzq opDer], []],
                                              ['Ejecucion', %w[cinta], []],
                                              ['Concatenacion', %w[tape2], []],
                                              ['Inspeccion', %w[], []]
                                             ]]
                        ]]
           ]

def create_class(father, name, attr)

  nc = Class::new(father) do

    class << self 
      attr_accessor :attr 
    end

    if !father.eql?Object
      @attr = attr + father.attr
    else
      @attr = attr
    end

    attr_accessor :attr_value
    def initialize(*attr)
      @attr_value = [self.class.attr, attr].transpose
    end
  end

  if father.eql?Object
    Object::const_set(name, nc)
  else
    Object::const_set("#{father}#{name}", nc)
  end
  return nc
end

def create_tree(father,tree)

  tree.each do |name|
    n = create_class(father, name[0], name[1])
    create_tree(n, name[2])
  end
end

create_tree(Object,$as_tree)

class ASTPrograma

  def to_s
    attr_value.each do |n|
      " #{n[0]}: #{n[1]}"
    end
  end
end
