require_relative 'directional_moves.rb'

class EnPassant < DirectionalMoves
  attr_reader :prev_move

  def adjacent_piece
    prev_move['position']
  end

  def player_pawn_is_adjacent_to?(opponent_pawn)
    row_index, column_index = current_square

    case direction
    when 'up-left'
      opponent_pawn == [row_index - 1, column_index]
    when 'up-right'
      opponent_pawn == [row_index + 1, column_index]
    end
  end

  def is_opponent_pawn_first_move?
    prev_move['moves'] == 1
  end

  def opponent_last_move_is_not_a_pawn?
    prev_move.nil? || prev_move['name'] != 'pawn'
  end

  def show_opponent_last_move
    opponent_pieces.each_value do |piece|
      if piece.keys.any? { |key| key == 'latest_move' }
        return piece
      end
    end
    nil
  end

  def is_en_passant_possible?
    @prev_move = show_opponent_last_move

    return false if opponent_last_move_is_not_a_pawn?

    opponent_pawn = convert_to_board_coordinates(prev_move['position'])

    player_pawn_is_adjacent_to?(opponent_pawn) && is_opponent_pawn_first_move?
  end

end