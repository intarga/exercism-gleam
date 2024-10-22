import gleam/string

// Please define the TreasureChest type
pub opaque type TreasureChest(a) {
  TreasureChest(password: String, contents: a)
}

pub fn create(
  password: String,
  contents: treasure,
) -> Result(TreasureChest(treasure), String) {
  case string.length(password) >= 8 {
    True -> Ok(TreasureChest(password, contents))
    _ -> Error("Password must be at least 8 characters long")
  }
}

pub fn open(
  chest: TreasureChest(treasure),
  password: String,
) -> Result(treasure, String) {
  case password == chest.password {
    True -> Ok(chest.contents)
    _ -> Error("Incorrect password")
  }
}
