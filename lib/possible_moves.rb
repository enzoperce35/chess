require_relative 'helper.rb'

class PossibleMoves
  attr_accessor :piece, :board, :new_square, :possible_moves

  include Helper

  def initialize(piece, board)
    @piece = piece
    @board = board
    @new_square = piece['position']
    @possible_moves = piece['moves']
  end

  #determines if the piece has been moved from it's original position
  def piece_is_moved?
    piece['moved?']
  end

  #get the row index and column index of the piece's position on the chess board
  def get_row_index
    piece_position = piece['position']

    square = board.squares_hash[piece_position]

    square['row_ind']
  end

  def get_col_index
    piece_position = piece['position']

    square = board.squares_hash[piece_position]

    square['col_ind']
  end

  #alters the values of row_index and column_index of the piece's position on the chess board
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

  def alter_knight_coordinates(row_index, col_index, array = [])
    coords = [[row_index - 1, col_index + 2],
              [row_index - 1, col_index - 2],
              [row_index + 1, col_index + 2],
              [row_index + 1, col_index - 2],
              [row_index - 2, col_index + 1],
              [row_index - 2, col_index - 1],
              [row_index + 2, col_index + 1],
              [row_index + 2, col_index - 1]]

    coords.each { |coord| array << coord unless out_of_border?(coord) }

    array
  end

  #returns true if the traversing piece is on one of the chess board's four borders
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
    board.squares_hash[new_square]['col_ind'] == 8
  end

  def piece_is_on_lower_border?
    board.squares_hash[new_square]['col_ind'] == 1
  end

  def piece_is_on_right_border?
    board.squares_hash[new_square]['row_ind'] == 8
  end

  def piece_is_on_left_border?
    board.squares_hash[new_square]['row_ind'] == 1
  end

  def out_of_border?(coordinates)
    row_index, column_index = coordinates

    !row_index.between?(0,7) || !column_index.between?(1,8)
  end

  #push @new_square unless board coordinates is not out of the chess borders
  def log_knight_moves(moves)
    return moves if moves.length == 0

    @new_square = moves.shift

    coordinates = convert_to_board_coordinates(new_square)

    log_new_square unless out_of_border?(coordinates)

    log_knight_moves(moves)
  end

  #returns true if @new_square is occupied by opponent's piece
  def square_is_opponent_occupied?
    opposing_pieces = get_opposing_pieces(board)

    opposing_pieces.each.include?(new_square)
  end

  #returns true if @new_square is not empty
  def square_is_occupied?
    return false if new_square == piece['position']

    square = board.squares_hash[new_square]

    !square['square'].include?('    ')
  end

  #push @new_square to @possible_moves if it is occupied by opponent's square
  def log_opponent_square
    opponent_pieces = board.opposing_player['active_pieces']

    opponent_pieces.each_value do |opponent|
      log_phrase = opponent['position'] + "(capture opposing #{opponent['name']})"

      @possible_moves << log_phrase if opponent['position'] == new_square
    end
  end

  #push @new_square to @possible_moves
  def log_square
    @possible_moves << new_square
  end

  #push @new_square to @possible_moves if square is empty or with an opponent's piece
  def log_new_square
    log_square unless square_is_occupied?

    log_opponent_square if square_is_opponent_occupied?
  end

  #assign converted board coordinates to @new_square then push to @possible_moves
  def log_coordinates(coordinates)
    @new_square = convert_to_piece_position(coordinates)

    log_new_square
  end

  #alter the board coordinates of the piece until move is not possible
  def traverse(direction, multi_moves = true, row_index = get_row_index, column_index = get_col_index)
    coordinates = alter_coordinates(direction, row_index, column_index)

    row_index, column_index = coordinates

    log_coordinates(coordinates) unless out_of_border?(coordinates)

    return nil if square_is_occupied? || unable_to_continue?(direction) || !multi_moves || out_of_border?(coordinates)

    traverse(direction, multi_moves, row_index, column_index)
  end

  #directs the travesal with the basic directions(cardinal) and diagonal directions(intercardinal)
  def traverse_cardinal_directions(multi_moves = true)
    card_dir = ['up', 'down', 'left', 'right']

    4.times { traverse(card_dir.shift, multi_moves) }
  end

  def traverse_intercardinal_directions(multi_moves = true)
    inter_dir = ['up-right', 'up-left', 'down-right', 'down-left']

    4.times { traverse(inter_dir.shift, multi_moves) }
  end

  #traverse squares in the direction the piece is allowed to move; push to @possible_moves
  def generate_king_moves
    traverse_cardinal_directions(false)

    traverse_intercardinal_directions(false)

    piece
  end

  def generate_queen_moves
    traverse_cardinal_directions

    traverse_intercardinal_directions

    piece
  end

  def generate_rook_moves
    traverse_cardinal_directions

    piece
  end

  def generate_bishop_moves
    traverse_intercardinal_directions

    piece
  end

  def generate_knight_moves
    altered_coordinates = alter_knight_coordinates(get_row_index, get_col_index)

    knight_moves = altered_coordinates.map { |coords| convert_to_piece_position(coords) }

    log_knight_moves(knight_moves)

    piece
  end

  def generate_pawn_moves
    traverse('up', false)

    traverse('double_up', false) unless piece_is_moved?

    piece
  end

  #generate all possible moves the piece can make
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
end