require_relative 'helper.rb'

class PossibleMoves
  attr_accessor :piece, :board, :new_square, :possible_moves

  include Helper

  def initialize(piece, board)
    @piece = piece
    @board = board
    @new_square = nil
    @possible_moves = []
  end

  #determines if the piece has been moved from it's original position
  def piece_is_moved?
    piece['moved?']
  end

  #returns an array of opposing player's piece positions
  def get_opposing_pieces(arr = [])
    board.opposing_player.active_pieces.each_value do |val|
      arr << val['position']
    end
    arr
  end

  #get the row index and column index of the chess piece inside the chess board
  def get_row_index
    piece_position = piece['position']

    square = board.squares[piece_position]

    square['row_ind'] - 1
  end

  def get_col_index
    piece_position = piece['position']

    square = board.squares[piece_position]

    square['col_ind']
  end

  #determines if the piece is on chess borders during traversal
  def piece_is_on_upper_border?
    board.squares[new_square]['col_ind'] == 8
  end

  def piece_is_on_lower_border?
    board.squares[new_square]['col_ind'] == 1
  end

  def piece_is_on_right_border?
    board.squares[new_square]['row_ind'] == 8
  end

  def piece_is_on_left_border?
    board.squares[new_square]['row_ind'] == 1
  end

  #generate all possible moves the piece can make and put it into an '@possible_moves' array
  def generate_possible_moves(piece_name = piece['name'])
    case piece_name
    when 'king'
      king_moves
    when 'queen'
      generate_queen_moves
    when 'rook'
      rook_moves
    when 'bishop'
      bishop_moves
    when 'knight'
      knight_moves
    when 'pawn'
      generate_pawn_moves
    end
  end

  def generate_queen_moves
    traverse_up(true)

    traverse_down(true)

    traverse_right(true)

    traverse_left(true)

    possible_moves
  end

  def generate_pawn_moves
    traverse_up

    traverse_up(false, 2) unless piece_is_moved?

    possible_moves
  end

  #traverse board squares upward, assign into '@new_square' until square is occupied or in chess border
  def traverse_up(multiple_moves = false, step = 1, row_index = get_row_index, column_index = get_col_index)
    @new_square = convert_to_board_position(row_index, column_index += step)

    log_new_square

    return nil if square_is_occupied? || piece_is_on_upper_border?

    traverse_up(multiple_moves, step, row_index, column_index) if multiple_moves == true
  end

  #traverse board squares downward, assign into '@new_square' until square is occupied or in chess border
  def traverse_down(multiple_moves = false, step = 1, row_index = get_row_index, column_index = get_col_index)
    @new_square = convert_to_board_position(row_index, column_index -= step)

    log_new_square

    return nil if square_is_occupied? || piece_is_on_lower_border?

    traverse_down(multiple_moves, step, row_index, column_index) if multiple_moves == true
  end

  #traverse board squares rightward, assign into '@new_square' until square is occupied or in chess border
  def traverse_right(multiple_moves = false, step = 1, row_index = get_row_index, column_index = get_col_index)
    @new_square = convert_to_board_position(row_index += 1, column_index)

    log_new_square

    return nil if square_is_occupied? || piece_is_on_right_border?

    traverse_right(multiple_moves, step, row_index, column_index) if multiple_moves == true
  end

  #traverse board squares leftward, assign into '@new_square' until square is occupied or in chess border
  def traverse_left(multiple_moves = false, step = 1, row_index = get_row_index, column_index = get_col_index)
    @new_square = convert_to_board_position(row_index -= 1, column_index)

    log_new_square

    return nil if square_is_occupied? || piece_is_on_left_border?

    traverse_left(multiple_moves, step, row_index, column_index) if multiple_moves == true
  end

  #push '@new_square' to '@possible_moves' array square is empty or with an opponent's piece
  def log_new_square
    log_square unless square_is_occupied?

    log_opponent_square if square_is_opponent_occupied?
  end

  def log_square
    @possible_moves << new_square
  end

  def square_is_occupied?
    return false if new_square == piece['position']

    square = board.squares[new_square]

    !square['square'].include?('    ')
  end

  def log_opponent_square
    opponent_pieces = board.opposing_player.active_pieces

    opponent_pieces.each_value do |opponent|
      log_phrase = opponent['position'] + "(capture opposing #{opponent['name']})"

      @possible_moves << log_phrase if opponent['position'] == new_square
    end
  end

  def square_is_opponent_occupied?
    opposing_pieces = get_opposing_pieces

    opposing_pieces.each.include?(new_square)
  end
end