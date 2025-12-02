import day_1
import day_2
import gleam/io
import gleamy/bench
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
  |> day_1.part_a
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
  |> day_1.part_b
  |> should.equal(6)
}

pub fn day_2_part_a_actual_test() {
  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124"

  input
  |> day_2.part_a
  |> should.equal(1_227_775_554)
}

pub fn day_2_part_a_otp_actual_test() {
  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
1698522-1698528,446443-446449,38593856-38593862,565653-565659,
824824821-824824827,2121212118-2121212124"

  input
  |> day_2.part_a_otp
  |> should.equal(1_227_775_554)
}

pub fn day_2_multi_string_test() {
  day_2.multi_string("foo", 5, "")
  |> should.equal("foofoofoofoofoo")

  day_2.multi_string("foo", 1, "")
  |> should.equal("foo")
}

pub fn day_2_part_b_actual_test() {
  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
  1698522-1698528,446443-446449,38593856-38593862,565653-565659,
  824824821-824824827,2121212118-2121212124"

  input
  |> day_2.part_b
  |> should.equal(4_174_379_265)
}

pub fn day_2_otp_part_b_actual_test() {
  let input =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,
  1698522-1698528,446443-446449,38593856-38593862,565653-565659,
  824824821-824824827,2121212118-2121212124"

  input
  |> day_2.part_b_otp
  |> should.equal(4_174_379_265)
}

pub fn day_2_part_b_bench_test() {
  let input =
    "5959566378-5959623425,946263-1041590,7777713106-7777870316,35289387-35394603,400-605,9398763-9592164,74280544-74442206,85684682-85865536,90493-179243,202820-342465,872920-935940,76905692-76973065,822774704-822842541,642605-677786,3759067960-3759239836,1284-3164,755464-833196,52-128,3-14,30481-55388,844722790-844967944,83826709-83860070,9595933151-9595993435,4216-9667,529939-579900,1077949-1151438,394508-486310,794-1154,10159-17642,5471119-5683923,16-36,17797-29079,187-382"

  bench.run(
    [bench.Input("day 2 input", input)],
    [
      bench.Function("part_a", day_2.part_a),
      bench.Function("part_a_otp", day_2.part_a_otp),
      bench.Function("part_b", day_2.part_b),
      bench.Function("part_b_otp", day_2.part_b_otp),
    ],
    [bench.Duration(5000)],
  )
  |> bench.table([bench.IPS, bench.Min, bench.Mean, bench.Max])
  |> io.println
}
