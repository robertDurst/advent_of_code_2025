import advent
import day_1
import helpers

pub fn main() -> Nil {
  advent.year(2025)
  |> advent.add_day(
    advent.Day(
      day: 1,
      parse: fn(input) { input },
      part_a: day_1.part_a,
      part_b: day_1.part_b,
      expected_a: helpers.expected_int("AOC_DAY1_A"),
      expected_b: helpers.expected_int("AOC_DAY1_B"),
      wrong_answers_a: [],
      wrong_answers_b: [],
    ),
  )
  |> advent.add_padding_days(up_to: 12)
  |> advent.run
}
