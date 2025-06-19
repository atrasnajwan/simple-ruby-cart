class Cart
  class Item
    attr_accessor :product, :quantity, :price, :discount
    
    def initialize(shop, product_code, quantity)
        @product = shop.products[product_code]
        @quantity = quantity
        @price = @product.price * quantity # price without discount
        @discount = 0.0
    end
    
    # price with discount
    def total_price
        price + discount
    end
    
    def update_quantity(qty)
        @quantity += qty
        update_price()
    end
    
    def update_price
        @price = @product.price * @quantity
    end
  end
end