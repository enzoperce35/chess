#require 'colorize'

module ChessParts
  WHITE = {bishop: " \u265D  ", knight: " \u265E  ", rook:" \u265C  ", king: " \u265A ", queen:" \u265B  ",  pawn: " \u265F  "}
  BLACK = {bishop: " \u2657  ", knight: " \u2658  ", rook:" \u2656  ", king: " \u2654 ", queen:" \u2655  ",  pawn: " \u2659  "}

  ALPHA = ('A'..'H').to_a
end