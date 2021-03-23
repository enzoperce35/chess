require '/home/edgar/chess/lib/modules/helper.rb'

# creates the special chess move en passant
class EnPassant
  attr_reader :direction, :row_index, :column_index, :prev_move, :opponent_pieces

  include Helper

  def initialize(direction, opponent_pieces)
    @direction = direction
    @opponent_pieces = opponent_pieces
  end

  # gets the piece adjacent to the turn player pawn
  def adjacent_piece
    prev_move['position']
  end

  def player_pawn_is_adjacent_to?(opponent_pawn)
    case direction
    when 'up-left'
      opponent_pawn == [row_index - 1, column_index]
    when 'up-right'
      opponent_pawn == [row_index + 1, column_index]
    end
  end

  # returns true if opponents last pawn move is a two square move
  def is_opponent_pawn_first_move?
    prev_move['moves'] == 1
  end

  # returns false if opponent hasn't made move or move was not pawn
  def opponent_last_move_is_not_a_pawn?
    prev_move.nil? || prev_move['name'] != 'pawn'
  end

  def show_opponent_last_move
    opponent_pieces.each_value do |piece|
      if piece.keys.any? { |key| key == 'latest_move' }
        return piece
      end
    end
    nil
  end

  # prevents making en passant when special conditions are not met
  def is_en_passant_possible?
    @prev_move = show_opponent_last_move

    return false if opponent_last_move_is_not_a_pawn?

    opponent_pawn = convert_to_board_coordinates(prev_move['position'])

    player_pawn_is_adjacent_to?(opponent_pawn) && is_opponent_pawn_first_move?
  end

  # returns a modified pawn en_passant move
  def pawn_from(current_square)
    @row_index, @column_index = current_square

    case direction
    when 'up-left'
      [row_index - 1, column_index + 1]
    when 'up-right'
      [row_index + 1, column_index + 1]
    end
  end
end
