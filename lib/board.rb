require_relative 'chess_parts.rb'
require 'colorize'

class Board
  attr_accessor :squares

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

  def insert_to_hash(hash, square, ind1, row_index, alphabet = ('a'..'h').to_a)
    x_coor = alphabet[row_index]
    y_coor = (ind1-8).abs

    square = square("    ", y_coor, row_index+1)

    hash.store("#{x_coor}#{y_coor}", { 'square'=>square, 'col_ind'=>y_coor, 'row_ind'=>row_index+1 })
  end

  def square(square, y_coor, x_coor)
     if y_coor.odd?
        x_coor.odd? ? square.colorize(background: :light_black) : square.colorize(background: :light_cyan)
     else
        x_coor.odd? ? square.colorize(background: :light_cyan) : square.colorize(background: :light_black)
     end
  end

  def draw_board(squares, str = '')
    squares.each_with_index do |square,ind|

      quotient, modulus = (ind + 1).divmod 8

      str = add_y_coordinate(str, quotient) if start_of_a_row(ind)

      str += square['square']

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