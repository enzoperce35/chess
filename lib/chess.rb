require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'possible_moves.rb'
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

  def apply_move(chosen_piece, move)
    turn_player.active_pieces.map do |key,val|
       val['position'] = move if val == chosen_piece
    end

    @board = Board.new(turn_player, opposing_player)
  end

  def get_possible_moves(chosen_piece)
    new_move = PossibleMoves.new(chosen_piece, board)

    new_move.generate_possible_moves
  end

  #display current board with side message and prompt turn_player for a piece to move
  def ask_for_a_piece(piece = nil)
    message = active_pieces_side_message(turn_player)

    board.draw_board_with_message(board.squares, message)

    chosen_piece = select_piece_interface(turn_player, message)

    turn_player.active_pieces.each { |key,val| piece = key if val.values.include?(chosen_piece) }

    turn_player.active_pieces[piece]
  end

  def make_move(message = nil)   #fix here!
    puts message unless message.nil?

    chosen_piece = ask_for_a_piece

    chosen_piece_with_moves = get_possible_moves(chosen_piece)

    move = ask_for_a_move_interface(chosen_piece_with_moves, board)

    move_selection_unsuccessful?(move) ? make_move(move) : apply_move(chosen_piece, move)
  end

  def move_selection_unsuccessful?(move)
    move.include?('re-select') || move.include?('No possible moves')
  end

  #program controller
  def start
    board.update_board

    make_move

    board.update_board

    make_move
  end
end