import gleam/int
import gleam/option.{type Option, None, Some}

pub type Player {
  Player(name: Option(String), level: Int, health: Int, mana: Option(Int))
}

pub fn introduce(player: Player) -> String {
  case player.name {
    Some(name) -> name
    None -> "Mighty Magician"
  }
}

pub fn revive(player: Player) -> Option(Player) {
  case player.health <= 0 {
    True ->
      Some(
        Player(
          ..player,
          health: 100,
          mana: case player.level >= 10 {
            True -> Some(100)
            False -> player.mana
          },
        ),
      )
    False -> None
  }
}

pub fn cast_spell(player: Player, cost: Int) -> #(Player, Int) {
  case player.mana {
    Some(x) if x >= cost -> #(Player(..player, mana: Some(x - cost)), 2 * cost)
    None -> #(Player(..player, health: int.max(player.health - cost, 0)), 0)
    _ -> #(player, 0)
  }
}
