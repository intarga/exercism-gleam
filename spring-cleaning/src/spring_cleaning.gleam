import gleam/string

pub fn extract_error(problem: Result(a, b)) -> b {
  let assert Error(e) = problem
  e
}

pub fn remove_team_prefix(team: String) -> String {
  string.drop_left(team, 5)
}

pub fn split_region_and_team(combined: String) -> #(String, String) {
  let assert Ok(#(region, team)) = string.split_once(combined, ",")
  #(region, remove_team_prefix(team))
}
