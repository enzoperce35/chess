require 'colorize'

module ChessParts
  HORIZONTALS = "\u2550" * 32
  VERTICAL = "\u2551"
  UPPER_LEFT = "  \u2554"
  UPPER_RIGHT = "\u2557"
  LOWER_LEFT = "  \u255A"
  LOWER_RIGHT = "\u255D"
  SQUARE = "    "

  WHITE_KING = " \u2654  "
  WHITE_QUEEN = " \u2655  "
  WHITE_ROOK = " \u2656  "
  WHITE_BISHOP = " \u2657  "
  WHITE_KNIGHT = " \u2658  "
  WHITE_PAWN = " \u2659  "

  BLACK_KING = " \u265A "
  BLACK_QUEEN = " \u265B  "
  BLACK_ROOK = " \u265C  "
  BLACK_BISHOP = " \u265D  "
  BLACK_KNIGHT = " \u265E  "
  BLACK_PAWN = " \u265F  "

  BLACK_OFFICIALS = [" \u2656  ", " \u2658  ", " \u2657  ", " \u2655  ", " \u2654  ", " \u2657  ", " \u2658  ", " \u2656  "]
  WHITE_OFFICIALS = [" \u265C  ", " \u265E  ", " \u265D  ", " \u265B  ", " \u265A  ", " \u265D  ", " \u265E  ", " \u265C  "]
  BLACK_PAWNS = Array.new(8) { " \u2659  " }
  WHITE_PAWNS = Array.new(8) { " \u265F  " }

  ALPHA = ('A'..'H').to_a

  BLACK_PIECES = BLACK_OFFICIALS + BLACK_PAWNS
  WHITE_PIECES = WHITE_PAWNS + WHITE_OFFICIALS


  UPPER_BORDER = UPPER_LEFT + HORIZONTALS + UPPER_RIGHT
  #SQUARE_ROW = VERTICAL + ((BLACK + CYAN) * 4) + VERTICAL
  LOWER_BORDER = LOWER_LEFT + HORIZONTALS + UPPER_RIGHT
  COLUMN_LETTERS = '    a   b   c   d    e   f   g   h'
end