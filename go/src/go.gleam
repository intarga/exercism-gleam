import gleam/result

pub type Player {
  Black
  White
}

pub type Game {
  Game(
    white_captured_stones: Int,
    black_captured_stones: Int,
    player: Player,
    error: String,
  )
}

fn change_player(game: Game) -> Game {
  let new_player = case game.player {
    Black -> White
    White -> Black
  }

  Game(..game, player: new_player)
}

pub fn apply_rules(
  game: Game,
  rule1: fn(Game) -> Result(Game, String),
  rule2: fn(Game) -> Game,
  rule3: fn(Game) -> Result(Game, String),
  rule4: fn(Game) -> Result(Game, String),
) -> Game {
  let result =
    game |> rule1 |> result.map(rule2) |> result.try(rule3) |> result.try(rule4)

  case result {
    Ok(new_game) -> change_player(new_game)
    Error(e) -> Game(..game, error: e)
  }
}
