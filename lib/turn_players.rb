class TurnPlayers
  attr_accessor :chess_players

  def player_1
    chess_players[0]
  end

  def player_2
    chess_players[1]
  end

  def player_turns_are_equal?
    player_1['turns'] == player_2['turns']
  end

  def opposing_player
    !player_turns_are_equal? ? player_2 : player_1
  end

  def player
    player_turns_are_equal? ? player_1 : player_2
  end

  def player_pieces
    player['active_pieces']
  end

  def player_name
    player['name']
  end

  def piece_color
    player['piece_color']
  end
end