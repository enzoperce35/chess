require_relative 'helper.rb'
require_relative 'side_message.rb'

# creates and displays the chess board
class Board
  attr_accessor :squares_hash, :turn_player, :opposing_player, :row_index,
                :col_index, :piece_image, :side_message, :squares_string

  include Helper

  def initialize(turn_player, opposing_player)
    @turn_player = turn_player
    @opposing_player = opposing_player
  end

  # adds new line strings to the top and bottom of @squares_string
  def add_spacings_to_squares_string
    @squares_string = add_top_spacing(squares_string, 2)

    @squares_string = add_bottom_spacing(squares_string, 2)
  end

  # attaches a string representing the x_coordinates to @squares string
  def attach_x_coordinates_to_square_string
    x_coords = ('   a'..'   h').to_a.join

    x_coordinates = put_colour_to(x_coords, 'red')

    @squares_string += x_coordinates
  end

  # inserts each side message lines into @squares_string
  def attach_the_side_messages_to_squares_string
    side_message.each do |line|
      index = squares_string.index(" \n")

      @squares_string = squares_string.insert(index + 1, line)
    end
  end

  # returns a colored integer with a space to it's right side
  def add_y_coordinate(col_index)
    y_coord = put_colour_to(col_index.to_s, 'red')

    y_coord + ' '
  end

  # convert @squares_hash into @squares_string
  def convert_squares_hash_into_squares_string(str = '')
    squares_hash.values.each do |square|
      sqr_image, col_index, row_index = square.values

      str += add_y_coordinate(col_index) if row_index == 1

      str += sqr_image

      str += add_new_line if row_index == 8
    end
    @squares_string = str
  end

  # alters and joins @squares and @side_message values to build a value for @squares_string
  def draw_the_chess_board_with_side_message
    convert_squares_hash_into_squares_string

    attach_the_side_messages_to_squares_string

    attach_x_coordinates_to_square_string

    add_spacings_to_squares_string
  end

  # creates the message to be attached beside the chess board
  def create_the_side_message
    @side_message = SideMessage.new(turn_player).create_side_message
  end

  # creates a string equal to a message guided chess board
  def create_board_with_side_message
    create_the_side_message

    draw_the_chess_board_with_side_message
  end

  # returns true if index are both even or both odd
  def both_indexes_are_on_the_same_parity?
    row_index.even? && col_index.even? || row_index.odd? && col_index.odd?
  end

  # gives the color to board squares
  def colorize_square(square)
    if both_indexes_are_on_the_same_parity?
      put_background_color(square, 'blue')
    else
      put_background_color(square, 'light_black')
    end
  end

  # gives a new value for row and col index board attributes
  def utilize_empty_square_attributes(empty_square)
    @col_index = empty_square['col_ind']

    @row_index = empty_square['row_ind']
  end

  # replace @square['square'] with a colorized and chess piece inserted square
  def replace_empty_square_with_filled_square(empty_square, filled_square)
    utilize_empty_square_attributes(empty_square)

    empty_square['square'] = colorize_square(filled_square)
  end

  # insert the chess piece's image into an empty square
  def put_image_in_an_empty_square(image)
    empty_square = '   '

    empty_square.insert(1, image)
  end

  # locate board square with the guide of the chess piece's position
  def locate_board_square(position)
    @squares_hash[position]
  end

  # find and replace empty squares with chess piece filled squares
  def put_player_pieces(player_pieces)
    player_pieces.values.each do |player_piece|
      _piece, image, position = player_piece.values

      empty_square = locate_board_square(position)

      filled_square = put_image_in_an_empty_square(image)

      replace_empty_square_with_filled_square(empty_square, filled_square)
    end
  end

  # puts both players' chess pieces into an empty chess @squares
  def populate_board
    2.times do |i|
      player_pieces = i.zero? ? opposing_player['active_pieces'] : turn_player['active_pieces']

      put_player_pieces(player_pieces)
    end
  end

  # returns a colorized empty square
  def create_an_empty_square
    empty_square = '    '

    colorize_square(empty_square)
  end

  # gives new value for row and col index board attributes
  def create_board_coordinates(iteration)
    quotient, remainder = iteration.divmod(8)

    @row_index = customize_row_index(remainder)

    @col_index = 8 - quotient
  end

  # returns a nested hash of board square attribute key-value pairs
  def create_squares(hash = {})
    64.times do |i|
      create_board_coordinates(i)

      board_square = create_an_empty_square

      piece_position = convert_to_piece_position([row_index, col_index])

      hash.store(piece_position, { 'square' => board_square, 'col_ind' => col_index, 'row_ind' => row_index })
    end
    hash
  end
end
