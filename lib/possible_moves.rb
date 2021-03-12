require_relative './piece_moves/castling.rb'
require_relative './piece_moves/en_passant.rb'
require_relative './piece_moves/knight_moves.rb'
require_relative './piece_moves/directional_moves.rb'
require_relative './modules/move_directions.rb'
require_relative './modules/helper.rb'
require_relative 'move.rb'

class PossibleMoves
  attr_accessor :piece, :piece_position, :moves, :chess_board, :player_pieces,
                :opponent_pieces, :current_square, :possible_moves,
                :castling, :multitude, :move, :new_move

  include Helper
  include MoveDirections

  def initialize(piece, chess_board, turn_player, opposing_player)
    @piece_position = piece['position']
    @piece = piece['name']
    @moves = piece['moves']
    @chess_board = chess_board
    @player_pieces = turn_player['active_pieces']
    @opponent_pieces = opposing_player['active_pieces']
    @current_square = [chess_board[piece_position]['row_ind'],
                       chess_board[piece_position]['col_ind']]
    @possible_moves = []
  end

  def en_passant_message
    "(en passant capture opposing pawn #{move.adjacent_piece})"
  end

  def castling_message
    '(castling: with rook h2)'
  end

  def capture_message
    opponent_pieces.each_value do |opponent_piece|
      if opponent_piece['position'] == new_move
        return "(capture opposing #{opponent_piece['name']})"
      end
    end
  end

  def move_message
    if move.is_opponent_blocked?
      capture_message
    elsif move.is_a?(Castling)
      castling_message
    elsif move.is_a?(EnPassant)
      en_passant_message
    else
      ''
    end
  end

  def count_as_a_possible(piece_move)
    @new_move = convert_to_piece_position(piece_move)

    possible_move = new_move + move_message

    possible_moves << possible_move
  end

  def generate_knight_moves
    @move = KnightMove.new(piece, current_square, chess_board, player_pieces, opponent_pieces)

    moves = move.knight_in_all_directions

    moves.each do |knight_move|
      move.new_square = knight_move

      move.is_not_possible? ? next : count_as_a_possible(knight_move)
    end
  end

  def operate_en_passant(direction)
    @move = EnPassant.new(piece, current_square, chess_board, player_pieces,
                          opponent_pieces, direction, false, moves)

    en_passant = move.piece_from_this(*current_square)

    count_as_a_possible(en_passant) if move.is_en_passant_possible?
  end

  def generate_pawn_moves
    traverse(pawn_moves, false)

    2.times { |i| operate_en_passant(intercardinal_directions[i]) }
  end

  def operate_castling
    @move = Castling.new(piece, current_square, chess_board, player_pieces,
                         opponent_pieces, nil, false, moves)

    castling = move.king_behind_rook

    count_as_a_possible(castling) unless move.of_castling_is_impossible?
  end

  def generate_king_moves
    traverse(all_directions, false)

    operate_castling
  end

  def move_chess_piece(square = current_square)
    piece_move = move.piece_from_this(*square)

    move.is_not_possible? ? nil : count_as_a_possible(piece_move)

    move_chess_piece(piece_move) unless move.beyond_is_not_possible?
  end

  def traverse(directions, multiple_times = true)
    return nil if directions.length.zero?

    direction = directions.shift

    @move = DirectionalMoves.new(piece, current_square, chess_board, player_pieces,
                                 opponent_pieces, direction, multiple_times)

    move_chess_piece

    traverse(directions, multiple_times)
  end

  def generate_possible_moves
    case piece
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

    possible_moves
  end
end
