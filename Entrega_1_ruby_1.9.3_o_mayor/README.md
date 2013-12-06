Brainiac [![Ruby](https://developers.google.com/+/images/16-ruby.png)](https://www.ruby-lang.org/)
========

Lexer & Parser In Ruby

Lexer
------

En esta primera parte se implementa el analizador lexicografico, de
manera muy rudimentaria dado que el lenguaje no posee una herramieta
que brinde una facilidad para la creacion de un Lexer. 

Pero igual es sumamente interesante todo lo que brinda [![Ruby](https://developers.google.com/+/images/16-ruby.png)](https://www.ruby-lang.org/)

Estructura
-----------

La idea principal es enumerar cada palabra clave del lenguaje, asi
como "integer", "int", "for", etc. Ademas de las frases permitidas que
debera reconocer el `Lexer` y esto se logra a traves del uso de
expresiones regular, que seria algo como esto:

```ruby
tk = {

  'Cinta'           =>  /\A{[+-<>.,]*}/               ,      
  'ConstructorTape' =>  /\A\[[a-zA-Z_][0-9a-zA-Z_]*\]/,
  'Coma'            =>  /\A\,/                        ,      
  'Punto'           =>  /\A\./                        ,       
  'PuntoYComa'      =>  /\A\;/                        ,       
  'ParAbre'         =>  /\A\(/                        ,       
  'ParCierra'       =>  /\A\)/                        ,       
  'CorcheteAbre'    =>  /\A\[/                        ,       
  'CorcheteCierra'  =>  /\A\]/                        ,       
  'LlaveAbre'       =>  /\A\{/                        ,       
  'LlaveCierra'     =>  /\A\}/                        ,       
  'Type'            =>  /\A\:\:/                      ,       
  'Menos'           =>  /\A\-/                        ,      
  'Mas'             =>  /\A\+/                        ,      
  'Mult'            =>  /\A\*/                        ,       
  'Div'             =>  /\A\/(?![\\=])/               ,       
  'Mod'             =>  /\A\%/                        ,       
  'Conjuncion'      =>  /\A\/\\/                      ,       
  'Disyuncion'      =>  /\A\\\//                      ,       
  'Negacion'        =>  /\A\~/                        ,       
  'Menor'           =>  /\A\<(?!=)/                   ,       
  'MenorIgual'      =>  /\A\<=/                       ,       
  'Mayor'           =>  /\A\>(?!=)/                   ,       
  'MayorIgual'      =>  /\A\>=/                       ,       
  'Igual'           =>  /\A\=/                        ,       
  'Desigual'        =>  /\A\/=/                       ,       
  'Concat'          =>  /\A\&/                        ,       
  'Inspeccion'      =>  /\A\#/                        ,      
  'Asignacion'      =>  /\A\:=/                       ,     
  'Ident'           =>  /\A[a-zA-Z_][0-9a-zA-Z_]*/    ,
  'Error'           =>  /\A\W/                        ,   
  'Num'             =>  /\A\d*/                       ,

}
```

Despues vendria todo la declaracion de las clases necesarias para la
implementacion del analizador, esto puede variar dependiendo de la
implementacion de cada persona. 

Existe una seccion importante en la clase `Token`, donde se utiliza la
clase singleton, `class << self` esto abre la clase singleton para
`Token`

Por otro lado, en esta seccion:

```ruby
$tokens.each do |id,regex|

  newclass = Class::new(Token) do #Creacion dinamica "Magic"

    @regex = regex #Se le asigna la regexp respectiva a la clase
    
    def initialize(text, line, column)
      @text = text
      @line = line
      @column = column
    end
  end

  Object::const_set("Tk#{id}", newclass) #Se renombra la clase como Tk<nombre>

end
```
Nos permite crear clases para cada token en `tk` de forma dinamica

Estos dos aspectos son lo que inspiraron a usar el lenguaje y sus
beneficios de la metaprogramacion

Mas abajo existen varios enlaces que brindan ayudan a la compresion e
implementacion del `Lexer`:

http://stackoverflow.com/questions/2505067/class-self-idiom-in-ruby
http://stackoverflow.com/questions/10964081/class-self-vs-self-method-with-ruby-whats-better
http://en.wikipedia.org/wiki/Singleton_pattern
http://www.ruby-doc.org/stdlib-1.9.3/libdoc/irb/rdoc/RubyLex.html
http://fr.wikibooks.org/wiki/Programmation_Ruby/H%C3%A9ritage
http://www.techotopia.com/index.php/Ruby_Essentials
http://yankist.com/blog/2011/02/02/create-ruby-dynamic-class/
http://ruby-doc.org/core-2.0.0/Object.html
http://jimneath.org/2010/01/04/cryptic-ruby-global-variables-and-their-meanings.html
http://www.tutorialspoint.com/ruby/ruby_regular_expressions.htm
http://codelikezell.com/how-to-use-ruby-variables-in-regular-expressions/
http://doc.infosnel.nl/ruby_regular_expressions.html
http://www.ruby-doc.org/core-1.9.3/Regexp.html
http://ruby.about.com/od/qa/ss/Variables-Declared-In-The-Global-Scope.htm
http://es.softuses.com/75486
http://www.ruby-doc.org/core-2.0.0/Hash.html#method-i-key
     


 
 
 
 
 
 
 
 
 


