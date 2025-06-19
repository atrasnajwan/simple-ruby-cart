class Cart
  attr_accessor :shop, :user, :items, :shipping_fee, 
                :total_quantity, :total_item_prices, :total_item_discount, :grand_total
                # :shipping_discount, :discount_total,
    
  def initialize(shop, user)
      @shop = shop
      @user = user
      @items = []
      @shipping_fee = 0.0
      # @shipping_discount = 0.0
      @total_quantity = 0
      @total_item_prices = 0.0 # total item price with discount
      @total_item_discount = 0.0   # total item discount only
      # @discount_total = 0.0 # sum of item discount and shipping_discount
      @grand_total = 0.0
  end

  def add_item(product_code, quantity)
    # check if product exist
    unless shop.products.key?(product_code)
      puts "product #{product_code} not found" 
      return 
    end
    
    puts "#{user.name } add #{quantity} pcs #{product_code} to cart" 

    # find item if exist
    item = items.find { |i| i.product.code == product_code}
    if item
        item.update_quantity(quantity)
    else
        item = Cart::Item.new(shop, product_code, quantity)
        items << item # add to cart
    end
    
    @total_quantity += quantity
    @total_item_prices += item.product.price * quantity
    @grand_total = @total_item_prices + @shipping_fee
  end

end