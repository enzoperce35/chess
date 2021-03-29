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
  attr_accessor :chess_players, :game_over, :chess_board,
                :move, :previous_moves, :latest_moves

  include Helper
  include PlayerSwitcher

  def initialize(chess_players)
    @chess_players = chess_players
    @game_over = false
    piece_moves_tester
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

    display_chess_board_with_side_message

    make_a_chess_move
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

    side_message = SideMessage.new(chess_players).create_side_message

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

#just a tester, remove unnecessary or put up pieces that is needed to test piece moves
#to be put anywhere inside 'chess.rb'
#to be called at the last line of 'initialize_method' of chess.rb
#inspect @possible_moves at interface.rb to see all possible moves of the chosen piece being tested
#if placing multiple same piece in place_piece method, the next piece should be the same with the last piece

def piece_moves_tester

  delete_all_black

  delete_all_white


  #piece_moves_check_set
  place_piece('king', 'e4', turn_player)
  place_piece('pawn', 'c2', turn_player)
  place_piece('queen', 'c1', turn_player)
  place_piece('rook', 'e1', turn_player)
  place_piece('knight', 'f2', turn_player)
  place_piece('knight', 'b3', turn_player)



  place_piece('queen', 'h3', opposing_player)
  place_piece('rook', 'h4', opposing_player)
  place_piece('rook', 'h7', opposing_player)
  place_piece('bishop', 'a3', opposing_player)
  place_piece('bishop', 'c5', opposing_player)
  place_piece('pawn', 'b5', opposing_player)
  place_piece('pawn', 'e2', opposing_player)
  place_piece('king', 'd8', opposing_player)
  place_piece('knight', 'b4', opposing_player)
  place_piece('knight', 'h5', opposing_player)
end

def piece_moves_check_set
  place_piece('king', 'e1', turn_player)
  place_piece('rook', 'a1', turn_player)
  place_piece('rook', 'h1', turn_player)
  place_piece('queen', 'e4', turn_player)
  place_piece('knight', 'g5', turn_player)
  place_piece('pawn', 'd2', turn_player)
  place_piece('pawn', 'g2', turn_player)
  place_piece('pawn', 'h2', turn_player)
  place_piece('pawn', 'b3', turn_player)
  place_piece('pawn', 'c4', opposing_player)
  place_piece('pawn', 'f7', opposing_player)
  place_piece('pawn', 'b7', opposing_player)
  place_piece('pawn', 'a7', opposing_player)
  place_piece('rook', 'b5', opposing_player, 1)
  place_piece('rook', 'a8', opposing_player)

end

#remove all white pieces
def delete_all_white
  chess_players.map do |player|
    if player['piece_color'] == 'white'
      player['active_pieces'] = {}
    end
  end
end

#remove all black_pieces
def delete_all_black
  chess_players.map do |player|
    if player['piece_color'] == 'black'
      player['active_pieces'] = {}
    end
  end
end

# returns an array of splitted piece name and piece suffix
def split_piece_name_of(last_added_piece)
  last_added_piece.scan(/\d+|\D+/)
end

# add a number suffix to 'piece_name' which represents it's multitude
def add_suffix(name, player)
  last_added_piece = player['active_pieces'].keys[-1]

  prev_name, suffix = split_piece_name_of(last_added_piece) unless last_added_piece.nil?

  if name == prev_name
    name += (suffix.to_i + 1).to_s
  else
    name += '1'
  end
end

#creates a name, image, position values to each or either of the 'turn' or 'opposing' player's 'active_pieces'
def place_piece(piece, index, player, moves = 0)
  piece_name = add_suffix(piece, player)

  image = get_image(piece)

  image = put_colour_to(image, 'black') if player['piece_color'] == 'black'

  player['active_pieces'].store(piece_name, {"name"=>"#{piece}", "image"=>image, "position"=>"#{index}", "moves"=>moves})
end

#returns the piece image
def get_image(piece_name)
  case piece_name
  when 'king'
    "\u265A"
  when 'queen'
    "\u265B"
  when 'bishop'
    "\u265D"
  when 'rook'
    "\u265C"
  when 'knight'
    "\u265E"
  when 'pawn'
    "\u265F"
  end
end
