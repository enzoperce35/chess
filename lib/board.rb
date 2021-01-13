require_relative 'chess_parts.rb'
require 'colorize'

class Board
  attr_accessor :squares

  include ChessParts

  def initialize
    @squares = create_squares
  end

  #create the default chess_board attributes in a hash
  def create_squares(hash = {}, square = 0)
    return hash if square == 64

    index1,index2 = square.divmod(8)

    insert_to_hash(hash, square, index1, index2, ('a'..'h').to_a)

    create_squares(hash, square += 1)
  end

  def insert_to_hash(hash, square, index1, index2, alphabet)
    row_index = index2 + 1 

    x_coor = alphabet[index2]
    y_coor = (index1-8).abs

    square = colorize_square("    ", y_coor, row_index)

    hash.store("#{x_coor}#{y_coor}", { 'square'=>square, 'col_ind'=>y_coor, 'row_ind'=>row_index })
  end

  def colorize_square(square, y_coor, x_coor)
    if y_coor.odd?
       x_coor.odd? ? square.colorize(background: :light_black) : square.colorize(background: :light_cyan)
    else
       x_coor.odd? ? square.colorize(background: :light_cyan) : square.colorize(background: :light_black)
    end
  end

  #draw the board with x and y coordinates
  def draw_board(squares, str = '')
    squares.each do |square|
      sqr_image = square['square']
      row_index = square['row_ind']
      col_index = square['col_ind']

      str += y_coordinate(col_index) if row_index == 1

      str += sqr_image

      str += new_space if row_index == 8
    end
    puts str + X_COORDINATES.colorize(color: :red)
  end

  def y_coordinate(col_index)
    "#{col_index} ".colorize(color: :red)
  end

  def new_space
    "\n"
  end
end