require_relative 'helper.rb'

class PossibleMoves
  attr_accessor :array, :squares, :piece, :piece_name, :piece_position, :current_square, :new_square_position, :row_index, :column_index,
                :opposing_player_pieces, :next_square

  include Helper

  def initialize(piece, board)
    @piece = piece
    @squares = board.squares

    @piece_name = piece['name']
    @piece_position = piece['position']
    @opposing_player_pieces = board.opposing_player.active_pieces.values

    @array = []

    @current_square = squares[piece_position]


    @next_square = piece_position
    @row_index = current_square['row_ind'] - 1
    @column_index = current_square['col_ind']
  end

  def possible_moves
    case piece_name
    when 'king'
      king_moves
    when 'queen'
      generate_possible_queen_moves
    when 'rook'
      rook_moves
    when 'bishop'
      bishop_moves
    when 'knight'
      knight_moves
    when 'pawn'
      generate_possible_pawn_moves
    end
  end

  def generate_possible_queen_moves
    move_up(1, true)

    array
  end

  def generate_possible_pawn_moves
    move_up

    move_up(2) unless piece_is_moved?

    array
  end

  def reset_values
    @next_square = piece_position
    @row_index = current_square['row_ind'] - 1
    @column_index = current_square['col_ind']
  end

  def move_up(step = 1, multiple_moves = false)
    @next_square = convert_to_board_position(@row_index, @column_index += step)

    log_next_square

    return nil if square_is_occupied? || piece_is_on_upper_border?

    multiple_moves == true ? move_up(step, multiple_moves) : reset_values
  end

  #pushes next_square if it is empty or with an opponent's piece to an array of possible moves
  def log_next_square
    log_opponent_square if square_is_opponent_occupied?

    log_square unless square_is_occupied?
  end

  def log_opponent_square
    opposing_player_pieces.each do |piece|
      opposing_piece = piece['position'] + "(capture opposing #{piece['name']})"

      @array << opposing_piece if piece['position'] == next_square
    end
  end

  def square_is_opponent_occupied?
    opposing_player_pieces.each { |piece| return true if piece['position'] == next_square }
  end

  def log_square
    @array << next_square
  end

  def square_is_occupied?
    return false if next_square == piece_position
    square = squares[next_square]

    !square['square'].include?('    ')
  end






  def piece_is_moved?
    piece['moved']
  end

  def piece_is_on_upper_border?
    squares[next_square]['col_ind'] == 8
  end

  def piece_is_on_lower_border?
    squares[next_square]['col_ind'] == 1
  end

  def piece_is_on_right_border?
    squares[next_square]['row_ind'] == 8
  end

  def piece_is_on_left_border?
    squares[next_square]['row_ind'] == 1
  end
end