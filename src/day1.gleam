import gleam/string
import gleam/list
import gleam/result
import gleam/int

pub fn stage_one(start_pos: Int, text: String) -> Result(Int, Nil) {
  use rotations <- result.try(
    string.split(text, on: "\n")
    |> list.map(parse_rotation)
    |> result.all
  )

  Ok(iterate(rotations, start_pos, 0))
}

fn parse_rotation(rotation) -> Result(Int, Nil) {
  case rotation {
    "L" <> raw_amount -> {
      use amount <- result.try(int.parse(raw_amount))
      Ok(-amount)
    }
    "R" <> raw_amount -> {
      use amount <- result.try(int.parse(raw_amount))
      Ok(amount)
    }
    _ -> Error(Nil)
  }
}

fn iterate(list: List(Int), position: Int, counter: Int) {
  case list {
    [] -> counter
    [rotation, ..rest] -> {
      let new_pos = {position + rotation} % 100
      iterate(rest, new_pos, case new_pos { 0 -> counter + 1 _ -> counter })
    }
  }
}

