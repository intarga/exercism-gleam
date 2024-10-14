import gleam/string

pub fn message(log_line: String) -> String {
  case string.split_once(log_line, ":") {
    Ok(#(_, message)) -> string.trim(message)
    Error(_) -> ""
  }
}

pub fn log_level(log_line: String) -> String {
  case string.split_once(log_line, ":") {
    Ok(#(level_raw, _)) ->
      level_raw
      |> string.drop_left(1)
      |> string.drop_right(1)
      |> string.lowercase
    Error(_) -> ""
  }
}

pub fn reformat(log_line: String) -> String {
  message(log_line) <> " (" <> log_level(log_line) <> ")"
}
