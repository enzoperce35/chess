require_relative 'board.rb'
require_relative 'chess_move.rb'
require_relative 'helper.rb'
require_relative 'display.rb'

# this is the application's framework
class Chess
  attr_accessor :chess_players, :chess_board, :turn_count, :board,
                :piece, :move

  include Helper

  def initialize(chess_players)
    @chess_players = chess_players
    @turn_count = 1
    @game_over = false
  end

  # returns the player which will make a move
  def turn_player
    player1, player2 = @chess_players

    turn_count.odd? ? player1 : player2
  end

  # returns the player which will make a move next
  def opposing_player
    player1, player2 = @chess_players

    turn_count.odd? ? player2 : player1
  end

  # increments @turn_count, thus switching the players
  def next_turn
    @turn_count += 1
  end

  def apply_changes_to_opposing_player(pieces)
    pieces.delete_if do |_key, val|
      val['position'] == move
    end
  end

  def apply_changes_to_turn_player(pieces)
    pieces.map do |_key, val|
      next unless val['position'] == piece

      val['position'] = move

      val['moved?'] = true
    end
  end

  def apply_chess_move
    chess_players.each do |player|
      pieces = player['active_pieces']

      if player == turn_player
        apply_changes_to_turn_player(pieces)
      else
        apply_changes_to_opposing_player(pieces)
      end
    end
  end

  def make_a_chess_move
    prompt = ChessMove.new(chess_board, turn_player, opposing_player)

    @piece = prompt.chess_piece_to_move

    @move = prompt.chess_square_to_put(piece)

    move.nil? ? play : apply_chess_move
  end

  # returns an array of altered board coordinates
  def alter_board(x_coord, y_coord)
    [x_coord = (8 - x_coord).abs,

     y_coord = (9 - y_coord).abs]
  end

  def alter_pieces_positions
    chess_players.each do |player|
      player['active_pieces'].values.map do |piece|
        piece_position = piece['position']

        coordinates = convert_to_board_coordinates(piece_position)

        coordinates = alter_board(*coordinates)

        piece_position = convert_to_piece_position(coordinates)

        piece['position'] = piece_position
      end
    end
  end

  def display_chess_board_with_side_message
    @chess_players = alter_pieces_positions

    @chess_board = ChessBoard.new(chess_players).put_chess_pieces

    side_message = SideMessage.new(turn_player).create_side_message

    Display.new(chess_board, side_message).display
  end

  # returns true if game is over
  def is_over?
    @game_over == true
  end

  # make player turns until game is over
  def play
    #piece_moves_tester
    display_chess_board_with_side_message

    make_a_chess_move

    next_turn
  end
end




#just a tester, remove unnecessary or put up pieces that is needed to test piece moves
#to be put anywhere inside 'chess.rb'
#to be called at the second line of 'start_method' after 'set_players' in 'main.rb'
#inspect @possible_moves at interface.rb to see all possible moves of the chesen piece being tested
def piece_moves_tester

  delete_all_black

  delete_all_white


  place_piece('bishop', 'h2', turn_player)
  place_piece('queen', 'g4', turn_player)
  place_piece('pawn', 'f6', opposing_player)
  place_piece('queen', 'b4', opposing_player)

  #need to alter chessplayers
end

#middle
#corner1, 2, 3, 4,

#remove all white pieces
def delete_all_white
  turn_player['active_pieces'] = {}
end

#remove all black_pieces
def delete_all_black
  opposing_player['active_pieces'] = {}
end

# returns an array of altered board coordinates
def alter_coordinates(board_coordinate)
  x_coord, y_coord = board_coordinate

  x_coord = (8 - x_coord).abs

  y_coord = (9 - y_coord).abs

  [x_coord, y_coord]
end

def alter_position_of(piece_position)
  board_coordinate = convert_to_board_coordinates(piece_position)

  altered_board_coordinate = alter_coordinates(board_coordinate)

  convert_to_piece_position(altered_board_coordinate)
end

#creates a name, image, position values to each or either of the 'turn' or 'opposing' player's 'active_pieces'
def place_piece(piece, index, player)
  index = alter_position_of(index)

  image = get_image(piece)

  image = put_colour_to(image, 'black') if player['piece_color'] == 'black'

  player['active_pieces'].store("#{piece}1", {"name"=>"#{piece}", "image"=>image, "position"=>"#{index}", "moved?"=>false, "moves"=>[]})
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
