module DBSanitize
  def string(value)
    value.gsub!(/'/, '') unless value.nil?
    value.nil? ? 'NULL' : "'#{value}'"
  end
  def integer(value)
    value.nil? ? 'NULL' : Integer(value)
  end
  def boolean(value)
    value == '1'
  end
end
