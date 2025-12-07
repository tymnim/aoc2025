import gleam/string
import gleam/list

type Current {
  Single(Int)
  Split(Int)
}

pub fn stage_one(input) -> Result(Int, Nil) {
  let assert [first, ..rest] = string.split(input, "\n")

  let assert Ok(initial) = find_initial_current(string.to_graphemes(first), 0)

  Ok(iterate([initial], rest, 0))
}

fn find_initial_current(chars: List(String), index) -> Result(Int, Nil) {
  case chars {
    [char, ..rest] -> case char {
      "S" -> Ok(index)
      _ -> find_initial_current(rest, index + 1)
    }
    [] -> Error(Nil)
  }
}

fn iterate(previous: List(Int), lines: List(String), count: Int) -> Int {
  case lines {
    [_, split_line, ..rest] -> {
      let chars = string.to_graphemes(split_line)
      let currents = split(previous, chars)
      let split_count = list.count(currents, fn (c) { case c { Split(_) -> True _ -> False } })
      let next = currents
      |> list.map(fn (c) { case c { Split(i) -> [i-1, i+1] Single(i) -> [i] } })
      |> list.flatten
      |> list.unique
      iterate(next, rest, count + split_count)
    }
    _ -> count
  }
}

fn split(currents: List(Int), chars: List(String)) {
  let indexed = chars
  |> list.index_map(fn (x, i) { #(x, i) })
  |> list.filter(fn (x) { x.0 == "^" })

  currents
  |> list.map(fn(c) {
    let is_split = list.find(indexed, fn (x) { x.1 == c })
    case is_split {
      Ok(_) -> Split(c)
      _ -> Single(c)
    }
  })
}

