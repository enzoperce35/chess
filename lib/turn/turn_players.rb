require '/home/edgar/chess/lib/modules/helper.rb'

# analyzes the player and opponent this turn
class TurnPlayers
  attr_accessor :chess_players

  include Helper

  def player_1
    chess_players[0]
  end

  def player_2
    chess_players[1]
  end

  # compares the number of turns made by the chess players
  def player_turns_are_equal?
    player_1['turns'] == player_2['turns']
  end

  def opposing_player
    player_turns_are_equal? ? player_2 : player_1
  end

  def turn_player
    player_turns_are_equal? ? player_1 : player_2
  end

  def player_king
    player_pieces['king1']
  end

  def player_pieces
    turn_player['active_pieces']
  end

  def player_name
    turn_player['name']
  end

  def piece_color
    turn_player['piece_color']
  end

  def opponent_pieces
    opposing_player['active_pieces']
  end

  def current_pieces_position
    Marshal.load(Marshal.dump(chess_players))
  end
end
