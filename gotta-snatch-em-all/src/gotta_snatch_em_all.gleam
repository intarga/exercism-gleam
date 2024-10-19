import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string

pub fn new_collection(card: String) -> Set(String) {
  set.from_list([card])
}

pub fn add_card(collection: Set(String), card: String) -> #(Bool, Set(String)) {
  #(set.contains(collection, card), set.insert(collection, card))
}

pub fn trade_card(
  my_card: String,
  their_card: String,
  collection: Set(String),
) -> #(Bool, Set(String)) {
  let possible = set.contains(collection, my_card)
  let worth_doing = !set.contains(collection, their_card)

  let new_collection =
    collection |> set.delete(my_card) |> set.insert(their_card)

  #(possible && worth_doing, new_collection)
}

pub fn boring_cards(collections: List(Set(String))) -> List(String) {
  collections
  |> list.reduce(set.intersection)
  |> result.unwrap(set.new())
  |> set.to_list
}

pub fn total_cards(collections: List(Set(String))) -> Int {
  collections
  |> list.reduce(set.union)
  |> result.unwrap(set.new())
  |> set.size
}

pub fn shiny_cards(collection: Set(String)) -> Set(String) {
  collection |> set.filter(fn(card) { string.starts_with(card, "Shiny ") })
}
