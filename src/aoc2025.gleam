import gleam/io
import argv
import file_reader

pub fn main() -> Nil {
  io.println("Hello from aoc2025!")
  case argv.load().arguments {
    ["day1", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      echo content
      Nil
    }
    _ -> io.println("Usage: gleam run day<n> <filename>")
  }

}
