require '/home/edgar/chess/lib/move/piece_moves/directional_moves.rb'
require '/home/edgar/chess/lib/move/piece_moves/knight_moves.rb'
require '/home/edgar/chess/lib/modules/move_directions.rb'
require '/home/edgar/chess/lib/display/chess_board.rb'
require_relative 'check_analyzer.rb'

class CheckNotifier < CheckAnalyzer
  attr_accessor :move, :king_threats

  include MoveDirections

  def initialize(chess_players)
    @chess_players = chess_players
    @turn_piece = turn_piece
    @chess_board = ChessBoard.new(chess_players).put_chess_pieces
    @king_threats = []
  end

  def find_the_blocker
    blocker = convert_to_piece_position(new_square)

    opponent_pieces.each_value do |attributes|
      position = attributes['position']

      if position == blocker
        @blocker = attributes['name']

        @block_position = position
      end
    end
  end

  def count_as_king_check
    @king_threats << "#{blocker} #{block_position}"
  end

  def blocker_is_a_threat?
    case blocker
    when 'king'
      king_is_a_threat?
    when 'queen'
      queen_is_a_threat?
    when 'rook'
      rook_is_a_threat?
    when 'bishop'
      bishop_is_a_threat?
    when 'knight'
      knight_is_a_threat?
    when 'pawn'
      pawn_is_a_threat?
    end
  end

  def count_blocker_as_king_threat
    find_the_blocker

    count_as_king_check if blocker_is_a_threat?
  end

  def move_king_to_knight_directions
    move_king_as = KnightMoves.new(current_square)

    knight_moves = move_king_as.knight_in_all_directions

    knight_moves.each do |move|
      @new_square = move

      @direction = 'knight_directions'

      no_threat? ? next : count_blocker_as_king_threat
    end
  end

  def move_king_from(square, moves = 1)
    @new_square = move.piece_from(*square)

    return nil if new_square_invalid?

    @move_count = moves

    count_blocker_as_king_threat if move_is_blocked?

    move_king_from(new_square, moves += 1) unless another_square_is_not_possible?
  end

  def move_king_to(directions)
    return nil if directions.length.zero?

    @direction = directions.shift

    @move = DirectionalMoves.new(direction)

    move_king_from(current_square)

    move_king_to(directions)
  end

  def find_threats
    @turn_piece = player_king

    move_king_to(all_directions)

    move_king_to_knight_directions

    king_threats
  end
end
