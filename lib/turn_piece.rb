require '/home/edgar/chess/lib/modules/user_prompt.rb'
require_relative 'turn_players.rb'

class TurnPiece < TurnPlayers
  attr_accessor :turn_piece, :chess_board

  include UserPrompt

  def piece_name
    turn_piece['name']
  end

  def piece_position
    turn_piece['position']
  end

  def move_count
    turn_piece['moves']
  end

  def current_square
    [chess_board[piece_position]['row_ind'],
     chess_board[piece_position]['col_ind']]
  end
end