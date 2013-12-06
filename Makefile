RACC = racc
FLAGS = -g -v
PARSER = Parser.y

Parser.rb: 
	${RACC} ${PARSER} -o $@

clean:
	rm Parser.rb
