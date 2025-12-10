import gleam/io
import gleam/string
import gleam/list
import gleam/time/timestamp
import gleam/int
import argv
import file_reader
import day1
import day2
import day3
import day4
import day5
import day7
import day9

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
      let assert Ok(res) = measure("Seocnd", fn () { day2.stage_two(string.trim(content)) })
      io.println("Stage Two: " <> int.to_string(res))
      Nil
    }
    ["day3", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(res) = measure("First", fn () { day3.stage_one(string.trim(content)) })
      io.println("Stage One: " <> int.to_string(res))
      let assert Ok(res) = measure("Second", fn () { day3.stage_two(string.trim(content)) })
      io.println("Stage Two: " <> int.to_string(res))
      Nil
    }
    ["day4", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(res) = day4.stage_one(string.trim(content))
      io.println("Stage One: " <> int.to_string(res))
      Nil
    }
    ["day5", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(res) = measure("First", fn () { day5.stage_one(string.trim(content)) })
      io.println("Stage One: " <> int.to_string(res))
      let assert Ok(res) = measure("Second", fn () { day5.stage_two(string.trim(content)) })
      io.println("Stage Two: " <> int.to_string(res))
      Nil
    }
    ["day6", _filename] -> {
      todo "DAY 6"
      Nil
    }
    ["day7", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(res) = measure("First", fn () { day7.stage_one(string.trim(content)) })
      io.println("Stage One: " <> int.to_string(res))
      Nil
    }
    ["day9", filename] -> {
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(res) = measure("First", fn () { day9.stage_one(string.trim(content)) })
      io.println("Stage One: " <> int.to_string(res))
      let assert Ok(content) = file_reader.read_file(filename)
      let assert Ok(res) = measure("Second", fn () { day9.stage_two(string.trim(content)) })
      io.println("Stage two: " <> int.to_string(res))
      Nil
    }
    _ -> io.println("Usage: gleam run day<n> <filename>")
  }
}

fn measure(label, callback) {
  let #(sseconds, snano) = timestamp.system_time() |> timestamp.to_unix_seconds_and_nanoseconds
  let res = callback()
  let #(eseconds, enano) = timestamp.system_time() |> timestamp.to_unix_seconds_and_nanoseconds
  let seconds = eseconds - sseconds
  let nano = enano - snano
  let ms = {seconds * 1_000_000_000 + nano} / 1000000
  io.println(label <> ": " <> int.to_string(ms) <> " ms")
  res
}
