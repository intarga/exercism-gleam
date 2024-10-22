import gleam/iterator.{type Iterator}

pub type Item {
  Item(name: String, price: Int, quantity: Int)
}

pub fn item_names(items: Iterator(Item)) -> Iterator(String) {
  use item <- iterator.map(items)
  item.name
}

pub fn cheap(items: Iterator(Item)) -> Iterator(Item) {
  use item <- iterator.filter(items)
  item.price < 30
}

pub fn out_of_stock(items: Iterator(Item)) -> Iterator(Item) {
  use item <- iterator.filter(items)
  item.quantity <= 0
}

pub fn total_stock(items: Iterator(Item)) -> Int {
  use acc, item <- iterator.fold(items, 0)
  acc + item.quantity
}

pub fn identifier(
  start: String,
  inner: String,
  reserved: Set(String),
  to_value: fn(String) -> a,
) -> Matcher(a, mode) {
  let assert Ok(ident) = regex.from_string("^" <> start <> inner <> "*$")
  let assert Ok(inner) = regex.from_string(inner)

  Matcher(fn(mode, lexeme, lookahead) {
    case regex.check(inner, lookahead), regex.check(ident, lexeme) {
      True, True -> Skip
      False, True ->
        case set.contains(reserved, lexeme) {
          True -> NoMatch
          False -> Keep(to_value(lexeme), mode)
        }
      _, _ -> NoMatch
    }
  })
}
