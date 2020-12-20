require_relative 'module.rb'

class Board
  attr_accessor :board
  include ChessParts

  def initialize
    @board = draw_board
  end

  def draw_board
    puts UPPER_LEFT + HORIZONTALS + UPPER_RIGHT,
         '8 ' + VERTICAL + ((CYAN + BLACK) * 4) + VERTICAL,
         '7 ' + VERTICAL + ((BLACK + CYAN) * 4) + VERTICAL,
         '6 ' + VERTICAL + ((CYAN + BLACK) * 4) + VERTICAL,
         '5 ' + VERTICAL + ((BLACK + CYAN) * 4) + VERTICAL,
         '4 ' + VERTICAL + ((CYAN + BLACK) * 4) + VERTICAL,
         '3 ' + VERTICAL + ((BLACK + CYAN) * 4) + VERTICAL,
         '2 ' + VERTICAL + ((CYAN + BLACK) * 4) + VERTICAL,
         '1 ' + VERTICAL + ((BLACK + CYAN) * 4) + VERTICAL,
         LOWER_LEFT + HORIZONTALS + LOWER_RIGHT,
         COLUMN_LETTERS
  end

end