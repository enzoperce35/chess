require_relative 'side_message.rb'
require_relative 'helper.rb'

class Display
  attr_accessor :chess_board, :side_message

  include Helper

  def initialize(chess_board, side_message)
    @chess_board = chess_board
    @side_message  = side_message
  end

  def add_spacings_to(chess_board)
    2.times do |i|
      chess_board = i.zero? ? add_top_spacing(chess_board, 2) : add_bottom_spacing(chess_board, 2)
    end

    chess_board
  end

  def attach_x_coordinates_to(chess_board)
    x_coords = ('   a'..'   h').to_a.join

    x_coordinates = put_colour_to(x_coords, 'red')

    chess_board += x_coordinates
  end

  def attach_side_message_to(chess_board)
    side_message.each do |line|
      index = chess_board.index(" \n")

      chess_board.insert(index + 1, line)
    end
    chess_board
  end

  # returns a colored integer with a space to it's right side
  def add(col_index)
    y_coord = put_colour_to(col_index.to_s, 'red')

    y_coord + ' '
  end

  def convert_chess_board_to_string(str = '')
    chess_board.values.each do |square|
      sqr_image, col_index, row_index = square.values

      str += add(col_index) if row_index == 1

      str += sqr_image

      str += add_new_line if row_index == 8
    end
    str
  end

  def display
    chess_board = convert_chess_board_to_string

    chess_board = attach_side_message_to(chess_board)

    chess_board = attach_x_coordinates_to(chess_board)

    chess_board = add_spacings_to(chess_board)

    puts chess_board
  end
end