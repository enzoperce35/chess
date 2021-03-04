require_relative 'player.rb'
require_relative 'chess.rb'

# controls the application
class Game

  def start
    chess_players = Array.new(2) { |i| ChessPlayer.new( i.zero? ? 'white' : 'black').set_player }

    game = Chess.new(chess_players)

    game.play until game.is_over?
  end
end

Game.new.start