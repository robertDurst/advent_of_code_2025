import advent_of_code_2025
import gleeunit
import gleeunit/should

pub fn main() -> Nil {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  let name = "Joe"
  let greeting = "Hello, " <> name <> "!"

  assert greeting == "Hello, Joe!"
}

pub fn day_1_part_a_test() {
  let instructions =
    "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

  instructions
  |> advent_of_code_2025.day_1_part_a
  |> should.equal(3)
}

pub fn day_1_part_b_test() {
  let instructions =
    "L68
L30
R48
L5
R60
L55
L1
L99
R14
L82"

  instructions
  |> advent_of_code_2025.day_1_part_b
  |> should.equal(6)
}
