require '/home/edgar/chess/lib/turn_piece.rb'

class MoveCollector < TurnPiece
  attr_reader :move, :new_move, :piece_moves

  def en_passant_message
    "(en passant capture opposing pawn #{move.adjacent_piece})"
  end

  def castling_message
    rook = new_move == 'c1' ? 'rook a1' : 'rook h1'

    "(castling: with #{rook})"
  end

  def capture_message
    opponent_pieces.each_value do |opponent_piece|
      if opponent_piece['position'] == new_move
        return "(capture opposing #{opponent_piece['name']})"
      end
    end
  end

  def move_message
    if move.is_a?(EnPassant)
      en_passant_message
    elsif move.is_a?(Castling)
      castling_message
    elsif is_opponent_blocked?
      capture_message
    else
      ''
    end
  end

  def collect(piece_move)
    @new_move = convert_to_piece_position(piece_move)

    possible_move = new_move + move_message

    piece_moves << possible_move
  end
end