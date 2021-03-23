# creates the special chess move castling
class Castling
  attr_accessor :chess_board, :direction, :current_square, :player_pieces

  def initialize(chess_board, direction, current_square, player_pieces)
    @chess_board = chess_board
    @direction = direction
    @current_square = current_square
    @player_pieces = player_pieces
  end

  # returns true if any of the squares between rook and king is not empty
  def unempty?(squares)
    squares_between = Array.new(squares.length) { |i| chess_board[squares[i]] }

    squares_between.each do |square|
      square = square.dig('square')

      return true if !square.include?('    ')
    end

    false
  end

  # gets the squares between the king and rook
  def show_squares_between
    case direction
    when 'left'
      ['b1', 'c1', 'd1']
    when 'right'
      ['f1', 'g1']
    end
  end

  # prevents castling when a castling piece was already moved
  def moved?(castling_pieces)
    castling_pieces.each do |piece|
      move_count = player_pieces[piece]['moves']

      return true if !move_count.zero?
    end

    false
  end

  def unavailable?(castling_rook)
    player_pieces[castling_rook].nil?
  end

  def castling_rook
    direction == 'left' ? 'rook1' : 'rook2'
  end

  def castling_is_impossible?
    squares_between = show_squares_between

    *castling_pieces = 'king1', castling_rook

    unavailable?(castling_rook) || moved?(castling_pieces) || unempty?(squares_between)
  end

  def king_behind_rook
    row_index, column_index = current_square

    if direction == 'left'
      [row_index - 2, column_index]
    else
      [row_index + 2, column_index]
    end
  end
end
