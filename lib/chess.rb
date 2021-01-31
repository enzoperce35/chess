require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'possible_moves.rb'
require_relative 'side_message.rb'
require_relative 'helper.rb'
require 'colorize'

class Chess
  attr_accessor :turn_count, :player1, :player2, :board, :game_over

  include ConsoleInterface
  include SideMessage
  include Helper

  def initialize
    @turn_count = 1
    @player1 = Player.new('white')
    @player2 = Player.new('black')
    @board = nil
    @game_over = false

    player1.name = 'John'  #not included
    player2.name = 'Mark'  #not included
  end

  def set_positions
    alter_pieces(turn_player.active_pieces)
    alter_pieces(opposing_player.active_pieces)
  end

  #returns the player which will make a move
  def turn_player
    turn_count.odd? ? player1 : player2
  end

  #returns the player which will make a move next
  def opposing_player
    turn_count.odd? ? player2 : player1
  end

  #alter the pieces' positions then use those to instantiate 'Board'; re-assign to @board
  def apply_move(chosen_piece, move)
    opposing_player.active_pieces.map do |key,val|
      opposing_player.active_pieces.delete(key) if val['position'] == move
    end

    turn_player.active_pieces.map do |key,val|
      val['position'] = move if val == chosen_piece
    end

    @board = Board.new(turn_player, opposing_player)
  end

  #returns an array of the chosen piece's possible moves
  def get_possible_moves(chosen_piece)
    new_move = PossibleMoves.new(chosen_piece, board)

    new_move.generate_possible_moves
  end

  #returns true if the input does not have the following words
  def input_is_valid?(input)
    !input.include?('re-select') && !input.include?('No possible moves')
  end

  #prompt for input; locate the input's values then return it with it's possible moves
  def ask_for_a_piece(piece = nil)
    chosen_piece = select_piece_interface(turn_player, board)

    chosen_piece = locate_object(turn_player, chosen_piece)

    get_possible_moves(chosen_piece)
  end

  #increments @turn_count, thus switching the players
  def next_turn
    @turn_count += 1
  end

  #asks for an input; apply input if valid otherwise repeat 'make_move' but with an extra message
  def make_move(extra_message = nil)
    puts extra_message unless extra_message.nil?

    chosen_piece = ask_for_a_piece

    input = ask_for_a_move_interface(chosen_piece, board)

    input_is_valid?(input) ? apply_move(chosen_piece, input) : make_move(input)
  end

  #displays the chess board with the list of turn player's active pieces
  def display_board_with_message
    active_pieces_message = active_pieces_side_message(turn_player)

    board_with_message = board.draw_board_with_message(board, active_pieces_message)

    puts board_with_message
  end

  def switch_board_sides
    set_positions unless turn_count == 1

    @board = Board.new(turn_player, opposing_player)

    board.update_board
  end

  #program controller
  def start
    until game_over == true
      switch_board_sides

      display_board_with_message

      make_move

      next_turn
    end
  end
end