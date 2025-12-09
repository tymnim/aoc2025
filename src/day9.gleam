import gleam/string
import gleam/list
import gleam/int
import gleam/result

type Point {
  Point(x: Int, y: Int)
}

pub fn stage_one(input) -> Result(Int, Nil) {
  let raw_points = string.split(input, "\n")

  let assert Ok(points) = result.all(
    raw_points
    |> list.map(fn (raw) {
      use #(rx, ry) <- result.try(string.split_once(raw, ","))
      use x <- result.try(int.parse(rx))
      use y <- result.try(int.parse(ry))
      Ok(Point(x: x, y: y))
    })
  )

  let assert [first, ..rest] = points

  Ok(find_largest(first, rest, 0))
}

fn find_largest(first, list, area) {
  let ar = evaluate(first, list, area)
  case list {
    [] -> area
    [current, ..rest] -> {
      find_largest(current, rest, int.max(ar, area))
    }
  }
}

fn evaluate(point, list, area) {
    case list {
    [cur, ..rest] -> evaluate(point, rest, int.max(area, find_area(point, cur)))
    [] -> area
  }
}

fn find_area(p1: Point, p2: Point) -> Int {
  int.absolute_value(p1.x - p2.x + 1) * int.absolute_value(p1.y - p2.y + 1)
}
