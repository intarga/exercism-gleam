import gleam/result
import gleam/string

pub fn first_letter(name: String) {
  name |> string.trim |> string.first |> result.unwrap("")
}

pub fn initial(name: String) {
  let the_first_letter = name |> first_letter
  case the_first_letter {
    "" -> ""
    _ ->
      the_first_letter
      |> string.uppercase
      |> string.append(".")
  }
}

pub fn initials(full_name: String) {
  full_name
  |> string.trim
  |> string.split_once(" ")
  |> result.unwrap(#(full_name |> string.trim, ""))
  |> fn(pair) { initial(pair.0) <> " " <> initial(pair.1) }
  |> string.trim
}

pub fn pair(full_name1: String, full_name2: String) {
  "
     ******       ******
   **      **   **      **
 **         ** **         **
**            *            **
**                         **
**     " <> initials(full_name1) <> "  +  " <> initials(full_name2) <> "     **
 **                       **
   **                   **
     **               **
       **           **
         **       **
           **   **
             ***
              *
"
}
