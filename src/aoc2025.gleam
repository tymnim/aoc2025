import gleam/io
import gleam/string
import gleam/int
import argv
import file_reader
import day1

pub fn main() -> Nil {
  io.println("Hello from aoc2025!")
  case argv.load().arguments {
    ["day1", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(counter) = day1.stage_one(50, string.trim(content))
      io.println("Stage One: " <> int.to_string(counter))
      Nil
    }
    _ -> io.println("Usage: gleam run day<n> <filename>")
  }

}
