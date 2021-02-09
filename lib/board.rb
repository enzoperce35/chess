require_relative 'chess_parts.rb'
require_relative 'helper.rb'
require_relative 'side_message.rb'
require 'colorize'

class Board
  attr_accessor :squares, :turn_player, :opposing_player, :row_index, :col_index

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

  def create_a_square
    empty_square = "    "

    colorize_square(empty_square, row_index, col_index)
  end

  def create_coordinates(i)
    quotient, remainder = i.divmod(8)

    @row_index = customize_row_index(remainder)

    @col_index = 8 - quotient
  end

  #creates chess_board attributes in hash form
  def create_squares(hash = {})
    64.times do |i|
      create_coordinates(i)

      square = create_a_square

      square_position = convert_to_board_position([row_index, col_index])

      hash.store(square_position, { 'square'=>square, 'col_ind'=>col_index, 'row_ind'=>row_index })
    end
    hash
  end

  def colorize_square(square, x_coor, y_coor)
    if x_coor.odd?
       y_coor.odd? ? square.colorize(background: :light_black) : square.colorize(background: :light_cyan)
    else
       y_coor.odd? ? square.colorize(background: :light_cyan) : square.colorize(background: :light_black)
    end
  end

  #updates the chess board by placing each players' active pieces
  def populate_board
    2.times do |i|
      if i.zero?
        place(opposing_player['active_pieces'])
      else
        place(turn_player['active_pieces'])
      end
    end
  end

  def place(player_piece)
    player_piece.values.each do |player_piece|
      piece, image, position = player_piece.values

      image = " " + image + "  "

      square = @squares[position]

      square['square'] = colorize_square(image, square['col_ind'], square['row_ind'])
    end
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
end