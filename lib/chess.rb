require_relative 'player.rb'

class Chess
  attr_accessor :player1, :player2

  include ChessParts

  def initialize
    @player1 = Player.new('white')
    @player2 = Player.new('black')
  end
end