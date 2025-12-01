import gleam/int
import gleam/option.{type Option}
import gleam/result

@external(erlang, "aoc_ffi", "get_env")
fn get_env(name: String) -> Result(String, Nil)

pub fn expected_int(env_name: String) -> Option(Int) {
  get_env(env_name)
  |> result.try(int.parse)
  |> option.from_result
}
