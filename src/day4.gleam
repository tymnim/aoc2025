import gleam/string
import gleam/list
import gleam/result
import gleam/int
import glearray.{type Array}

const coord_matrix = [#(-1, -1), #(0, -1), #(1, -1),
                      #(-1, 0), #(1, 0),
                      #(-1, 1), #(0, 1), #(1, 1)]

pub fn stage_one(text: String) -> Result(Int, Nil) {
  let res = text
  |> parse_into_array_list
  |> iterate_rows(0, 0, 0)

  Ok(res)
}

fn parse_into_array_list(text: String) -> Array(Array(String)) {
  string.split(text, on: "\n")
  |> list.map(fn (line) {
    string.to_graphemes(line)
    |> glearray.from_list
  })
  |> glearray.from_list

}

fn iterate_rows(arr: Array(Array(String)), x: Int, y: Int, count: Int) -> Int {
  case glearray.get(arr, y) {
    Ok(inner) -> {
      case glearray.get(inner, x) {
        Ok(letter) -> case letter {
          "@" -> {
            let icount = check_around(x, y, arr) |> int.sum
            case icount {
              0|1|2|3 -> iterate_rows(arr, x + 1, y, count + 1)
              _ -> iterate_rows(arr, x + 1, y, count)
            }
          }
          _ -> iterate_rows(arr, x + 1, y, count)
        }
        _ -> iterate_rows(arr, 0, y + 1, count)
      }
    }
    _ -> count
  }
}

fn check_around(x, y, arr) -> List(Int) {
  list.map(coord_matrix, fn(coords) {
    let #(mx, my) = coords
    case glearray.get(arr, y + my) {
      Ok(inner) -> case glearray.get(inner, x + mx) {
        Ok(letter) -> case letter {
          "@" -> 1
          _ -> 0
        }
        _ -> 0
      }
      _ -> 0
    }
  })
}
