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

  #modifies the values of row_index and column_index depending on the traversal direction of the piece
  def alter_coordinates(direction, row_index, column_index)
    case direction
    when 'up'
      [row_index, column_index += 1]
    when 'down'
      [row_index, column_index -= 1]
    when 'left'
      [row_index -= 1, column_index]
    when 'right'
      [row_index += 1, column_index]
    when 'up-right'
      [row_index += 1, column_index += 1]
    when 'up-left'
      [row_index -= 1, column_index += 1]
    when 'down-right'
      [row_index += 1, column_index -= 1]
    when 'down-left'
      [row_index -= 1, column_index -= 1]
    when 'double_up'
      [row_index, column_index + 2]
    end
  end

  #determines if the traversal cannot continue because piece is on chess borders
  def unable_to_continue?(direction)
    case direction
    when 'up',
      piece_is_on_upper_border?
    when 'down'
      piece_is_on_lower_border?
    when 'left'
      piece_is_on_left_border?
    when 'right'
      piece_is_on_right_border?
    when 'up-right'
      piece_is_on_upper_border? || piece_is_on_right_border?
    when 'up-left'
      piece_is_on_upper_border? || piece_is_on_left_border?
    when 'down-right'
      piece_is_on_lower_border? || piece_is_on_right_border?
    when 'down-left'
      piece_is_on_lower_border? || piece_is_on_left_border?
    end
  end

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
      generate_king_moves
    when 'queen'
      generate_queen_moves
    when 'rook'
      generate_rook_moves
    when 'bishop'
      generate_bishop_moves
    when 'knight'
      generate_knight_moves
    when 'pawn'
      generate_pawn_moves
    end
  end

  def generate_king_moves
    traverse('up', true)

    traverse('down', true)

    traverse('left', true)

    traverse('right', true)

    traverse('up-right', true)

    traverse('up-left', true)

    traverse('down-right', true)

    traverse('down-left', true)

    possible_moves
  end

  def generate_queen_moves
    traverse 'up'

    traverse 'down'

    traverse 'left'

    traverse 'right'

    traverse 'up-right'

    traverse 'up-left'

    traverse 'down-right'

    traverse 'down-left'

    possible_moves
  end

  def generate_rook_moves
    traverse 'up'

    traverse 'down'

    traverse 'left'

    traverse 'right'

    possible_moves
  end

  def generate_bishop_moves
    traverse 'up-right'

    traverse 'up-left'

    traverse 'down-right'

    traverse 'down-left'

    possible_moves
  end

  def generate_knight_moves
    altered_coordinates = alter_knight_coordinates(get_row_index, get_col_index)

    knight_moves = altered_coordinates.map { |coords| convert_to_board_position(coords) }

    log_knight_moves(knight_moves)

    possible_moves
  end

  def alter_knight_coordinates(row_index, col_index)
    [[row_index - 1, col_index + 2],
     [row_index - 1, col_index - 2],
     [row_index + 1, col_index + 2],
     [row_index + 1, col_index - 2],
     [row_index - 2, col_index + 1],
     [row_index - 2, col_index - 1],
     [row_index + 2, col_index + 1],
     [row_index + 2, col_index - 1]]
  end

  def log_knight_moves(moves)
    return moves if moves.length == 0

    @new_square = moves.shift

    coordinates = convert_to_board_coordinates(new_square)

    log_new_square unless out_of_border?(coordinates)

    log_knight_moves(moves)
  end

  def generate_pawn_moves
    traverse('up', true)

    traverse('double_up', true) unless piece_is_moved?

    possible_moves
  end

  def traverse(direction, single_move = false, row_index = get_row_index, column_index = get_col_index)
    coordinates = alter_coordinates(direction, row_index, column_index)

    row_index, column_index = coordinates

    log_coordinates(coordinates)

    return nil if square_is_occupied? || unable_to_continue?(direction) || single_move

    traverse(direction, single_move, row_index, column_index)
  end

  def log_coordinates(coordinates)
    @new_square = out_of_border?(coordinates) ? nil : convert_to_board_position(coordinates)

    log_new_square
  end

  def out_of_border?(coordinates)
    row_index, column_index = coordinates

    !row_index.between?(0,7) || !column_index.between?(1,8)
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