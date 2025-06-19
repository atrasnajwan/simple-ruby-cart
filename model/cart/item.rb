class Cart
  class Item
    attr_accessor :product, :quantity, :valid, :price, :discount
    
    def initialize(shop, product_code, quantity)
        @valid = shop.products.key?(product_code)
        @product = shop.products[product_code]
        @quantity = quantity
        @price = @product.price * quantity # price without discount
        @discount = 0.0
    end
  end
end