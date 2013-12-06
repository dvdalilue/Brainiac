class parser

  prechigh
  left  '*' '/'
  left  '+' '-'
  preclow

start Programa

rule

     Programa: 'hola' {result = val[0]}
             | 'done' {result = val[0]}
             | 'chao' {result = val[0]}

end
