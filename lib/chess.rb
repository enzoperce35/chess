require_relative './modules/helper.rb'
require_relative './display/display.rb'
require_relative 'player_move.rb'
require_relative 'turn_players.rb'

class Chess
  attr_accessor :chess_players, :chess_board, :turn_count, :turn,
                :turn_piece, :turn_move, :side_message, :player_move, :pieces

  include Helper

  def initialize(chess_players)
    @chess_players = chess_players
    @game_over = false
  end

  def next_turn
    @turn = Turn.new(chess_players)
  end

  def adjacent_opponent_piece
    row_ind, col_ind = convert_to_board_coordinates(turn_move)

    adjacent_piece = [row_ind, col_ind - 1]

    convert_to_piece_position(adjacent_piece)
  end

  def apply_changes_to_opposing_player
    pieces.delete_if do |_key, val|
      if player_move.is_en_passant?
        val['position'] == adjacent_opponent_piece
      else
        val['position'] == turn_move
      end
    end
  end

  def apply_rook_changes_with(rook_position, rook_destination)
    @turn_piece = rook_position

    @turn_move = rook_destination

    apply_changes_to_turn_player
  end

  def right_castling?
    turn_move == 'g1'
  end

  def left_castling?
    turn_move == 'c1'
  end

  def apply_castling
    if left_castling?
      apply_rook_changes_with('a1', 'd1')
    elsif right_castling?
      apply_rook_changes_with('h1', 'f1')
    end
  end

  def apply_changes_to_turn_player
    pieces.map do |_key, val|
      val.delete_if { |k, v| k == 'latest_move' }

      next unless val['position'] == turn_piece

      val['position'] = turn_move

      val['moves'] += 1

      val['latest_move'] = true
    end
    apply_castling if player_move.is_castling?
  end

  # modifies chess player pieces in accordance with the chess move made
  def apply_chess_move
    chess_players.each do |player|
      @pieces = player['active_pieces']

      if player == turn.player
        player['turns'] += 1
        apply_changes_to_turn_player
      else
        apply_changes_to_opposing_player
      end
    end
  end

  def redo_chess_move
    no_move_phrase = turn_move

    puts no_move_phrase

    Display.new(chess_board, side_message).attach_and_display

    make_a_chess_move
  end

  def no_possible_move?
    turn_move.nil? || turn_move.include?('No possible move')
  end

  def make_a_chess_move
    @player_move = PlayerMove.new(chess_board, turn.player, turn.opposing_player)

    @turn_piece = player_move.choose_a_piece

    @turn_move = player_move.choose_a_square_to_put(turn_piece)

    no_possible_move? ? redo_chess_move : apply_chess_move
  end


  # displays the virtual chess board with game information on the side
  def display_chess_board_with_side_message
    display = Display.new(chess_players)

    display.chess_board_with_side_message
  end

  def is_over?
    @game_over == true
  end

  def play
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


  piece_moves_check_set

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
  place_piece('bishop', 'h7', opposing_player)
  place_piece('king', 'd8', opposing_player)
end

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

  x_coord = (9 - x_coord).abs

  y_coord = (9 - y_coord).abs

  [x_coord, y_coord]
end

def alter_position_of(piece_position)
  board_coordinate = convert_to_board_coordinates(piece_position)

  altered_board_coordinate = alter_coordinates(board_coordinate)

  convert_to_piece_position(altered_board_coordinate)
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

  index = alter_position_of(index)

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
