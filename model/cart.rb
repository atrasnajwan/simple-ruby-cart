class Cart
  attr_accessor :shop, :user, :items, :shipping_cost, 
                :total_quantity, :total_item_prices, :subtotal_item_prices, :total_item_discount, :grand_total
                # :shipping_discount, :discount_total,
    
  def initialize(shop, user)
      @shop = shop
      @user = user
      @items = []
      @shipping_cost = 0.0
      # @shipping_discount = 0.0
      @total_quantity = 0
      @total_item_prices = 0.0 # total item price WITHOUT discount
      @subtotal_item_prices = 0.0 # total item price with discount
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
    discount = get_discount()
    @total_item_discount = discount[:items]
    @subtotal_item_prices = total_item_prices + discount[:items]
    @shipping_cost = get_shipping_cost()
    @grand_total = @subtotal_item_prices + @shipping_cost
  end

  def get_shipping_cost
      # get shipping discount from total price with discount
      rule = shop.shipping_cost_rules.find { |rule| subtotal_item_prices >= rule[:threshold] }
      return 0 unless rule # default
      
      return rule[:value]
  end

  def get_discount
    item_discount = 0
    shipping_discount = 0
    shop.promotion_offers.each do |offer|
      # check if meets condition
      valid = offer[:cart_rules].all? do |key, rules| # all? to check all condition is true
        object = get_object_from_string(self, key) # call function
        if object.is_a?(Array) # check object an array
          result = object.map do |object_item|
              rules.all? do |rule| # all? to check all true
                  object_to_compare = get_object_from_string(object_item, rule[:code])
                  compare(object_to_compare, rule[:operation], rule[:value])
              end
          end
          result.include?(true) # on array object, just need 1 item match all rules
        else
          rules.all? do |rule| # all? to check all true
            compare(object, rule[:operation], rule[:value])
          end
        end
      end
      puts "valid #{valid}"
      next unless valid
      
      # apply discount
      items.each do |item|
        valid = offer[:item_rules].all? do |rule|
          object_to_compare = get_object_from_string(item, rule[:code])
          compare(object_to_compare, rule[:operation], rule[:value])
        end
        next unless valid # only apply to matching item
        
        discount = case offer[:item_discount_type]
                   when "percent"
                      value = [offer[:item_discount_value], 0].max # min 0% | handle negative value
                      value = 100 if value > 100 # max 100%
                      price_per_pcs = item.product.price
                       
                      quantity = offer[:item_discount_quantity]
                      # handle if quantity exceed current quantity or negative
                      quantity = item.quantity if quantity < 0 || quantity > item.quantity 
                      price_per_pcs * quantity * (value/100.0)
                   when "absolute" # absolute
                      price_per_pcs = item.product.price
                      if offer[:item_discount_value] > price_per_pcs # if exceed value
                        price_per_pcs * item.quantity
                      else
                        offer[:item_discount_value] * item.quantity
                      end
                   else
                      0
                   end
        # apply to cart.items
        item.discount = -discount
        item_discount += discount
      end
    end
    
    return {
      total: -(shipping_discount + item_discount),
      # shipping: -shipping_discount,
      items: -item_discount
    }
  end

  # call string method from object/variable
  def get_object_from_string(object, code)
      return object.send(code) unless code.is_a?(Array)
      code.each do |c|
        object = get_object_from_string(object, c)
      end
      return object
  end

  # execute operation from string
  def compare(object, operation, value)
      if operation == "include?"
        value.send(operation, object)
      else
        object.send(operation, value)
      end
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
    puts "|\tsubtotal_item_prices\t\t|\t\t#{subtotal_item_prices.round(2)}\t|"
    puts "|\tshipping_cost\t\t\t|\t\t#{shipping_cost.round(2)}\t|"
    puts "|\tgrand_total\t\t\t|\t\t#{grand_total.round(2)}\t|"
    puts "--------"
  end
end