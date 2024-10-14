import gleam/list

pub fn place_location_to_treasure_location(
  place_location: #(String, Int),
) -> #(Int, String) {
  #(place_location.1, place_location.0)
}

pub fn treasure_location_matches_place_location(
  place_location: #(String, Int),
  treasure_location: #(Int, String),
) -> Bool {
  place_location_to_treasure_location(place_location) == treasure_location
}

pub fn count_place_treasures(
  place: #(String, #(String, Int)),
  treasures: List(#(String, #(Int, String))),
) -> Int {
  list.count(treasures, fn(treasure) {
    treasure_location_matches_place_location(place.1, treasure.1)
  })
}

pub fn special_case_swap_possible(
  found_treasure: #(String, #(Int, String)),
  place: #(String, #(String, Int)),
  desired_treasure: #(String, #(Int, String)),
) -> Bool {
  case found_treasure.0 {
    "Brass Spyglass" -> place.0 == "Abandoned Lighthouse"
    "Amethyst Octopus" ->
      place.0 == "Stormy Breakwater"
      && {
        desired_treasure.0 == "Crystal Crab"
        || desired_treasure.0 == "Glass Starfish"
      }
    "Vintage Pirate Hat" ->
      place.0 == "Harbor Managers Office"
      && {
        desired_treasure.0 == "Antique Glass Fishnet Float"
        || desired_treasure.0 == "Model Ship in Large Bottle"
      }
    _ -> False
  }
}
