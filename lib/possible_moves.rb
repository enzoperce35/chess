require_relative './modules/helper.rb'
require_relative './chess_moves/directional_move.rb'
require_relative './chess_moves/knight_move.rb'

class PossibleMoves
  attr_accessor :piece, :piece_position, :moved, :chess_board, :possible_moves, :opponent_pieces,
                :current_square, :cardinal_directions, :intercardinal_directions, :move, :player_pieces

  include Helper

  def initialize(piece, chess_board, turn_player, opposing_player)
    @piece = piece['name']
    @piece_position = piece['position']
    @moved = piece['moved?']

    @chess_board = chess_board
    @player_pieces = turn_player['active_pieces']
    @opponent_pieces = opposing_player['active_pieces']

    @cardinal_directions = ['up', 'down', 'left', 'right']
    @intercardinal_directions = ['up-right', 'up-left', 'down-left', 'down-right']
    @possible_moves = []

    @current_square = [ chess_board[piece_position]['row_ind'],
                        chess_board[piece_position]['col_ind']  ]
  end


  def piece_was_moved?
    moved
  end

  def generate_knight_moves
    @move = KnightMove.new(chess_board, player_pieces, opponent_pieces)

    knight_moves = move.knight_to_all_directions_from_the(*current_square)

    knight_moves.each { |knight_move| count_as_a_possible(knight_move) }
  end

  def compile_opponent_pieces(arr = [])
    opponent_pieces.each_value do |val|
      arr << val['position']
    end

    arr
  end

  def move_is_opponent_blocked?(piece_move)
    ally_pieces = compile_opponent_pieces

    ally_pieces.include?(piece_move)
  end

  def add_capture_message_to(piece_move)
    opponent_pieces.each_value do |opponent_piece|
      if opponent_piece['position'] == piece_move
        return opponent_piece['position'] + "(capture opposing #{opponent_piece['name']})"
      end
    end
  end

  def count_as_a_possible(piece_move)
    piece_move = convert_to_piece_position(piece_move)

    piece_move = add_capture_message_to(piece_move) if move_is_opponent_blocked?(piece_move)

    possible_moves << piece_move
  end

  def move_chess_piece
    piece_move = move.to_a_new_square

    if move.is_not_valid?
      return nil
    else
      count_as_a_possible(piece_move)
    end

    move_chess_piece unless move.beyond_is_not_possible?
  end

  def traverse(directions, multiple_times = true)
    return nil if directions.length.zero?

    direction = directions.shift

    @move = DirectionalMove.new(direction, chess_board, player_pieces, current_square, multiple_times)

    move_chess_piece

    traverse(directions, multiple_times)
  end

  def traverse_all_directions(multiple_times)
    all_directions = cardinal_directions + intercardinal_directions

    traverse(all_directions, multiple_times)
  end

  #generate all possible moves the piece can make
  def generate_possible_moves
    case piece
    when 'king'
      traverse_all_directions(false)
    when 'queen'
      traverse_all_directions(true)
    when 'rook'
      traverse(cardinal_directions)
    when 'bishop'
      traverse(intercardinal_directions)
    when 'knight'
      generate_knight_moves
    when 'pawn'
      traverse(['up'], false)
    end

    possible_moves
  end
end
