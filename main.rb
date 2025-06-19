# load all models
Dir["./model/**/*.rb"].each { |file| require_relative file }

PRODUCTS = [
  {
    code: "R01",
    name: "Red Widget",
    price: 32.95
  },
  {
    code: "G01",
    name: "Greeen Widget",
    price: 24.95
  },
  {
    code: "B01",
    name: "Blue Widget",
    price: 7.95
  }
]

SHIPPING_COST_RULES = [
    {
      threshold: 90, # >= 90
      value: 0
    },
    {
      threshold: 50, # >= 50
      value: 2.95
    },
    {
      threshold: 0, # >= 0
      value: 4.95
    },
]

PROMOTION_OFFERS = [
  {
    name: "Buy One Red Widget, Get The Second Half Price",
    # applied to each item matching
    item_discount_type: "percent", # percent|absolute
    item_discount_value: 50, # 0-100 -> percent
    item_discount_quantity: 1, # negative value to all items
    # cart must meets this condition to apply
    cart_rules: {
        # available key: items, total_quantity, total_item_prices
        items: [
          # available code: product, quantity, price
          {
              code: ["product", "code"], # it will get Cart::Item.product.code
              # available operation: ==, !=, >, >=, <, <=, include?, include? using for OR condition/only need meet one condition from array
              operation: "==",
              value: "R01"
          },
          {
              code: "quantity",
              operation: ">=",
              value: 2
          }
        ],
        # total_quantity: [
        #   {
        #       operation: ">=",
        #       value: 10
        #   }
        # ]
    },
    # cart items applied to
    item_rules: [
      {
        code: ["product", "code"],
        operation: "==",
        value: "R01" # if operation is include?, this value must be array
      }
    ]
  }
]
# init shop
my_shop = Shop.new

# add products to shop
PRODUCTS.map { |product| my_shop.add_product(product[:code], product[:name], product[:price])}
# add shipping cost rules to shop
my_shop.shipping_cost_rules = SHIPPING_COST_RULES
# add shipping cost rules to shop
my_shop.promotion_offers = PROMOTION_OFFERS
# init user
me = my_shop.add_user("Atras")
# get cart for user
my_cart = me.cart

my_cart.add_item("B01", 2)
# my_cart.add_item("G01", 1)
my_cart.add_item("R01", 3)
# my_cart.add_item("R01", 1)

my_cart.print_data()
