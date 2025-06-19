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

# init shop
my_shop = Shop.new

# add products to shop
PRODUCTS.map { |product| my_shop.add_product(product[:code], product[:name], product[:price])}

# init user
me = my_shop.add_user("Atras")
# get cart for user
my_cart = me.cart

