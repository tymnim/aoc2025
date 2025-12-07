import gleam/io
import gleam/string
import gleam/int
import argv
import file_reader
import day1
import day2
import day3
import day4

pub fn main() -> Nil {
  io.println("Hello from aoc2025!")
  case argv.load().arguments {
    ["day1", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(counter) = day1.stage_one(50, string.trim(content))
      io.println("Stage One: " <> int.to_string(counter))
      let assert Ok(counter) = day1.stage_two(50, string.trim(content))
      io.println("Stage Two: " <> int.to_string(counter))
      Nil
    }
    ["day2", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      // let assert Ok(res) = day2.stage_one(string.trim(content))
      // io.println("Stage One: " <> int.to_string(res))
      let assert Ok(res) = day2.stage_two(string.trim(content))
      io.println("Stage Two: " <> int.to_string(res))
      Nil
    }
    ["day3", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(res) = day3.stage_one(string.trim(content))
      io.println("Stage One: " <> int.to_string(res))
      let assert Ok(res) = day3.stage_two(string.trim(content))
      io.println("Stage Two: " <> int.to_string(res))
      Nil
    }
    ["day4", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(res) = day4.stage_one(string.trim(content))
      io.println("Stage One: " <> int.to_string(res))
      Nil
    }
    _ -> io.println("Usage: gleam run day<n> <filename>")
  }

}
