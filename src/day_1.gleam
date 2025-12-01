import gleam/int
import gleam/list
import gleam/string

fn mod_val() -> Int {
  100
}

fn start_context() -> Context {
  Context(location: 50, direct_zero_landings: 0, times_passing_zero: 0)
}

type Context {
  Context(location: Int, direct_zero_landings: Int, times_passing_zero: Int)
}

type InstructionAction {
  InstructionAction(
    rotation_count: Int,
    rotation_fn: fn(Int, Int) -> Int,
    negate_zeroth: Bool,
  )
}

fn interpret_instruction(instruction: String) -> Result(InstructionAction, Nil) {
  case instruction |> string.trim {
    "R" <> val -> {
      let assert Ok(steps) = int.parse(val)

      Ok(InstructionAction(
        rotation_count: steps,
        rotation_fn: int.add,
        negate_zeroth: True,
      ))
    }
    "L" <> val -> {
      let assert Ok(steps) = int.parse(val)

      Ok(InstructionAction(
        rotation_count: steps,
        rotation_fn: int.subtract,
        negate_zeroth: False,
      ))
    }
    _ -> Error(Nil)
  }
}

fn foobar(instruction_action: InstructionAction, context: Context) -> Context {
  let dividend =
    instruction_action.rotation_fn(
      context.location,
      instruction_action.rotation_count,
    )

  let remainder = dividend % mod_val()
  let final_remainder = case remainder * mod_val() < 0 {
    True -> remainder + mod_val()
    False -> remainder
  }

  let assert Ok(extra_to_add) = {
    case context.location, instruction_action.negate_zeroth {
      _, True ->
        int.add(context.location, instruction_action.rotation_count)
        |> int.divide(mod_val())
      0, False ->
        int.add(context.location, instruction_action.rotation_count)
        |> int.divide(mod_val())
      _, False ->
        int.add(mod_val() - context.location, instruction_action.rotation_count)
        |> int.divide(mod_val())
    }
  }

  let new_iterations = case final_remainder {
    0 -> context.direct_zero_landings + 1
    _ -> context.direct_zero_landings
  }

  Context(
    location: final_remainder,
    direct_zero_landings: new_iterations,
    times_passing_zero: context.times_passing_zero + extra_to_add,
  )
}

fn part_agnostic_instruction_handler(instructions: String) -> Context {
  instructions
  |> string.split("\n")
  |> list.filter_map(interpret_instruction)
  |> list.fold(start_context(), fn(context, instruction_action) -> Context {
    foobar(instruction_action, context)
  })
}

pub fn part_a(instructions: String) -> Int {
  { instructions |> part_agnostic_instruction_handler }.direct_zero_landings
}

pub fn part_b(instructions: String) -> Int {
  { instructions |> part_agnostic_instruction_handler }.times_passing_zero
}
