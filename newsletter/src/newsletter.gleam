import gleam/iterator
import gleam/list
import gleam/result
import gleam/string
import simplifile

pub fn read_emails(path: String) -> Result(List(String), Nil) {
  case simplifile.read(path) {
    Ok(contents) ->
      Ok(
        string.split(contents, "\n")
        |> list.filter(fn(email) { !string.is_empty(email) }),
      )
    Error(_) -> Error(Nil)
  }
}

pub fn create_log_file(path: String) -> Result(Nil, Nil) {
  simplifile.create_file(path) |> result.replace_error(Nil)
}

pub fn log_sent_email(path: String, email: String) -> Result(Nil, Nil) {
  simplifile.append(path, email <> "\n") |> result.replace_error(Nil)
}

pub fn send_newsletter(
  emails_path: String,
  log_path: String,
  send_email: fn(String) -> Result(Nil, Nil),
) -> Result(Nil, Nil) {
  use emails <- result.try(read_emails(emails_path))
  use _ <- result.try(create_log_file(log_path))

  emails
  |> iterator.from_list
  |> iterator.each(fn(email) {
    case send_email(email) {
      Ok(_) -> log_sent_email(log_path, email)
      Error(_) -> Error(Nil)
    }
  })

  Ok(Nil)
}
