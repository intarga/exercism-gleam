import gleam/iterator
import gleam/list

fn next_row(row: List(Int)) -> List(Int) {
  list.concat([
    [1],
    list.window_by_2(row) |> list.map(fn(pair) { pair.0 + pair.1 }),
    [1],
  ])
}

pub fn rows(n: Int) -> List(List(Int)) {
  let pascal = iterator.unfold([1], fn(x) { iterator.Next(x, next_row(x)) })
  pascal |> iterator.take(n) |> iterator.to_list
}
