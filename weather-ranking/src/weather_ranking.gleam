import gleam/float
import gleam/list
import gleam/order.{type Order}

pub type City {
  City(name: String, temperature: Temperature)
}

pub type Temperature {
  Celsius(Float)
  Fahrenheit(Float)
}

pub fn fahrenheit_to_celsius(f: Float) -> Float {
  { f -. 32.0 } /. 1.8
}

fn temperature_to_celsius(t: Temperature) -> Float {
  case t {
    Celsius(f) -> f
    Fahrenheit(f) -> fahrenheit_to_celsius(f)
  }
}

pub fn compare_temperature(left: Temperature, right: Temperature) -> Order {
  float.compare(temperature_to_celsius(left), temperature_to_celsius(right))
}

pub fn sort_cities_by_temperature(cities: List(City)) -> List(City) {
  list.sort(cities, fn(city1, city2) {
    compare_temperature(city1.temperature, city2.temperature)
  })
}