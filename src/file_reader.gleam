import file_streams/file_stream.{type FileStream}
import file_streams/file_stream_error.{type FileStreamError}
import gleam/result

pub fn read_file(filename: String) -> Result(String, FileStreamError) {
  use stream <- result.try(file_stream.open_read(filename))
  use content <- result.try(read_stream(stream, ""))

  Ok(content)
}

fn read_stream(stream: FileStream, current) -> Result(String, FileStreamError) {
  case file_stream.read_line(stream) {
    Ok(str) -> read_stream(stream, current <> str)
    Error(file_stream_error.Eof) -> Ok(current)
    e -> e
  }
}

