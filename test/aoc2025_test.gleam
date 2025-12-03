import gleeunit
import day1
import day2
import day3

pub fn main() -> Nil {
  gleeunit.main()
}

// DAY 1
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

// DAY 2
pub fn day2_stage_one_test() {
  let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  assert day2.stage_one(input) == Ok(1227775554)
}
pub fn day2_stage_two_test() {
  let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"

  assert day2.stage_two(input) == Ok(4174379265)
}
pub fn day2_stage_two2_test() {
  let input = "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124,1-20"

  assert day2.stage_two(input) == Ok(4174379265 + 11)
}

pub fn day3_stage_one_test() {
  let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111"

  assert day3.stage_one(input) == Ok(357)
}

pub fn day3_stage_two_test() {
  let input = "987654321111111\n811111111111119\n234234234234278\n818181911112111"

  assert day3.stage_two(input) == Ok(3121910778619)
}
