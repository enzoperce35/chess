require 'colorize'

module ChessParts
  HORIZONTALS = "\u2550" * 32
  VERTICAL = "\u2551"
  UPPER_LEFT = "  \u2554"
  UPPER_RIGHT = "\u2557"
  LOWER_LEFT = "  \u255A"
  LOWER_RIGHT = "\u255D"
  BLACK = "    "
  CYAN = "    ".colorize(background: :cyan)
  COLUMN_LETTERS = '    a   b   c   d    e   f   g   h'
end