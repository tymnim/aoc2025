import gleam/string
import gleam/list
import gleam/result
import gleam/int

pub fn stage_one(text: String) -> Result(Int, Nil) {
  use joltages <- result.try(
    string.split(text, on: "\n")
    |> list.map(turn_batteries)
    |> result.all
  )

  Ok(int.sum(joltages))
}

pub fn turn_batteries(str: String) -> Result(Int, Nil) {
  let digits = string.to_graphemes(str)
  case digits {
    [first, second, ..rest] -> {
      use first <- result.try(int.parse(first))
      use second <- result.try(int.parse(second))
      iterate_batteries(rest, first, second)
    }
    _ -> Error(Nil)
  }
}

pub fn iterate_batteries(batteries: List(String), one, two) -> Result(Int, Nil) {
  case batteries {
    [] -> Ok(one * 10 + two)
    [digit, ..rest] -> {
      use num <- result.try(int.parse(digit))
      case two > one {
        True -> iterate_batteries(rest, two, num)
        False -> case num > two {
          True -> iterate_batteries(rest, one, num)
          False -> iterate_batteries(rest, one, two)
        }
      }
    }
  }
}
