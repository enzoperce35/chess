require_relative 'chess.rb'

# controls the application
class Game < Chess
  def start_game
    until game_is_over?
      prepare_board

      display_board_with_list_of_pieces

      select_piece

      select_move

      next_turn
    end
  end

  def start
    set_players

    start_game
  end
end

Game.new.start
