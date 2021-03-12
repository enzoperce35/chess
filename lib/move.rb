require_relative './modules/helper.rb'
require_relative './modules/move_directions.rb'

class Move
  attr_accessor :piece, :direction, :current_square, :chess_board, :player_pieces,
                :opponent_pieces, :multitude, :moves, :new_square

  include Helper
  include MoveDirections

  def initialize(piece, current_square, chess_board, player_pieces,
                 opponent_pieces, direction = nil, multitude = nil, moves = nil)

    @piece = piece
    @direction = direction
    @current_square = current_square
    @chess_board = chess_board
    @player_pieces = player_pieces
    @opponent_pieces = opponent_pieces
    @multitude = multitude
    @moves = moves
  end

  def compile_opponent_pieces(arr = [])
    opponent_pieces.each_value do |val|
      arr << val['position']
    end
    arr
  end

  def is_opponent_blocked?
    return false if new_square == current_square

    new_piece_position = convert_to_piece_position(new_square)

    opponent_pieces = compile_opponent_pieces

    opponent_pieces.include?(new_piece_position)
  end

  def move_is_a_single_move?
    multitude == false
  end

  def move_is_on_the_borders?
    row_index, column_index = new_square

    case direction
    when 'up',
      column_index == 8
    when 'down'
      column_index == 1
    when 'left'
      row_index == 1
    when 'right'
      row_index == 8
    when 'up-right'
      column_index == 8 || row_index == 8
    when 'up-left'
      column_index == 8 || row_index == 1
    when 'down-right'
      column_index == 1 || row_index == 8
    when 'down-left'
      column_index == 1 || row_index == 1
    end
  end

  def beyond_is_not_possible?
    move_is_out_of_border? || move_is_on_the_borders? || move_is_a_single_move? || move_is_blocked?
  end

  def move_is_blocked?
    return false if new_square == current_square

    new_piece_position = convert_to_piece_position(new_square)

    new_piece_square = chess_board[new_piece_position]['square']

    !new_piece_square.include?('    ')
  end

  def compile_ally_pieces(arr = [])
    player_pieces.each_value do |val|
      arr << val['position']
    end
    arr
  end

  def move_is_ally_blocked?
    return false if new_square == current_square

    move_position = convert_to_piece_position(new_square)

    ally_pieces = compile_ally_pieces

    ally_pieces.include?(move_position)
  end

  def not_a_first_move?
    moves > 0
  end

  def move_is_out_of_border?
    row_index, column_index = new_square

    !row_index.between?(1,8) || !column_index.between?(1,8)
  end

  def check_each_pawns_direction
    case direction
    when 'up'
      move_is_out_of_border? || move_is_blocked?
    when 'double-up'
      not_a_first_move? || move_is_blocked?
    when  'up-left', 'up-right'
      move_is_out_of_border? || move_is_ally_blocked? || !move_is_blocked?
    end
  end

  def is_not_possible?
    if piece == 'pawn'
      check_each_pawns_direction
    else
      move_is_out_of_border? || move_is_ally_blocked?
    end
  end
end