require_relative 'board.rb'
require_relative 'pieces.rb'
require_relative 'helper.rb'

# this is the application's framework
class Chess < Board
  attr_accessor :turn_count, :player1, :player2, :board,
                :interface, :chosen_piece, :game_over, :move

  include Helper

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @turn_count = 1
    @game_over = false
  end

  # returns the player which will make a move
  def turn_player
    turn_count.odd? ? player1 : player2
  end

  # returns the player which will make a move next
  def opposing_player
    turn_count.odd? ? player2 : player1
  end

  # increments @turn_count, thus switching the players
  def next_turn
    @turn_count += 1
  end

  # return to piece selection phase
  def repeat_turn
    select_piece(move)

    select_move
  end

  # modify 'opposing_player' attributes with the changes made by this turn
  def apply_changes_to_opposing_player
    opposing_player['active_pieces'].delete_if do |_key, val|
      val['position'] == move
    end
  end

  # modify 'turn_player' attributes with the changes made by this turn
  def apply_changes_to_turn_player
    turn_player['active_pieces'].map do |_key, val|
      next unless val == chosen_piece

      val['position'] = move

      val['moves'] = []

      val['moved?'] = true
    end
  end

  # alter the pieces' positions then use those to instantiate 'Board'; assign to '@board'
  def apply_move
    apply_changes_to_turn_player

    apply_changes_to_opposing_player

    save_board_and_player_changes
  end

  # returns true if the input does not have the following words
  def input_is_valid?
    !move.include?('re-select') && !move.include?('No possible moves')
  end

  # asks user to input a move, 'apply_move' if input is valid, otherwise 'repeat_turn'
  def select_move
    @move = interface.ask_for_move(chosen_piece)

    input_is_valid? ? apply_move : repeat_turn
  end

  # asks user to input the piece to move; a message is displayed in case of 'repeat_turn'
  def select_piece(extra_message = nil)
    puts extra_message unless extra_message.nil?

    @interface = ConsoleInterface.new(turn_player, board)

    @chosen_piece = interface.ask_for_piece
  end

  # displays the chess board with the list of turn player's active pieces
  def display_board_with_list_of_pieces
    board_with_side_message = board.create_board_with_side_message

    puts board_with_side_message
  end

  # insert chess piece images into the board squares
  def put_in_the_chess_pieces
    board.populate_board
  end

  # creates a hash of the chess board's squares
  def set_an_empty_chess_board
    @board.squares_hash = create_squares
  end

  # instantiate players' values
  def save_board_and_player_changes
    @board = Board.new(turn_player, opposing_player)
  end

  # puts the top side pieces to the bottom side and the bottom side pieces to the top side
  def switch_board_sides
    2.times do |i|
      player_pieces = i.zero? ? turn_player['active_pieces'] : opposing_player['active_pieces']

      Pieces.new.alter_pieces_position(player_pieces)
    end
  end

  # sets the new state of the chess board
  def prepare_chess_board
    switch_board_sides

    save_board_and_player_changes

    set_an_empty_chess_board

    put_in_the_chess_pieces
  end

  # returns true if game is over
  def game_is_over?
    @game_over == true
  end

  # make player turns until game is over
  def play
    until game_is_over?
      prepare_chess_board

      display_board_with_list_of_pieces

      select_piece

      select_move

      next_turn
    end
  end
end
