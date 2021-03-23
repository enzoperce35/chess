require_relative 'turn_move.rb'

# modifies the chess players' active pieces
class Turn < TurnMove
  attr_accessor :turn_piece

  def initialize(move, chess_players, turn_piece = move.dig('piece'))
    @move = move
    @chess_players = chess_players
    @turn_move = move.dig('move')
    @piece_color = turn_piece.dig('color')
    @piece_position = turn_piece.dig('position')
  end

  # count this turn the return chess players' new state
  def finalize_turn
    turn_player['turns'] += 1

    chess_players
  end

  def move_rook_to_left_side_of(row_index, col_index)
    king_left_side = [row_index - 1, col_index]

    convert_to_piece_position(king_left_side)
  end

  def move_rook_to_right_side_of(row_index, col_index)
    king_right_side = [row_index + 1, col_index]

    convert_to_piece_position(king_right_side)
  end

  def apply_castling
    king_position = convert_to_board_coordinates(turn_move)

    @turn_move =
    if left_castling?
      @piece_position = 'a1'

      move_rook_to_right_side_of(*king_position)
    else
      @piece_position = 'h1'

      move_rook_to_left_side_of(*king_position)
    end

    apply_changes_to_turn_player
  end

  def apply_changes_to_turn_player
    player_pieces.map do |_key, val|
      val.delete_if { |k, v| k == 'latest_move' }

      next unless val['position'] == piece_position

      val['position'] = turn_move

      val['moves'] += 1

      val['latest_move'] = true
    end
    apply_castling if move_is_castling?
  end

  def adjacent_opponent_piece
    row_ind, col_ind = convert_to_board_coordinates(turn_move)

    adjacent_piece = [row_ind, col_ind - 1]

    convert_to_piece_position(adjacent_piece)
  end

  def apply_changes_to_opposing_player
    opponent_pieces.delete_if do |_key, val|
      if move_is_en_passant?
        val['position'] == adjacent_opponent_piece
      else
        val['position'] == turn_move
      end
    end
  end

  def apply_move
    apply_changes_to_opposing_player

    apply_changes_to_turn_player

    finalize_turn
  end
end
