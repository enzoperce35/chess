require_relative 'chess_parts.rb'
require 'colorize'

class Board
  attr_reader :squares

  include ChessParts

  def initialize
    @squares = create_squares
  end

  def create_squares(hash = {}, sqr_ind = 0)
    return hash if sqr_ind == 64

    index1,index2 = sqr_ind.divmod(8)

    insert_to_hash(hash, sqr_ind, index1, index2)

    create_squares(hash, sqr_ind += 1)
  end

  def insert_to_hash(hash, square, ind1, ind2, alphabet = ('a'..'h').to_a)
    alpha = alphabet[ind2]
    numeric = (ind1-8).abs

    square = create_square(numeric, ind2)

    hash.store("#{alpha}#{numeric}", square)
  end

  def create_square(numeric, index2)
     if numeric.odd?
        index2.odd? ? "    ".colorize(background: :light_black) : "    ".colorize(background: :light_cyan)
     else
        index2.odd? ? "    ".colorize(background: :light_cyan) : "    ".colorize(background: :light_black)
     end
  end

  def draw_board(str = '')
    squares.values.each_with_index do |sqr,ind|
      quotient, modulus = (ind + 1).divmod 8

      str = add_y_coordinate(str, quotient) if start_of_a_row(ind)

      str += sqr

      str += "\n" if end_of_a_row(modulus)
    end
    puts str + X_COORDINATES.colorize(color: :red)
  end

  def add_y_coordinate(string, numeric)
    string += "#{8 - numeric} ".colorize(color: :red)
  end

  def start_of_a_row(index)
    index % 8 == 0
  end

  def end_of_a_row(mod)
    mod.zero?
  end
end

#x = Board.new('iron', 'men')
#x.draw_board
#x.draw_board

# "\e[0;39;106m    \e[0m"
# "\e[0;39;106m ♚ \e[0m"
