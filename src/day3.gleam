import gleam/string
import gleam/list
import gleam/result
import gleam/int
import gleam/float

pub fn stage_one(text: String) -> Result(Int, Nil) {
  use joltages <- result.try(
    string.split(text, on: "\n")
    |> list.map(turn_batteries(2))
    |> result.all
  )

  Ok(int.sum(joltages))
}

pub fn stage_two(text: String) -> Result(Int, Nil) {
  use joltages <- result.try(
    string.split(text, on: "\n")
    |> list.map(turn_batteries(12))
    |> result.all
  )

  Ok(int.sum(joltages))
}

fn turn_batteries(length: Int) {
  fn (str: String) -> Result(Int, Nil) {
    use digits <- result.try(str |> string.to_graphemes |> list.map(int.parse) |> result.all)

    let #(sequence, rest) = list.split(digits, length)
    use batteries <- result.try(turn(sequence, rest))

    let res = batteries
    |> list.reverse
    |> list.index_map(fn (num, i) {
      // I DON'T CARE AT THIS POINT
      let assert Ok(order) = int.power(10, int.to_float(i))
      float.truncate(int.to_float(num) *. order)
    })
    |> int.sum

    Ok(res)
  }
}

fn turn(current_sequence: List(Int), remaining: List(Int)) -> Result(List(Int), Nil) {
  case remaining {
    [] -> Ok(current_sequence)
    [num, ..rest] -> {
      let assert [first, ..rem] = current_sequence
      let new_seq = iter(first, [], rem, num)
      turn(new_seq, rest)
    }
  }
}

fn iter(prev, new_list, remaining_list, num) {
  case remaining_list {
    [] -> list.append(new_list, [int.max(prev, num)])
    [cur, ..rest] -> case cur > prev {
      True -> list.append(new_list, list.append(remaining_list, [num]))
      False -> iter(cur, list.append(new_list, [prev]), rest, num)
    }
  }
}

