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
pub fn stage_two(start_pos: Int, text: String) -> Result(Int, Nil) {
  use rotations <- result.try(
    string.split(text, on: "\n")
    |> list.map(parse_rotation)
    |> result.all
  )
  Ok(iterate_with_passing(rotations, start_pos, 0))

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
fn iterate_with_passing(list: List(Int), position: Int, counter: Int) {
  case list {
    [] -> counter
    [rotation, ..rest] -> {
      // EDGE CASE: if additional is 100 or -100 it doble counts rotations and stops at 0
      let additional = rotation % 100 + position
      let new_pos = {position + rotation} % 100
      let inc = int.absolute_value({position + rotation} / 100)
        + case swap_sign(position, new_pos) { True -> 1 False -> 0 }
        + case additional { 100 -> -1 -100 -> -1 _ -> 0 }

      iterate_with_passing(
        rest,
        new_pos,
        case new_pos { 0 -> counter + 1 + inc _ -> counter + inc }
      )
    }
  }
}

fn swap_sign(a: Int, b: Int) {
  a > 0 && b < 0 || a < 0 && b > 0
}

