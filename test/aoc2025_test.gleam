import gleeunit
import day1

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn day1_stage_one_test() {
  let start = 50
  let input = "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

  assert day1.stage_one(start, input) == 3
}
