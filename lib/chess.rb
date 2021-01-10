require_relative 'player.rb'
require_relative 'board.rb'

class Chess
  attr_accessor :player1, :player2, :turn_count, :board

  include ChessParts
  include ConsoleInterface

  def initialize
    @player1 = Player.new('white')
    @player2 = Player.new('black')
    @board = Board.new
    @turn_count = 0

    player1.name = 'John'  #not included
    player2.name = 'Mark'  #not included
  end

  def display_board
    board.draw_board
  end

  def turn_player
    turn_count.odd? ? player2 : player1
  end

  def start
    display_board
    select_piece(turn_player.name)
  end
end