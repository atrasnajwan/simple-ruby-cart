class Cart
  attr_accessor :shop, :user, :items, :shipping_cost, 
                :total_quantity, :total_item_prices, :total_item_discount, :grand_total
                # :shipping_discount, :discount_total,
    
  def initialize(shop, user)
      @shop = shop
      @user = user
      @items = []
      @shipping_cost = 0.0
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
    @shipping_cost = get_shipping_cost()
    @grand_total = @total_item_prices + @shipping_cost
  end

  def get_shipping_cost
      rule = shop.shipping_cost_rules.find { |rule| total_item_prices >= rule[:threshold] }
      return 0 unless rule # default
      
      return rule[:value]
  end

  def print_data
    puts "--------"
    puts "|\tuser\t|\t#{user.name}\t|"
    puts "--------"
    puts "|\tproduct_code\t|\tquantity\t|\tprice\t|\tdiscount\t|\ttotal_price\t|"
    items.each do |item|
        puts "|\t\t#{item.product.code}\t|\t#{item.quantity}\t\t|\t#{item.price.round(2)}\t|\t#{item.discount.round(2)}\t\t|\t#{item.total_price.round(2)}\t\t|"
    end
    puts "--------"
    puts "|\ttotal_item_prices\t\t|\t\t#{total_item_prices.round(2)}\t|"
    puts "|\ttotal_item_discount\t\t|\t\t#{total_item_discount.round(2)}\t|"
    # puts "|\tdiscount_total\t\t\t|\t\t#{discount_total.round(2)}\t|"
    puts "|\tshipping_cost\t\t\t|\t\t#{shipping_cost.round(2)}\t|"
    puts "|\tgrand_total\t\t\t|\t\t#{grand_total.round(2)}\t|"
    puts "--------"
  end
end