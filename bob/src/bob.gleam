import gleam/string

pub fn hey(remark: String) -> String {
  let remark = string.trim(remark)

  let is_question = string.ends_with(remark, "?")
  let is_all_caps =
    string.uppercase(remark) == remark
    && string.uppercase(remark) != string.lowercase(remark)
  let is_silence = remark == ""

  case is_question, is_all_caps, is_silence {
    True, False, _ -> "Sure."
    False, True, _ -> "Whoa, chill out!"
    True, True, _ -> "Calm down, I know what I'm doing!"
    _, _, True -> "Fine. Be that way!"
    _, _, _ -> "Whatever."
  }
}
