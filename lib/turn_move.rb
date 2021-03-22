require_relative 'turn_players'

class TurnMove < TurnPlayers
  attr_accessor :move, :turn_move, :turn_piece, :piece_position

  def initialize(move, chess_players, turn_piece = move.dig('piece'))
    @move = move
    @chess_players = chess_players
    @turn_move = move.dig('move')
    @piece_position = turn_piece.dig('position')
  end

  def make_an_extra_move_with(rook_position, rook_destination)
    @piece_position = rook_position

    @turn_move = rook_destination

    apply_changes_to_turn_player
  end

  def right_castling?
    turn_move == 'g1'
  end

  def left_castling?
    turn_move == 'c1'
  end

  def apply_castling
    if left_castling?
      make_an_extra_move_with('a1', 'd1')
    elsif right_castling?
      make_an_extra_move_with('h1', 'f1')
    end
  end

  def move_is_castling?
    move.dig('castling')
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

  def move_is_en_passant?
    move.dig('en_passant')
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

    turn_player['turns'] += 1

    chess_players
  end
end