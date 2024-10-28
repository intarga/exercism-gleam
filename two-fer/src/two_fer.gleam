import gleam/option.{type Option}

pub fn two_fer(name: Option(String)) -> String {
  let name = option.unwrap(name, "you")
  "One for " <> name <> ", one for me."
}
