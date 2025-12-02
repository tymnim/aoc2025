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

  assert day1.stage_one(start, input) == Ok(3)
}
pub fn day1_stage_two_test() {
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

  assert day1.stage_two(start, input) == Ok(6)
}

pub fn day1_stage_two2_test() {
  let start = 50
  let input = "R49\nR2\nR100\nL1"

  assert day1.stage_two(start, input) == Ok(3)
}
pub fn day1_stage_two3_test() {
  let start = 50
  let input = "L149\nL2\nL100\nR101"

  assert day1.stage_two(start, input) == Ok(5)
}
