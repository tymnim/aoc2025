import gleam/string
import gleam/list
import gleam/result
import gleam/int

pub fn stage_one(text: String) -> Result(Int, Nil) {
  use ranges <- result.try(
    string.split(text, on: ",")
    |> list.map(parse_range)
    |> result.all
  )

  ranges
  |> list.map(fn (range) {
      range |> list.filter(split_two) |> int.sum
    })
  |> int.sum
  |> Ok
}

pub fn stage_two(text: String) -> Result(Int, Nil) {
  use ranges <- result.try(
    string.split(text, on: ",")
    |> list.map(parse_range)
    |> result.all
  )

  ranges
  |> list.map(fn (range) {
      range |> list.filter(split_many) |> int.sum
    })
  |> int.sum
  |> Ok
}

pub fn parse_range(range: String) -> Result(List(Int), Nil) {
  use #(start_str, end_str) <- result.try(string.split_once(range, "-"))
  use start <- result.try(int.parse(start_str))
  use end <- result.try(int.parse(end_str))
  Ok(list.range(start, end))
}

pub fn split_two(num: Int) {
  let digits = num |> int.to_string |> string.to_graphemes
  let size = num |> int.to_string |> string.length
  let chunk_size = size / 2
  case size % 2 {
    0 -> is_invalid(digits, chunk_size)
    _ -> False
  }
}

pub fn split_many(num) {
  let digits = num |> int.to_string |> string.to_graphemes
  let size = num |> int.to_string |> string.length

  list.range(1, size - 1)
  |> list.filter(fn (d) { size % d == 0 })
  |> list.any(fn (divisor) {
    size > 1 && is_invalid(digits, divisor)
  })

}

pub fn is_invalid(digits: List(String), chunk_size: Int) {
  let sequences = list.sized_chunk(digits, chunk_size)
  case list.first(sequences) {
    Ok(first) -> {
      list.all(sequences, fn (s) { s == first })
    }
    _ -> False
  }

}
