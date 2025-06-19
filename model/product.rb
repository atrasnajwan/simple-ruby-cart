class Product
  attr_accessor :code, :name, :price
    
  def initialize(name, code, price)
      @name = name
      @code = code
      @price = price
  end
end