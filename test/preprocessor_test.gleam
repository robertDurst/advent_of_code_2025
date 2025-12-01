import gleeunit/should
import preproccesor

pub fn un_jollify_test() {
  "
pub fn say_hello() {
  [\"hello\", \"world\"] 🎄 string.join 🎄 io.println
}
  "
  |> preproccesor.un_jollify
  |> should.equal(
    "
pub fn say_hello() {
  [\"hello\", \"world\"] |> string.join |> io.println
}
  ",
  )
}
