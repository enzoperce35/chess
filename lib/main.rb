require_relative 'chess.rb'

class Game < Chess
  def start
    until game_is_over?
      prepare_board

      display_board_with_list_of_pieces

      select_piece

      select_move

      next_turn
    end
  end
end

game = Game.new

game.start
