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

# init shop
my_shop = Shop.new

# add products to shop
PRODUCTS.map { |product| my_shop.add_product(product[:code], product[:name], product[:price])}
# add shipping cost rules to shop
my_shop.shipping_cost_rules = SHIPPING_COST_RULES
# init user
me = my_shop.add_user("Atras")
# get cart for user
my_cart = me.cart

my_cart.add_item("B01", 1)
my_cart.add_item("G01", 1)
my_cart.add_item("R01", 2)

my_cart.print_data()

