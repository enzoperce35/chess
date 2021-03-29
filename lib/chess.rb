require_relative './display/side_message.rb'
require_relative './display/chess_board.rb'
require_relative './display/display.rb'
require_relative './modules/helper.rb'
require_relative './move/move.rb'
require_relative './turn/turn.rb'
require_relative './modules/player_switcher.rb'
require_relative './king_check/check_notifier.rb'
require_relative './turn/turn_players.rb'

# controls the program
class Chess < TurnPlayers
  attr_accessor :chess_players, :game_over, :chess_board, :move, :side_message,
                :move, :previous_moves, :latest_moves

  include Helper
  include PlayerSwitcher

  def initialize(chess_players)
    @chess_players = chess_players
    @game_over = false
  end

  def switch_turn
    @chess_players = switch(chess_players)
  end

  def add_latest_move
    @chess_players = latest_moves
  end

  def count_this_turn
    turn_player['turns'] += 1
  end

  def next_turn
    count_this_turn

    add_latest_move

    switch_turn
  end

  def retreive_previous_player_moves
    @chess_players = previous_moves
  end

  def replay_turn
    retreive_previous_player_moves

    make_turn
  end

  def king_is_checked?
    checks = CheckNotifier.new(latest_moves).find_threats

    checks.length > 0
  end

  def apply_move
    @latest_moves = Turn.new(move, chess_players).apply_latest_move

    replay_turn if king_is_checked?
  end

  def no_valid_move?
    move.nil?
  end

  # changes the game state every turn
  def make_a_chess_move
    @previous_moves = current_pieces_position

    @move = Move.new(chess_players, chess_board).make_a_move

    no_valid_move? ? replay_turn : apply_move
  end

  # displays the chessboard with information on the side
  def display_chess_board_with_side_message
    @chess_board = ChessBoard.new(chess_players).put_chess_pieces

    @side_message = SideMessage.new(chess_players).create_side_message

    Display.new(chess_board, side_message).attach_and_display
  end

  def is_over?
    @game_over == true
  end

  def make_turn
    display_chess_board_with_side_message

    make_a_chess_move

    next_turn
  end
end
