###########################
#Enumeracion de los Tokens#
###########################
module Brainiac
  #Creacion de un hash de las palabras claves
  rw = Hash::new
  reserved_words = %w(declare execute done read write while do if else end from at tape to true false integer boolean)

  #Se van agregando iterativamente al hash con su regex
  reserved_words.each do |s|
    rw[s.capitalize] = /\A#{s}\b/
  end

  #Declaracion manual de los tokens con sus expresiones regulares

  tk = {

    'Cinta'           =>  /\A{[+-<>.,]*}/               ,      
    'ConstructorTape' =>  /\A\[[_]*[0-9a-zA-Z_]+\]/     ,
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
    'Num'             =>  /\A\d+/                       ,

  }

  #Se unen ambas hash primera las palabras claves, evitar que sean confundidas por "Ident"

  $tokens = rw.merge(tk)
end
