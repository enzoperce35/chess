require_relative './piece_moves/knight_moves.rb'
require_relative './piece_moves/directional_moves.rb'
require_relative './piece_moves/en_passant.rb'
require_relative './piece_moves/castling.rb'
require_relative 'move_analyzer.rb'

class MoveMaker < MoveAnalyzer

  def generate_knight_moves
    @move = KnightMoves.new(current_square)

    moves = move.knight_in_all_directions

    moves.each do |knight_move|
      @new_square = knight_move

      move_invalid? ? next : collect(knight_move)
    end
  end

  def operate_en_passant(direction)
    @move = EnPassant.new(direction, opponent_pieces)

    en_passant = move.pawn_from_this(current_square)

    collect(en_passant) if move.is_en_passant_possible?
  end

  def generate_pawn_moves
    traverse(pawn_moves, false)

    2.times { |i| operate_en_passant(intercardinal_directions[i]) }
  end

  def operate_castling(direction)
    @move = Castling.new(chess_board, direction, current_square, player_pieces)

    castling = move.king_behind_rook

    collect(castling) unless move.castling_is_impossible?
  end

  def generate_king_moves
    traverse(all_directions, false)

    2.times { |i| operate_castling(i.zero? ? 'left' : 'right') }
  end

  def move_chess_piece(square = current_square)
    @new_square = move.piece_from_this(*square)

    move_invalid? ? nil : collect(new_square)

    move_chess_piece(new_square) unless another_move_is_not_possible?
  end

  def traverse(directions, multiple_times = true)
    return nil if directions.length.zero?

    @direction = directions.shift

    @multitude = multiple_times

    @move = DirectionalMoves.new(direction)

    move_chess_piece

    traverse(directions, multiple_times)
  end

  def make_piece_moves
    @piece_moves = []

    case piece_name
    when 'queen'
      traverse(all_directions)
    when 'rook'
      traverse(cardinal_directions)
    when 'bishop'
      traverse(intercardinal_directions)
    when 'king'
      generate_king_moves
    when 'pawn'
      generate_pawn_moves
    when 'knight'
      generate_knight_moves
    end

  piece_moves
  end
end
