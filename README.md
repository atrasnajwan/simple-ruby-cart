# Simple Ruby Cart System

# Overview
This is a configurable shopping cart system. It allows:
- Managing a dynamic product catalog
- Applying shipping cost rules based on total item value
- Applying flexible, data-driven promotions using configurable discount rules

# Features
- Add-to-cart system using product codes
- Shiipping cost rules based on total order item prices ($4.95, $2.95, or free)
- Promotional engine (e.g., "Buy One Red Widget, Get the Second Half Price")
- Discount logic is fully data-driven via configuration hashes
- Detailed `print_data` method to trace cart calculations

## Initialize Shop
Defined your shop and user first before any operation:

```ruby
my_shop = Shop.new
```

## Product Catalog
Defined via:

```ruby
my_shop.add_product("R01", "Red Widget", 32.95)
```

## Shipping Cost Rules
Shipping is dynamically calculated based on the cart's total item price:

```ruby
SHIPPING_COST_RULES = [
    {
      threshold: 90, # >= 90
      value: 0 # free shipping
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
my_shop.shipping_cost_rules = SHIPPING_COST_RULES
```
The system selects the first matching rule where `cart_total >= threshold`

## Promotion / Offer Rules
Promotion logic is configured as declarative hashes, not hardcoded methods. Example:
```ruby
PROMOTION_OFFERS = [
    {
        name: "Buy One Red Widget, Get The Second Half Price",
        item_discount_type: "percent",
        item_discount_value: 50,
        item_discount_quantity: 1,
        cart_rules: {
            items: [
            { code: ["product", "code"], operation: "==", value: "R01" },
            { code: "quantity", operation: ">=", value: 2 }
            ]
        },
        item_rules: [
            { code: ["product", "code"], operation: "==", value: "R01" }
        ]
    }
]
my_shop.promotion_offers = PROMOTION_OFFERS
```
### Explanation:
- `item_discount_type`: `percent`, percentage discount based on original price
- `item_discount_quantity`: Only 1 item gets discounted, if its negative value, it will apply to all items that matching
- `cart_rules.items`: Checks if the cart has at least 2 `R01` products.
- `item_rules`: Applies discount to each `R01` item with quantity `item_discount_quantity`

## Add Item to Cart
Need to create user first and then get the cart and after that add item to cart

```ruby
# init user
me = my_shop.add_user("Atras")
# get cart for user
my_cart = me.cart

my_cart.add_item("B01", 2)
```

# Summary
- Config-based approach: Rules are separated from logic, which allows future flexibility.
- Minimal mutation: Cart calculations are clearly separated, making the logic predictable and testable.
- Extensibility: Easy to support additional rule types like Buy X Get Y, free shipping, etc.
- Debuggability: The `print_data` method shows detailed breakdown per item — code, quantity, base price, discount, and total.
To run the application, execute the following command:


## Usage

```bash
ruby main.rb
```
