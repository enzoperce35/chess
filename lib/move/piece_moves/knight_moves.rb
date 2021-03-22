class KnightMoves
  attr_accessor :current_square

  def initialize(current_square)
    @current_square = current_square
  end

  def knight_in_all_directions
    row_index, column_index = current_square

    moves = [[row_index - 1, column_index + 2],
             [row_index - 1, column_index - 2],
             [row_index + 1, column_index + 2],
             [row_index + 1, column_index - 2],
             [row_index - 2, column_index + 1],
             [row_index - 2, column_index - 1],
             [row_index + 2, column_index + 1],
             [row_index + 2, column_index - 1]]
  end
end