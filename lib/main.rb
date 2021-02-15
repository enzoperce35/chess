require_relative 'player.rb'
require_relative 'chess.rb'

# controls the application
class Game
  attr_reader :player1, :player2

  def set_players
    @player1, @player2 = Player.new.create_players
  end

  def start_game
    Chess.new(player1, player2).play
  end

  def start
    set_players

    start_game
  end
end

Game.new.start
