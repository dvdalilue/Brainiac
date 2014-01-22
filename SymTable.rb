# -*- coding: utf-8 -*-
#SymTable

class RedefineError < RuntimeError
  def initialize(token, token_viejo)
    @token = token
    @token_viejo = token_viejo
  end

  def to_s
    "Error en línea #{@token.line}, columna #{@token.column}: la variable '#{@token.text}' fue previamente declarada en la línea #{@token_viejo.line}, columna #{@token_viejo.column}."
  end
end

class DeleteError < RuntimeError
  def initialize(token)
    @token = token
  end

  def to_s
    "Error no se puede eliminar el token '#{@token.text}'"
  end
end

class SymTable

  def initialize(padre = nil)
    @padre = padre
    @table = {}
  end

  def insert(token, tipo)
    raise RedefinirError::new(token, @table[token.texto][:token]) if @table.has_key?(token.text)
    @table[token.text] = { :token => token, :tipo => tipo}
  end

  def delete(nombre)
    raise DeleteError::new token unless @table.has_key?(nombre)
    @table.delete(nombre)
  end

  def find(nombre)
    if @table.has_key?(nombre) then
      return @table[nombre]
    elsif @padre.nil? then
      return nil
    end
    @padre.find(nombre)
  end

  def isMember?(nombre)
    return @table.has_key?(nombre)
  end
end
