// TODO: please define the 'Approval' custom type
pub type Approval {
  Yes
  No
  Maybe
}

// TODO: please define the 'Cuisine' custom type
pub type Cuisine {
  Korean
  Turkish
}

// TODO: please define the 'Genre' custom type
pub type Genre {
  Crime
  Horror
  Romance
  Thriller
}

// TODO: please define the 'Activity' custom type
pub type Activity {
  BoardGame
  Chill
  Movie(genre: Genre)
  Restaurant(cuisine: Cuisine)
  Walk(kilometers: Int)
}

pub fn rate_activity(activity: Activity) -> Approval {
  case activity {
    Movie(g) if g == Romance -> Yes
    Restaurant(c) if c == Korean -> Yes
    Restaurant(c) if c == Turkish -> Maybe
    Walk(k) if k > 11 -> Yes
    Walk(k) if k > 6 -> Maybe
    _ -> No
  }
}
