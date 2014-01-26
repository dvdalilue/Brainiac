#AST
#Representacion del AST para crear todos las clases necesarias

require_relative 'Meta'

$as_tree = [
            ['AST', [], [
                         ['Programa', %w[alcance], []] ,
                         ['Alcance', %w[declaraciones secuenciacion], []],
                         ['Declaracion', %w[lista tipo], []],
                         ['Declaraciones', %w[lista_declaraciones], []],
                         ['Instrucciones', %w[instrucciones], []],
                         ['Instruccion', %w[], [
                                                ['Asignacion', %w[var value], []],
                                                ['Condicional', %w[], [
                                                                       ['CondicionalIf', %w[condicion exito], []],
                                                                       ['CondicionalElse', %w[condicion exito fracaso], []]
                                                                      ]],
                                                ['IteracionI', %w[condicion instruccion], []],
                                                ['Ejecucion', %w[cinta expresion], []],
                                                ['IteracionD', %w[condicionA condicionB instruccion], [
                                                                                                       ['IteracionDId', %w[identificador], []],
                                                                                                       ['IteracionDExpA', %w[], []]
                                                                                                      ]],
                                                ['ES', %w[operancion expresion], []],
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
                                              ['Inequivalencia', %w[opIzq opDer], []],
                                              ['Menor', %w[opIzq opDer], []],
                                              ['Mayor', %w[opIzq opDer], []],
                                              ['MenorOIgual', %w[opIzq opDer], []],
                                              ['MayorOIgual', %w[opIzq opDer], []],
                                              ['Concatenacion', %w[tape1 tape2], []],
                                              ['Inspeccion', %w[tape], []],
                                              ['ConstructorTape', %w[length], []]
                                             ]]
                        ]]
           ]

#Se Recorre el arbol, creando las clases
def create_tree(father,tree)
  tree.each do |name|
    n = Meta::create_class(father, name[0], name[1])
    create_tree(n, name[2])
  end
end

create_tree(Object,$as_tree)
