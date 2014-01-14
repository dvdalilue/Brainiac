RACC = racc
FLAGS = -g
PARSER = Parser.y

Parser.rb: ${PARSER}
	${RACC} $< -o $@

clean:
	rm Parser.rb
