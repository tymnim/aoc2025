import gleam/string
import gleam/list
import gleam/int
import gleam/result

type Point {
  Point(x: Int, y: Int)
}

type Vertex {
  Vertex(
    a: Point,
    vertex: Point,
    b: Point,
    direction: Direction,
    kind: VertexType // becasue type word is reserved...
  )
}

type Direction {
  NE NW SE SW
}

type VertexType {
  Convex
  Concave
}

type Line {
  Line(Point, Point)
}

pub fn stage_one(input) -> Result(Int, Nil) {
  let raw_points = string.split(input, "\n")

  use points <- result.try(
    raw_points
    |> list.map(new_point)
    |> result.all
  )

  let assert [first, ..rest] = points

  Ok(find_largest(first, rest, 0))
}

pub fn stage_two(input) -> Result(Int, Nil) {
  let raw_points = string.split(input, "\n")

  use points <- result.try(
    raw_points
    |> list.map(new_point)
    |> result.all
  )

  use vertices <- result.try(find_vertices(points))
  use outlines <- result.try(find_lines(points))

  vertices
  |> list.map(fn (v) { find_largest_area_of_vertex(v, points, outlines) })
  |> list.fold(0, int.max)
  |> Ok
}

fn find_largest_area_of_vertex(vertex: Vertex, points: List(Point), outlines: List(Line)) {
  points
  |> list.filter_map(fn (point) { valid_point_area(vertex, point, points, outlines) })
  |> list.fold(0, int.max)
}

fn valid_point_area(vertex: Vertex, point: Point, all_points: List(Point), outlines: List(Line)) {
  case vertex.kind {
    Concave -> Error(Nil)
    Convex -> case is_point_in_range(vertex, point) {
        False -> Error(Nil)
        True -> valid_points(vertex, point, all_points, outlines)
      }
  }
}

fn valid_points(vertex: Vertex, point: Point, points: List(Point), outlines: List(Line)) {
  case points {
    [] -> {
      case find_intersect(outlines, Line(vertex.vertex, point)) {
        Ok(_) -> Error(Nil)
        _ -> Ok(find_area(vertex.vertex, point))
      }
    }
    [p, ..rest] -> {
      case p == vertex.a || p == vertex.vertex || p == vertex.b || p == point {
        False -> {
          case is_between(vertex.vertex, point, p) {
            True -> Error(Nil)
            False -> valid_points(vertex, point, rest, outlines)
          }
        }
        True -> valid_points(vertex, point, rest, outlines)
      }
    }
  }
}

fn find_intersect(outlines, diagonal) -> Result(Line, Nil){
  case outlines {
    [line, ..rest] -> case intersects(line, diagonal) {
      True -> Ok(line)
      False -> find_intersect(rest, diagonal)
    }
    [] -> Error(Nil)
  }
}

fn intersects(l1: Line, l2: Line) -> Bool {
  let Line(p1, p2) = l1
  let Line(p3, p4) = l2

  // dont care about the if lines share the same ends..
  case p1 == p3 || p1 == p4 || p2 == p3 || p2 == p4 {
    True -> False
    False -> {
      let d1 = direction(p1, p2, p3)
      let d2 = direction(p1, p2, p4)
      let d3 = direction(p3, p4, p1)
      let d4 = direction(p3, p4, p2)

      case {{d1 > 0 && d2 < 0} || {d1 < 0 && d2 > 0}} &&
           {{d3 > 0 && d4 < 0} || {d3 < 0 && d4 > 0}} {
        True -> True
        False -> {
          {d1 == 0 && on_segment(p1, p2, p3)}
          || {d2 == 0 && on_segment(p1, p2, p4)}
          || {d3 == 0 && on_segment(p3, p4, p1)}
          || {d4 == 0 && on_segment(p3, p4, p2)}
        }
      }
    }
  }
}

fn on_segment(a: Point, b: Point, c: Point) -> Bool {
  c.x >= int.min(a.x, b.x)
  && c.x <= int.max(a.x, b.x)
  && c.y >= int.min(a.y, b.y)
  && c.y <= int.max(a.y, b.y)
}

fn direction(a: Point, b: Point, c: Point) -> Int {
  {c.x - a.x} * {b.y - a.y} - {b.x - a.x} * {c.y - a.y}
}

fn is_between(p1: Point, p2: Point, target: Point) {
  int.min(p1.x, p2.x) <= target.x
  && int.max(p1.x, p2.x) >= target.x
  && int.min(p1.y, p2.y) <= target.y
  && int.max(p1.y, p2.y) >= target.y
}

