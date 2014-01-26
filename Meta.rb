module Meta
  def Meta::create_class(father, name, attr)
    #1
    nc = Class::new(father) do
      #2
      class << self 
        attr_reader :attr 
      end
      #3
      if !father.eql?Object
        @attr = attr + father.attr
      else
        @attr = attr
      end
      #4
      self.attr.each { |a|
        #self.send(:attr_accessor,a)
        define_method(a + "=") do |val|
          instance_variable_set("@#{a}",val)
        end
        #self.class_eval("def #{a}=(val);@#{a}=val;end") ###Otro tipo de setter
        define_method(a) do
          instance_variable_get( "@" + a ) 
        end
        #self.class_eval("def #{a};@#{a};end") ###Otro tipo de getter
      }
    end
    #5
    nc.class_eval do
      def initialize(*attr)
        raise ArgumentError::new("#{caller(0)[-1]}: Numero de parametros incorrecto a la clase (#{self.class.name}):" +
                                 " pasaron #{attr.length}, deben ser #{self.class.attr.length}") unless attr.length == self.class.attr.length
        [self.class.attr, attr].transpose.map { |a,v|
          instance_variable_set("@#{a}",v)
        }
      end
    end
    #6
    Object::const_set(name, nc)
    return nc
  end

  #1 - Creacion de una nueva clase y se deja abierto para agregar los accessors 
  #    y metodos pertinentes.

  #2 - Apertura de clase singleton para 'self', redefiniendo la clase(objeto)
  #    con un reader. Esto puede verse como la definicion de un atributo estatico,
  #    igual sucede con los metodos definidos dentro de la apertura de la 
  #    clase singleton, seran "estaticos"

  #3 - Se define el attr_reader como el arreglo de atributos de clase, si el padre
  #    es 'Object' sus atributos seran los que fueron pasados por parametro. Si
  #    el padre es otro sus atributos seran los que fueron pasados por parametro
  #    adicional a los del padre.

  #4 - Seccion que define los setters y  getters para cada uno de los atributos de
  #    la clase, haciendo uso de 'define_method' que recibe el nombre del metodo,
  #    ademas se deja abierto con 'do' para especificar lo que va a realizar el
  #    metodo. Al ejecutar la instruccion instance_variable_set(...) se crea una
  #    varible de @nombre en la clase donde el nombre es definido en el arreglo
  #    original de atributos. Por otro lado instance_variable_get(@...) obtiene
  #    el valor de la variable con el nombre especificado por parametro.
  #    Existe otra forma de definir lo que hara la funcion, esto es posible con
  #    define_method(nombre, bloque) donde nombre es el nombre de la funcion y 
  #    bloque es un 'block' que se crea a partir de 'lambda' que agarra una 
  #    pedazo de codigo y lo empaqueta. Ambos tienen el mismo efecto en la clase

  #5 - Luego se define el constructor 'initialize', abriendo la clase otra vez
  #    con class_eval, lo que se hace verificar si se pasaron la cantidad adecuada
  #    de argumentos, si es asi, se recorre el arreglo inherente de la clase con
  #    el nombre de los atributos en conjunto con los atributos pasados por
  #    parametro y se setean a la instancia.

  #6 - Por ultimo se cambia el nombre de la clase al que se desea el llamador.
  
  # Palabras claves:
  #
  #   define_method
  #   create_method
  #   class_eval
  #   instance_eval
  #   instance_variable_set
  #   instance_variable_get
  #   send
  ################################################################################
end
