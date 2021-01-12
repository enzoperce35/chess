require_relative 'player.rb'
require_relative 'board.rb'
require 'colorize'

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

  def put_pieces(player)
    player.active_pieces.values.each do |attribute|
      active_piece = attribute['position']

      square = @board.squares[active_piece]

      x = square['row_ind']
      y = square['col_ind']
      image = player == opposing_player ? attribute['image'].colorize(color: :black) : attribute['image']

      square['square'] = board.square(image, y, x)
    end
  end

  def display_board
    board.draw_board(board.squares.values)
  end

  def turn_player
    turn_count.odd? ? player2 : player1
  end

  def opposing_player
    turn_count.odd? ? player1 : player2
  end

  def start
    select_piece(turn_player.name)
    2.times { |i| i.zero? ? put_pieces(opposing_player) : put_pieces(turn_player) }
    display_board
  end
end