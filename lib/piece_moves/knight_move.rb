require_relative 'directional_move.rb'

class KnightMove < DirectionalMove
  attr_accessor :chess_board, :player_pieces, :opponent_pieces, :move

  def initialize(chess_board, player_pieces, opponent_pieces)
    @chess_board = chess_board
    @player_pieces = player_pieces
    @opponent_pieces = opponent_pieces
  end

  def compile(pieces, arr = [])
    pieces.each_value do |val|
      arr << val['position']
    end
    arr
  end

  def is_opponent_blocked?(knight_move)
    new_piece_position = convert_to_piece_position(knight_move)

    chess_pieces = compile(opponent_pieces)

    chess_pieces.include?(new_piece_position)
  end

  def move_is_ally_blocked?
    new_piece_position = convert_to_piece_position(move)

    chess_pieces = compile(player_pieces)

    chess_pieces.include?(new_piece_position)
  end

  def move_is_out_of_border?
    row_index, column_index = move

    !row_index.between?(1,8) || !column_index.between?(1,8)
  end

  def move_is_an_invalid?(move)
    @move = move

    move_is_out_of_border? || move_is_ally_blocked?
  end

  def knight_to_all_directions_from_the(row_index, column_index)
    moves = [[row_index - 1, column_index + 2],
             [row_index - 1, column_index - 2],
             [row_index + 1, column_index + 2],
             [row_index + 1, column_index - 2],
             [row_index - 2, column_index + 1],
             [row_index - 2, column_index - 1],
             [row_index + 2, column_index + 1],
             [row_index + 2, column_index - 1]]

    moves = moves.delete_if { |move| move_is_an_invalid?(move) }

    moves
  end
end