require './lib/move.rb'

class Castling < Move

  def king_behind_rook
    row_index, column_index = current_square

    @new_square = [row_index + 2, column_index]

    new_square
  end

  def squares_between_are_not_empty?
    squares_between = chess_board['f1'], chess_board['g1']

    squares_between.each do |square|
      square = square.dig('square')

      return true if !square.include?('    ')
    end

    false
  end

  def rook_is_moved?
    move_count = player_pieces['rook2'].dig('moves')

    !move_count.zero?
  end

  def king_is_moved?
    move_count = player_pieces['king1'].dig('moves')

    !move_count.zero?
  end

  def castling_pieces_are_moved?
    king_is_moved? || rook_is_moved?
  end

  def castling_rook_is_not_available?
    player_pieces['rook2'].nil?
  end

  def of_castling_is_impossible?
    castling_rook_is_not_available? || castling_pieces_are_moved? || squares_between_are_not_empty?
  end
end