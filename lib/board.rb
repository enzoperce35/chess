require_relative 'chess_parts.rb'
require_relative 'helper.rb'
require_relative 'side_message.rb'
require 'colorize'

class Board
  attr_accessor :squares, :turn_player, :opposing_player

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

  #creates chess_board attributes in hash form
  def create_squares(hash = {}, square = 0, col_index = 9)
    return hash if square == 64

    row_index = square % 8
    col_index -= 1 if row_index.zero?

    convert_to_board_position([row_index, col_index])

    insert_to_hash(hash, row_index, col_index)


    create_squares(hash, square += 1, col_index)
  end

  def insert_to_hash(hash, row_index, col_index)

    square = colorize_square("    ", col_index, row_index+1)

    square_position = convert_to_board_position([row_index, col_index])

    hash.store(square_position, { 'square'=>square, 'col_ind'=>col_index, 'row_ind'=>row_index+1 })
  end

  def colorize_square(square, y_coor, x_coor)
    if y_coor.odd?
       x_coor.odd? ? square.colorize(background: :light_black) : square.colorize(background: :light_cyan)
    else
       x_coor.odd? ? square.colorize(background: :light_cyan) : square.colorize(background: :light_black)
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