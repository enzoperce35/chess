require_relative './modules/helper.rb'

class Display
  attr_accessor :chess_board, :side_message

  include Helper

  def initialize(chess_board, side_message)
    @chess_board = chess_board
    @side_message = side_message
  end

  def display
    puts chess_board
  end

  # adds space padding to the top and bottom of the chess board
  def add_spacings
    2.times do |i|
      @chess_board = i.zero? ? add_top_spacing(chess_board, 2) : add_bottom_spacing(chess_board, 2)
    end
  end

  # adds a-h alphabet letters below the chess board
  def attach_x_coordinates
    x_coords = ('   a'..'   h').to_a.join

    x_coordinates = put_colour_to(x_coords, 'red')

    @chess_board += x_coordinates
  end

  # attaches the chess board and the side message
  def attach_side_message
    side_message.each do |line|
      index = chess_board.index(" \n")

      @chess_board.insert(index + 1, line)
    end
  end

  # returns a colored integer with a space to it's right side
  def attach(col_index)
    y_coord = put_colour_to(col_index.to_s, 'red')

    y_coord + ' '
  end

  # converts the chess board from a hash to a string
  def convert_to_string(str = '')
    chess_board.values.each do |square|
      sqr_image, col_index, row_index = square.values

      str += attach(col_index) if row_index == 1

      str += sqr_image

      str += " \n" if row_index == 8
    end
    @chess_board = str
  end

  # processes the chess board with the following method
  def merge
    convert_to_string

    attach_side_message

    attach_x_coordinates

    add_spacings

    display
  end
end