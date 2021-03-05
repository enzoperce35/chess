require_relative './modules/helper.rb'
require_relative 'side_message.rb'
require_relative 'chess_board.rb'
require_relative 'chess_move.rb'
require_relative 'display.rb'

# controls the application
class Chess
  attr_accessor :chess_players, :chess_board, :turn_count,
                :turn_piece, :turn_move, :side_message

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

  def apply_changes_to_opposing_player(pieces)
    pieces.delete_if do |_key, val|
      val['position'] == turn_move
    end
  end

  def apply_changes_to_turn_player(pieces)
    pieces.map do |_key, val|
      next unless val['position'] == turn_piece

      val['position'] = turn_move

      val['moved?'] = true
    end
  end

  # modifies chess player pieces in accordance with the chess move made
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
    prompt = ChessMove.new(chess_board, turn_player, opposing_player)

    @turn_piece = prompt.chess_piece_to_move

    @turn_move = prompt.chess_square_to_put(turn_piece)

    no_possible_move? ? redo_chess_move : apply_chess_move
  end

  # returns an array of altered x and y board coordinates
  def alter_board(x_coord, y_coord)
    [x_coord = (8 - x_coord).abs,

     y_coord = (9 - y_coord).abs]
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
