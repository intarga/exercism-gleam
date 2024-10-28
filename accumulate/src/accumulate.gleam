import gleam/list

pub fn accumulate(list: List(a), fun: fn(a) -> b) -> List(b) {
  case list {
    [first, ..rest] -> list.prepend(accumulate(rest, fun), fun(first))
    [] -> []
  }
}
