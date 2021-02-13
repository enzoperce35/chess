require_relative 'chess_parts.rb'
require_relative 'helper.rb'
require_relative 'side_message.rb'
require 'colorize'

class Board
  attr_accessor :squares, :turn_player, :opposing_player, :row_index, :col_index,
                :piece_image

  include ChessParts
  include SideMessage
  include Helper

  def initialize(turn_player, opposing_player)
    @turn_player = turn_player
    @opposing_player = opposing_player
  end

  def create_board_with_side_message(board)
    side_message = create_side_message(turn_player)

    draw_board_with_message(board, side_message)
  end

  #alter each player's 'active pieces'
  def switch_player_pieces
    2.times { |i| i.zero? ? alter(turn_player['active_pieces']) : alter(opposing_player['active_pieces']) }
  end



  def alter_opposing_pieces(pieces)
    pieces.values.map do |value|
      value['position'][-1] = (value['position'][-1].to_i - 9).abs.to_s
    end

    pieces.values
  end

  #displays the board with a message by converting hash into a string
  def draw_board_with_message(board, message)
    squares_hash = board.squares
    board_string = convert_to_string(squares_hash)

    message.each do |line|
      index = board_string.index(" \n")
      board_string = board_string.insert(index+1, line)
    end

    board_string
  end

  def y_coordinate(col_index)
    "#{col_index} ".colorize(color: :red)
  end

  def new_space
    " \n"
  end

  # returns true if index are both even or both odd
  def both_indexes_are_on_the_same_parity?
    row_index.even? && col_index.even? || row_index.odd? && col_index.odd?
  end

  # gives the color to board squares
  def colorize_square(square)
    if both_indexes_are_on_the_same_parity?
      square.colorize(background: :blue)
    else
      square.colorize(background: :light_black)
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
    empty_square = "   "

    empty_square.insert(1, image)
  end

  # locate board square with the guide of the chess piece's position
  def locate_board_square(position)
    @squares[position]
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
    empty_square = "    "

    colorize_square(empty_square)
  end

  # gives new value for row and col index board attributes
  def create_board_coordinates(i)
    quotient, remainder = i.divmod(8)

    @row_index = customize_row_index(remainder)

    @col_index = 8 - quotient
  end

  # returns a nested hash of board square attribute key-value pairs
  def create_squares(hash = {})
    64.times do |i|
      create_board_coordinates(i)

      board_square = create_an_empty_square

      square_position = convert_to_board_position([row_index, col_index])

      hash.store(square_position, { 'square'=>board_square, 'col_ind'=>col_index, 'row_ind'=>row_index })
    end
    hash
  end
end