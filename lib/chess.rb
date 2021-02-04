require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'helper.rb'

class Chess
  attr_accessor :turn_count, :player1, :player2, :board, :interface, :chosen_piece, :game_over, :move

  include Helper

  def initialize
    @turn_count = 1
    @player1 = Player.new('white')
    @player2 = Player.new('black')
    @game_over = false

    player1.name = 'John'  #not included
    player2.name = 'Mark'  #not included
  end

  #returns the player which will make a move
  def turn_player
    turn_count.odd? ? player1 : player2
  end

  #returns the player which will make a move next
  def opposing_player
    turn_count.odd? ? player2 : player1
  end

  #increments @turn_count, thus switching the players
  def next_turn
    @turn_count += 1
  end

  #return to piece selection phase
  def repeat_turn
    select_piece(move)

    select_move
  end

  #modify 'opposing_player' values with the changes made by this turn
  def apply_changes_to_opposing_player
    opposing_player.active_pieces.delete_if do |key,val|
      val['position'] == move
    end
  end

  #modify 'turn_player' values with the changes made by this turn
  def apply_changes_to_turn_player
    turn_player.active_pieces.map do |key,val|
      next unless val == chosen_piece

      val['position'] = move

      val['moves'] = []

      val['moved?'] = true
    end
  end

  #alter the pieces' positions then use those to instantiate 'Board'; re-assign to @board
  def apply_move
    apply_changes_to_turn_player

    apply_changes_to_opposing_player

    @board = Board.new(turn_player, opposing_player)
  end

  #returns true if the input does not have the following words
  def input_is_valid?
    !move.include?('re-select') && !move.include?('No possible moves')
  end

  #asks user to input a move, 'apply_move' if input is valid, otherwise 'repeat_turn'
  def select_move
    @move = interface.ask_for_move(chosen_piece)

    input_is_valid? ? apply_move : repeat_turn
  end

  #asks user to input the piece to move; a message is displayed in case of 'repeat_turn'
  def select_piece(extra_message = nil)
    puts extra_message unless extra_message.nil?

    @interface = ConsoleInterface.new(turn_player, board)

    @chosen_piece = interface.ask_for_piece
  end

  #displays the chess board with the list of turn player's active pieces
  def display_board_with_list_of_pieces
    board_with_side_message = board.create_board_with_side_message(board)

    puts board_with_side_message
  end

  #sets the new state of the chess board
  def set_chess_board
    @board = Board.new(turn_player, opposing_player)

    board.populate_board
  end

  #alters piece positions of each player, then instantiates them to a new 'Board' class
  def prepare_board
    board.switch_player_pieces unless turn_count == 1

    set_chess_board
  end

  def game_is_over?
    @game_over == true
  end
end

#just a tester, remove unnecessary or put up pieces that is needed to test piece moves
#tobe put anywhere inside 'chess.rb'
#to be called on the very first line of 'start_method' of 'main.rb'
def piece_moves_tester
  @board = Board.new(turn_player, opposing_player)

  delete_all_black

  delete_all_white

  place_piece('queen', 'c8', opposing_player)
  place_piece('rook', 'g8', opposing_player)
  place_piece('queen', 'h8', turn_player)
end

#remove all white pieces
def delete_all_white
  turn_player.active_pieces = {}
end

#remove all black_pieces
def delete_all_black
  opposing_player.active_pieces = {}
end

#creates a name, image, position values to each or either of the 'turn' or 'opposing' player's 'active_pieces'
def place_piece(piece, index, player)
  image = get_image(piece)

  image = colorize_piece(image) if player.piece_color == 'black'

  player.active_pieces.store("#{piece}1", {"name"=>"#{piece}", "image"=>image, "position"=>"#{index}", "moved?"=>false, "moves"=>[]})
end

#returns the piece image
def get_image(piece_name)
  case piece_name
  when 'king'
    " \u265A  "
  when 'queen'
    " \u265B  "
  when 'bishop'
    " \u265D  "
  when 'rook'
    " \u265C  "
  when 'knight'
    " \u265E  "
  when 'pawn'
    " \u265F  "
  end
end
