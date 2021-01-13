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
  end

  #returns the player which will make a move
  def turn_player
    turn_count.odd? ? player2 : player1
  end

  #returns the player which will make a move next
  def opposing_player
    turn_count.odd? ? player1 : player2
  end

  #place each players' active pieces to their corresponding square position
  def place(player_pieces)
    player_pieces.values.each do |piece|
      image, position = piece.values

      square = @board.squares[position]

      square['square'] = board.colorize_square(image, square['col_ind'], square['row_ind'])
    end
  end

  #displays the current state of the chess board
  def display_board
    board.draw_board(board.squares.values)
  end

  #asks for a piece to move
  def ask_for_a_piece
    select_piece(turn_player.name)
  end

  #program controller
  def start
    ask_for_a_piece

    2.times { |i| i.zero? ? place(opposing_player.active_pieces) : place(turn_player.active_pieces) }

    display_board
  end
end