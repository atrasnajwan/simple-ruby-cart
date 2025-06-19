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
end