require_relative './modules/helper.rb'
require_relative './modules/user_prompt.rb'
require_relative 'side_message.rb'
require_relative './move/move.rb'
require_relative 'chess_board.rb'
require_relative 'display.rb'
require_relative 'turn_move.rb'

class Chess
  attr_accessor :chess_players, :chess_board, :move, :side_message

  include Helper
  include UserPrompt

  def initialize(chess_players)
    @chess_players = chess_players
    @game_over = false
  end

  def no_valid_move?
    move.nil?
  end

  def replay_turn
    Display.new(chess_board, side_message).merge

    make_a_chess_move
  end

  def make_a_chess_move
    @move = Move.new(chess_players, chess_board).make_a_move

    if no_valid_move?
      replay_turn
    else
      @chess_players = TurnMove.new(move, chess_players).apply_move
    end
  end

  def display_chess_board_with_side_message
    @chess_board = ChessBoard.new(chess_players).put_chess_pieces

    @side_message = SideMessage.new(chess_players).create_side_message

    Display.new(chess_board, side_message).merge
  end

  def is_over?
    @game_over == true
  end

  def play
    display_chess_board_with_side_message

    make_a_chess_move
  end
end
