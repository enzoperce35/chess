require_relative 'turn_players.rb'

# analyzes the move made this turn
class TurnMove < TurnPlayers
  attr_accessor :move, :piece_color, :turn_move, :piece_position

  def left_castling?
    if piece_color == 'black'
      turn_move == 'b1'
    else
      turn_move == 'c1'
    end
  end

  # prevents the app from applying castling repeatedly
  def castling_was_done?
    piece_position == 'a1' || piece_position == 'h1'
  end

  def move_is_castling?
    return false if castling_was_done?

    move.dig('castling')
  end

  def move_is_en_passant?
    move.dig('en_passant')
  end
end
