require 'spec_helper'

describe Lexeme do
  describe '#define' do
    it 'returns Lexeme object' do
      Lexeme.define { token :ANY => /^.*$/ }.should be_a Lexeme::Lexeme
    end
  end
  
  describe '#analyze' do 
    it 'raise an erorr if source file cannot be found' do
      lexer = Lexeme.define do
        token :ANY => /^.*$/
      end

      expect { lexer.analyze { from_file '/root/surce.math'} }.to raise_error(RuntimeError)
    end
    
    it 'tokenize a math formulas source' do
      source = File.join(File.dirname(__FILE__), '/fixtures/source.math')
      
      lexer = Lexeme.define do
        token 'OPEN'     => /^\($/
        token 'CLOS'     => /^\)$/
        token 'PLUS'     => /^\+$/
        token 'MINUS'    => /^\-$/
        token 'MULTI'    => /^\*$/
        token 'DIV'      => /^\/$/
        token 'NUMBER'   => /^\d+\.?\d?$/
        token 'FUNCTION' => /^(sqrt|pow|sin|cos|tan)$/
        token 'VAR'      => /^\w+\d?$/
      end
     
      lexer.analyze do 
        from_file source
      end
      
      lexer.tokens[4].name.should  be_eql('FUNCTION')
      lexer.tokens[4].value.should be_eql('sqrt')
    end

    it 'tokenize a program language pseudo code' do
      source = File.join(File.dirname(__FILE__), '/fixtures/source.pseudo')
      
      lexer = Lexeme.define do
        token :EQ       => /^=$/
        token :PLUS     => /^\+$/
        token :MINUS    => /^\-$/
        token :MULTI    => /^\*$/
        token :DIV      => /^\/$/
        token :NUMBER   => /^\d+\.?\d?$/
        token :RESERVED => /^(fin|print|func)$/
        token :STRING   => /^"[^"]*"?$/
        token :ID       => /^[\w_]+$/
      end

      lexer.analyze do 
        from_file source
      end
      
      lexer.tokens[-1].name.should  == :RESERVED 
      lexer.tokens[-1].value.should == 'fin'
    end

    it 'tokenizes a human language sentence' do 
      lexer = Lexeme.define do
        token :STOP     =>   /^\.$/
        token :COMA     =>   /^,$/
        token :QUES     =>   /^\?$/
        token :EXCLAM   =>   /^!$/
        token :QUOT     =>   /^"$/
        token :APOS     =>   /^'$/
        token :WORD     =>   /^[\w\-]+$/
      end
      
      tokens = lexer.analyze do  
        # ref: http://www.youtube.com/watch?v=6JGp7Meg42U 
        from_string 'Hello! My name is Inigo Montoya. You killed my father. Prepare to die.'
      end
      
      "#{tokens[0].name}: #{tokens[0].value}".should    be_eql 'WORD: Hello'
      "#{tokens[1].name}: #{tokens[1].value}".should    be_eql 'EXCLAM: !'
      "#{tokens[-1].name}: #{tokens[-1].value}".should  be_eql 'STOP: .'
    end
  end
end
