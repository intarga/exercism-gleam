pub fn today(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [x, ..] -> x
  }
}

pub fn increment_day_count(days: List(Int)) -> List(Int) {
  case days {
    [] -> [1]
    [x, ..rest] -> [x + 1, ..rest]
  }
}

pub fn has_day_without_birds(days: List(Int)) -> Bool {
  case days {
    [] -> False
    [x, ..rest] -> x == 0 || has_day_without_birds(rest)
  }
}

pub fn total(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [x, ..rest] -> x + total(rest)
  }
}

pub fn busy_days(days: List(Int)) -> Int {
  case days {
    [] -> 0
    [x, ..rest] ->
      case x >= 5 {
        True -> 1
        False -> 0
      }
      + busy_days(rest)
  }
}
