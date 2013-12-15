RACC = racc
FLAGS = -g
PARSER = Parser.y

Parser.rb: 
	${RACC} ${PARSER} -o $@

clean:
	rm Parser.rb
