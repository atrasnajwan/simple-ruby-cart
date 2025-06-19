class User
  attr_accessor :shop, :name, :cart

  def initialize(shop, name)
    @shop = shop
    @name = name
    @cart = Cart.new(shop, self)
  end
end