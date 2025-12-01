import advent
import gleam/int
import gleam/list
import gleam/option.{None}
import gleam/string

pub fn day_1_part_a(instructions: String) -> Int {
  let foobar = fn(
    val: String,
    aggregator: #(Int, Int),
    applicator: fn(Int, Int) -> Int,
  ) {
    let assert Ok(steps) = int.parse(val)
    let assert Ok(new_aggregator) =
      applicator(aggregator.0, steps) |> int.modulo(100)

    let new_iterations = case new_aggregator {
      0 -> aggregator.1 + 1
      _ -> aggregator.1
    }

    #(new_aggregator, new_iterations)
  }

  let start = 50

  let answer =
    instructions
    |> string.split("\n")
    |> list.filter_map(fn(instruction) -> Result(
      #(fn(Int, Int) -> Int, String),
      Nil,
    ) {
      case instruction |> string.trim {
        "R" <> val -> Ok(#(int.add, val))
        "L" <> val -> Ok(#(int.subtract, val))
        _ -> Error(Nil)
      }
    })
    |> list.fold(#(start, 0), fn(aggregator, instruction) -> #(Int, Int) {
      foobar(instruction.1, aggregator, instruction.0)
    })

  answer.1
}

pub fn day_1_part_b(instructions: String) -> Int {
  let foobar = fn(
    val: String,
    aggregator: #(Int, Int),
    applicator: fn(Int, Int) -> Int,
    extra: Bool,
  ) {
    let assert Ok(steps) = int.parse(val)
    let assert Ok(new_aggregator) =
      applicator(aggregator.0, steps) |> int.modulo(100)

    let assert Ok(extra_to_add) = {
      case aggregator.0, extra {
        _, True -> int.add(aggregator.0, steps) |> int.divide(100)
        0, False -> int.add(aggregator.0, steps) |> int.divide(100)
        _, False -> int.add(100 - aggregator.0, steps) |> int.divide(100)
      }
    }

    let new_iterations = case new_aggregator {
      0 -> aggregator.1 + extra_to_add
      _ -> aggregator.1 + extra_to_add
    }

    echo "Turning "
      <> val
      <> " to "
      <> int.to_string(new_aggregator)
      <> " passing zero "
      <> int.to_string(extra_to_add)

    #(new_aggregator, new_iterations)
  }

  let start = 50

  let answer =
    instructions
    |> string.split("\n")
    |> list.filter_map(fn(instruction) -> Result(
      #(fn(Int, Int) -> Int, String, Bool),
      Nil,
    ) {
      case instruction |> string.trim {
        "R" <> val -> Ok(#(int.add, val, True))
        "L" <> val -> Ok(#(int.subtract, val, False))
        _ -> Error(Nil)
      }
    })
    |> list.fold(#(start, 0), fn(aggregator, instruction) -> #(Int, Int) {
      foobar(instruction.1, aggregator, instruction.0, instruction.2)
    })

  answer.1
}

pub fn main() -> Nil {
  advent.year(2025)
  |> advent.add_day(
    advent.Day(
      day: 1,
      parse: fn(input) { input },
      part_a: day_1_part_a,
      part_b: day_1_part_b,
      expected_a: option.Some(1021),
      expected_b: option.Some(5933),
      wrong_answers_a: [],
      wrong_answers_b: [],
    ),
  )
  |> advent.add_padding_days(up_to: 12)
  |> advent.run
}