fn is_point_in_range(v: Vertex, p: Point) -> Bool {
  case v.direction {
    NE -> v.vertex.x < p.x && v.vertex.y < p.y
    SE -> v.vertex.x < p.x && v.vertex.y > p.y
    SW -> v.vertex.x > p.x && v.vertex.y > p.y
    NW -> v.vertex.x > p.x && v.vertex.y < p.y
  }
}

fn find_vertices(points: List(Point)) -> Result(List(Vertex), Nil) {
  let assert [first, second, ..rest] = points
  use #(vertices, last) <- result.try(iter_find_vertices(first, second, first, rest, [], points))
  use vertex <- result.try(new_vertex(last, first, second, points))

  Ok([vertex, ..vertices])
}

fn find_lines(points) -> Result(List(Line), Nil) {
  let assert [first, ..rest] = points
  Ok(find_outlines(first, rest, first, []))
}

fn find_outlines(point, points, first, lines) -> List(Line) {
  case points {
    [] -> list.append(lines, [Line(point, first)])
    [next, ..rest] -> find_outlines(next, rest, first, list.append(lines, [Line(point, next)]))
  }
}

fn iter_find_vertices(a, b, first, points, vertices, all_points: List(Point)) -> Result(#(List(Vertex), Point), Nil) {
  // use vertex <- result.try(new_vertex(a, b, c, all_points))
  case points {
    [] -> {
      use vertex <- result.try(new_vertex(a, b, first, all_points))
      Ok(#(list.append(vertices, [vertex]), b))
    }
    [next, ..rest] -> {
      use vertex <- result.try(new_vertex(a, b, next, all_points))
      iter_find_vertices(b, next, first, rest, list.append(vertices, [vertex]), all_points)
    }
  }
}

fn find_vertex_type(vertex: Point, dir: Direction, polygon: List(Point)) -> VertexType {
  let #(cx, cy) = case dir {
    NE -> #(1, 1)
    SE -> #(1, -1)
    SW -> #(-1, -1)
    NW -> #(-1, 1)
  }

  let x = vertex.x - cx
  let y = vertex.y - cy

  let assert [first, ..rest] = polygon
  case is_point_inside(Point(x, y), first, rest, first, False) {
    True -> Concave
    False -> Convex
  }
}

fn is_point_inside(pt: Point, prev: Point, poly: List(Point), first: Point, inside: Bool) -> Bool {
  case poly {
    [] -> case compare_point_within(pt, prev, first) { True -> !inside False -> inside }
    [next, ..rest] -> {
      case compare_point_within(pt, prev, next) {
        False -> is_point_inside(pt, next, rest, first, inside)
        True -> is_point_inside(pt, next, rest, first, !inside)
      }
    }
  }
}

fn compare_point_within(pt: Point, prev: Point, next: Point) {
  {prev.y > pt.y != next.y > pt.y} && {pt.x < {{prev.x - next.x} * {pt.y - next.y} / { next.y - prev.y} + next.x}}
}

fn new_vertex(p1: Point, p2: Point, p3: Point, all_points: List(Point)) -> Result(Vertex, Nil) {
  let direction = find_direction(p1, p2, p3)
  case p1.x == p2.x {
    True -> case p2.y == p3.y {
      True -> Ok(Vertex(
        a: p1, vertex: p2, b: p3, direction: direction, kind: find_vertex_type(p2, direction, all_points)
      ))
      False -> Error(Nil)
    }
    False -> case p1.y == p2.y {
      True -> case p2.x == p3.x {
        True -> Ok(Vertex(
          a: p1, vertex: p2, b: p3, direction: direction, kind: find_vertex_type(p2, direction, all_points)
        ))
        False -> Error(Nil)
      }
      False -> Error(Nil)
    }
  }
}

fn find_direction(a: Point, v: Point, b: Point) -> Direction {
  case a.y > b.y, a.x > b.x, v.x == a.x {
    True, True, True -> NW
    True, True, False -> SE
    True, False, True -> NE
    True, False, False -> SW
    False, True, True -> SW
    False, True, False -> NE
    False, False, True -> SE
    False, False, False -> NW
  }
}

fn new_point(raw: String) -> Result(Point, Nil) {
  use #(rx, ry) <- result.try(string.split_once(raw, ","))
  use x <- result.try(int.parse(rx))
  use y <- result.try(int.parse(ry))
  Ok(Point(x: x, y: y))
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
  {int.absolute_value(p1.x - p2.x) + 1} * {int.absolute_value(p1.y - p2.y) + 1}
}
