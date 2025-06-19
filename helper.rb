module Helper
  # call string method from object/variable
  def self.get_object_from_string(object, code)
    return object.send(code) unless code.is_a?(Array)
    code.each do |c|
      object = get_object_from_string(object, c)
    end
    return object
  end

  # execute operation from string
  def self.compare(object, operation, value)
    if operation == "include?"
      value.send(operation, object)
    else
      object.send(operation, value)
    end
  end
end