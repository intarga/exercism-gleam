// TODO: please define the Pizza custom type
pub type Pizza {
  Margherita
  Caprese
  Formaggio
  ExtraSauce(Pizza)
  ExtraToppings(Pizza)
}

pub fn pizza_price(pizza: Pizza) -> Int {
  case pizza {
    Margherita -> 7
    Caprese -> 9
    Formaggio -> 10
    ExtraSauce(inner_pizza) -> 1 + pizza_price(inner_pizza)
    ExtraToppings(inner_pizza) -> 2 + pizza_price(inner_pizza)
  }
}

pub fn order_price(order: List(Pizza)) -> Int {
  case order {
    [] -> 0
    [x] -> 3 + pizza_price(x)
    [x, y] -> 2 + order_price_recurse([x, y])
    x -> order_price_recurse(x)
  }
}

fn order_price_recurse(order: List(Pizza)) -> Int {
  case order {
    [] -> 0
    [x, ..rest] -> pizza_price(x) + order_price_recurse(rest)
  }
}
