require_relative './modules/helper.rb'
require_relative 'side_message.rb'
require_relative 'chess_board.rb'
require_relative 'player_move.rb'
require_relative 'display.rb'

# controls the application
class Chess
  attr_accessor :chess_players, :chess_board, :turn_count,
                :turn_piece, :turn_move, :side_message, :player_move, :pieces

  include Helper

  def initialize(chess_players)
    @chess_players = chess_players
    @turn_count = 1
    @game_over = false
  end

  def turn_player
    player1, player2 = @chess_players

    turn_count.odd? ? player1 : player2
  end

  def opposing_player
    player1, player2 = @chess_players

    turn_count.odd? ? player2 : player1
  end

  # increments @turn_count, thus switching the players
  def next_turn
    @turn_count += 1
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

      if player == turn_player
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
    @player_move = PlayerMove.new(chess_board, turn_player, opposing_player)

    @turn_piece = player_move.choose_a_piece

    @turn_move = player_move.choose_a_square_to_put(turn_piece)

    no_possible_move? ? redo_chess_move : apply_chess_move
  end

  # alters each chess pieces' board position coordinates
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

  # displays the virtual chess board with game information on the side
  def display_chess_board_with_side_message
    @chess_players = alter_pieces_positions

    @chess_board = ChessBoard.new(chess_players).put_chess_pieces

    @side_message = SideMessage.new(turn_player).create_side_message

    Display.new(chess_board, side_message).attach_and_display
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
