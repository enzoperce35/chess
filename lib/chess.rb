require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'side_message.rb'
require 'colorize'

class Chess
  attr_accessor :turn_count, :player1, :player2, :board

  include ConsoleInterface
  include SideMessage

  def initialize
    @turn_count = 0
    @player1 = Player.new('white')
    @player2 = Player.new('black')
    @board = Board.new(turn_player, opposing_player)

    player1.name = 'John'  #not included
    player2.name = 'Mark'  #not included
  end

  #returns the player which will make a move
  def turn_player
    turn_count.odd? ? player2 : player1
  end

  #returns the player which will make a move next
  def opposing_player
    turn_count.odd? ? player1 : player2
  end

  #display current board with side message and prompt turn_player for a piece to move
  def ask_for_a_piece
    message = active_pieces_side_message(turn_player)

    board.draw_board_with_message(board.squares, message)

    select_piece_interface(turn_player.name, message)
  end

  #program controller
  def start
    board.update_board

    ask_for_a_piece
  end
end