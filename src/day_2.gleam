import gleam/erlang/process.{type Subject}
import gleam/int
import gleam/list
import gleam/string

// ==== Misc. Helpers ====
fn force_string_to_int(num_string: String) -> Int {
  let assert Ok(num) = int.parse(num_string |> string.trim)

  num
}

fn invalid_inputs_part_a(val: #(Int, Int)) {
  let #(start, end) = val
  do_invalid_inputs(start, end, list.new(), fn(input: Int) -> Bool {
    let input_string = int.to_string(input)
    let left = string.slice(input_string, 0, string.length(input_string) / 2)

    { string.concat([left, left]) } == input_string
  })
}

fn invalid_inputs_part_b(val: #(Int, Int)) {
  let #(start, end) = val
  do_invalid_inputs(start, end, list.new(), singular_invalid_input_part_b)
}

fn do_invalid_inputs(
  start: Int,
  end: Int,
  invalids: List(Int),
  invalids_check: fn(Int) -> Bool,
) -> List(Int) {
  case start > end {
    True -> invalids
    _ -> {
      case invalids_check(start) {
        True ->
          do_invalid_inputs(
            start + 1,
            end,
            list.append(invalids, [start]),
            invalids_check,
          )
        False -> do_invalid_inputs(start + 1, end, invalids, invalids_check)
      }
    }
  }
}

fn singular_invalid_input_part_b(input: Int) -> Bool {
  let input_string = int.to_string(input)
  do_singular_invalid_input_part_b(input_string, 1, string.length(input_string))
}

fn do_singular_invalid_input_part_b(input: String, cur: Int, len: Int) -> Bool {
  case { cur * 2 } > len {
    True -> False
    _ -> {
      let assert Ok(remainder) = int.remainder(len, cur)
      case remainder > 0 {
        True -> do_singular_invalid_input_part_b(input, cur + 1, len)
        _ -> {
          let left = string.slice(input, 0, cur)
          case multi_string(left, len / cur, "") == input {
            True -> True
            _ -> do_singular_invalid_input_part_b(input, cur + 1, len)
          }
        }
      }
    }
  }
}

pub fn multi_string(str: String, iter: Int, res: String) -> String {
  case iter {
    0 -> res
    _ -> multi_string(str, iter - 1, string.append(str, res))
  }
}

// ==== Common ====
pub fn part_agnostic_preface(raw_input: String) -> List(#(Int, Int)) {
  raw_input
  |> string.split(",")
  |> list.filter_map(fn(input) {
    case string.split(input, "-") {
      [first, second] ->
        Ok(#(force_string_to_int(first), force_string_to_int(second)))
      _ -> Error(Nil)
    }
  })
}

pub fn part_agnostic_sequential(
  raw_input: String,
  invalidator_fn: fn(#(Int, Int)) -> List(Int),
) -> Int {
  raw_input
  |> part_agnostic_preface
  |> list.map(invalidator_fn)
  |> list.flatten
  |> list.fold(0, fn(a, b) { int.add(a, b) })
}

pub fn part_agnostic_otp(
  raw_input: String,
  invalidator_fn: fn(#(Int, Int)) -> List(Int),
) -> Int {
  raw_input
  |> part_agnostic_preface
  |> list.map(fn(range) {
    let reply_subject: Subject(List(Int)) = process.new_subject()

    process.spawn(fn() {
      let result = invalidator_fn(range)
      process.send(reply_subject, result)
    })

    reply_subject
  })
  |> list.map(process.receive_forever)
  |> list.flatten
  |> list.fold(0, int.add)
}

// ==== Part A ====
pub fn part_a(raw_input: String) -> Int {
  raw_input |> part_agnostic_sequential(invalid_inputs_part_a)
}

pub fn part_a_otp(raw_input: String) -> Int {
  raw_input |> part_agnostic_otp(invalid_inputs_part_a)
}

// ==== Part B ====
pub fn part_b(raw_input: String) -> Int {
  raw_input |> part_agnostic_sequential(invalid_inputs_part_b)
}

pub fn part_b_otp(raw_input: String) -> Int {
  raw_input |> part_agnostic_otp(invalid_inputs_part_b)
}
