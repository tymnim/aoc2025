import gleam/string
import gleam/list
import gleam/result
import gleam/int

type Range {
  Range(Int, Int)
}

pub fn stage_one(text: String) -> Result(Int, Nil) {
  let res = text
  |> string.split("\n")
  |> parse_ranges([])

  res
}

pub fn stage_two(text: String) -> Result(Int, Nil) {
  use res <- result.try(text
  |> string.split("\n")
  |> parse_ranges_two([]))

  Ok(count_ranges(res))
}

fn parse_ranges(input: List(String), ranges: List(Range)) -> Result(Int, Nil) {
  case input {
    [line, ..rest] -> case line {
      "" -> parse_ingridients(rest, ranges, 0)
      range -> case string.split_once(range, "-") {
        Ok(#(start, end)) -> {
          use s <- result.try(int.parse(start))
          use e <- result.try(int.parse(end))
          parse_ranges(rest, list.append(ranges, [Range(int.min(s, e), int.max(s, e))]))
        }
        _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

fn parse_ingridients(input: List(String), ranges: List(Range), count: Int) -> Result(Int, Nil) {
  case input {
    [ingridient, ..rest] -> {
      use id <- result.try(int.parse(ingridient))
      case list.find(ranges, fn (range) { in_range(range, id) }) {
        Ok(_) -> parse_ingridients(rest, ranges, count + 1)
        _ -> parse_ingridients(rest, ranges, count)
      }
    }
    _ -> Ok(count)
  }
}

fn in_range(range: Range, num: Int) -> Bool {
  let Range(start, end) = range
  num >= start && num <= end
}

fn parse_ranges_two(input: List(String), ranges: List(Range)) -> Result(List(Range), Nil) {
  case input {
    [line, ..rest] -> case line {
      "" -> Ok(ranges)
      range -> case string.split_once(range, "-") {
        Ok(#(start, end)) -> {
          use s <- result.try(int.parse(start))
          use e <- result.try(int.parse(end))
          let new_ranges = potential_merge(ranges, Range(int.min(s, e), int.max(s, e)), [])
          parse_ranges_two(rest, new_ranges)
        }
        _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

fn count_ranges(r: List(Range)) {
  r
  |> list.map(fn (range) {
    let Range(a, b) = range
    b - a + 1
  })
  |> int.sum
}

fn potential_merge(ranges, new_range, new_ranges) {
  case ranges {
    [range, ..rest] -> {
      case range_overlap(range, new_range) {
        False -> potential_merge(rest, new_range, [range, ..new_ranges])
        True -> potential_merge(rest, merge_ranges(range, new_range), new_ranges)
      }
    }
    [] -> [new_range, ..new_ranges]
  }
}

fn merge_ranges(r1, r2) {
  let Range(a, b) = r1
  let Range(c, d) = r2
  Range(int.min(a, c), int.max(b, d))
}

fn range_overlap(r1: Range, r2: Range) {
  let Range(a, b) = r1
  let Range(c, d) = r2

  in_range(r1, c)
  || in_range(r1, d)
  || in_range(r2, a)
  || in_range(r2, b)
}
