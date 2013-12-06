all: Parser.rb

Parser.rb: Parser.y
	racc $< -o $@

clean: ; rm Parser.rb Parser.output
