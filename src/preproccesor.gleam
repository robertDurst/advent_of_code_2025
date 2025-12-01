import gleam/string

/// makes a temp file from which the code actually runs
pub fn un_jollify(raw_text) {
  string.replace(raw_text, "🎄", "|>")
}
