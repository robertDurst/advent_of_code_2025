import gleam/int
import gleam/list
import gleam/string

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

fn mod_val() -> Int {
  100
}

fn start_context() -> Context {
  Context(location: 50, direct_zero_landings: 0, times_passing_zero: 0)
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

/// In real life we might divide by zero, but here we aren't.
fn non_assertive_modulo_100(dividend: Int) -> Int {
  let remainder = dividend % mod_val()
  case remainder * mod_val() < 0 {
    True -> remainder + mod_val()
    False -> remainder
  }
}

fn count_if_on_zero(location: Int, previous_direct_zero_landings: Int) -> Int {
  case location {
    0 -> previous_direct_zero_landings + 1
    _ -> previous_direct_zero_landings
  }
}

/// To get the times we pass zero, if we're adding, it's just the integer division
/// by 100, i.e. 50 + 200 = 2. However, if we're subtracting, we pass zero the other
/// way and thus in order to take a similar approach, if we're not already on zero,
/// in which case we'd negate to 100, we subtract 100 to get the "flip" and then
/// employ the same strategy. Unsure what the exact mathematical terminology is
/// here, so excuse the hand wavy explanation.
fn mod_location_based_on_context(location: Int, negate_zeroth: Bool) -> Int {
  case location, negate_zeroth {
    _, True | 0, False -> location
    _, False -> mod_val() - location
  }
}

fn execute_instruction(
  instruction_action: InstructionAction,
  context: Context,
) -> Context {
  let new_location =
    instruction_action.rotation_fn(
      context.location,
      instruction_action.rotation_count,
    )
    |> non_assertive_modulo_100

  let times_passed_zero_this_execution =
    int.add(
      mod_location_based_on_context(
        context.location,
        instruction_action.negate_zeroth,
      ),
      instruction_action.rotation_count,
    )
    / mod_val()

  Context(
    location: new_location,
    direct_zero_landings: count_if_on_zero(
      new_location,
      context.direct_zero_landings,
    ),
    times_passing_zero: context.times_passing_zero
      + times_passed_zero_this_execution,
  )
}

fn part_agnostic_instruction_handler(instructions: String) -> Context {
  instructions
  |> string.split("\n")
  |> list.filter_map(interpret_instruction)
  |> list.fold(start_context(), fn(context, instruction_action) -> Context {
    execute_instruction(instruction_action, context)
  })
}

pub fn part_a(instructions: String) -> Int {
  { instructions |> part_agnostic_instruction_handler }.direct_zero_landings
}

pub fn part_b(instructions: String) -> Int {
  { instructions |> part_agnostic_instruction_handler }.times_passing_zero
}
