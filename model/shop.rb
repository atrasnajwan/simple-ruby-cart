class Shop
  attr_accessor :products, :users, :shipping_cost_rules, :promotion_offers
    
  def initialize
      @products = {}
      @users = {}
      @shipping_cost_rules = []
      @promotion_offers = []
  end
  
  # add product to this shop
  def add_product(code, name, price)
      return "Please include code of product" unless code
      return "Please include name of product" unless name
      return "Please include price of product" unless price

      products[code] = Product.new(name, code, price)
  end

  # add user to this shop
  def add_user(name)
      return "Please include name" unless name
      
      users[name] = User.new(self, name)
  end
  
end