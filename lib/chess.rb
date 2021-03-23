require_relative './display/side_message.rb'
require_relative './display/chess_board.rb'
require_relative './display/display.rb'
require_relative './modules/helper.rb'
require_relative './move/move.rb'
require_relative './turn/turn.rb'

# controls the program
class Chess
  attr_accessor :chess_players, :game_over, :chess_board, :move, :side_message

  include Helper

  def initialize(chess_players)
    @chess_players = chess_players
    @game_over = false
  end

  def apply_turn_move
    @chess_players = Turn.new(move, chess_players).apply_move
  end

  def replay_turn
    Display.new(chess_board, side_message).merge

    make_a_chess_move
  end

  def no_valid_move?
    move.nil?
  end

  # changes the game state every turn
  def make_a_chess_move
    @move = Move.new(chess_players, chess_board).make_a_move

    no_valid_move? ? replay_turn : apply_turn_move
  end

  # displays the chessboard with information on the side
  def display_chess_board_with_side_message
    @chess_board = ChessBoard.new(chess_players).put_chess_pieces

    @side_message = SideMessage.new(chess_players).create_side_message

    Display.new(chess_board, side_message).merge
  end

  def is_over?
    @game_over == true
  end

  def make_turn
    display_chess_board_with_side_message

    make_a_chess_move
  end
end
