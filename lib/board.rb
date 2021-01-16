require_relative 'chess_parts.rb'
require 'colorize'

class Board
  attr_accessor :squares, :turn_player, :opposing_player

  include ChessParts

  def initialize(turn_player, opposing_player)
    @squares = create_squares
    @turn_player = turn_player
    @opposing_player = opposing_player
  end

  #creates chess_board attributes in hash form
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

  #updates the chess board by placing each players' active pieces
  def update_board
    2.times do |i|
      if i.zero?
        place(opposing_player.active_pieces)
      else
        place(turn_player.active_pieces)
      end
    end
  end

  def place(player_pieces)
    player_pieces.values.each do |piece|
      image, position = piece.values

      square = @squares[position]

      square['square'] = colorize_square(image, square['col_ind'], square['row_ind'])
    end
  end

  #displays the board with a message by converting hash into a string
  def draw_board_with_message(squares_hash, message)
    board_string = convert_to_string(squares_hash)

    message.each do |line|
      index = board_string.index(" \n")
      board_string = board_string.insert(index+1, line)
    end

    puts board_string
  end

  def convert_to_string(squares, str = '')
    squares.values.each do |square|
      sqr_image = square['square']
      row_index = square['row_ind']
      col_index = square['col_ind']

      str += y_coordinate(col_index) if row_index == 1

      str += sqr_image

      str += new_space if row_index == 8
    end
    ("\n"*2) + str + X_COORDINATES.colorize(color: :red) + ("\n"*2)
  end

  def y_coordinate(col_index)
    "#{col_index} ".colorize(color: :red)
  end

  def new_space
    " \n"
  end
end