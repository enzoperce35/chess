class DirectionalMoves
  attr_accessor :direction

  def initialize(direction)
    @direction = direction
  end

  def piece_from_this(row_index, column_index)
    case direction
    when 'up'
      [row_index, column_index + 1]
    when 'down'
      [row_index, column_index - 1]
    when 'left'
      [row_index - 1, column_index]
    when 'right'
      [row_index + 1, column_index]
    when 'up-right'
      [row_index + 1, column_index + 1]
    when 'up-left'
      [row_index - 1, column_index + 1]
    when 'down-right'
      [row_index + 1, column_index - 1]
    when 'down-left'
      [row_index - 1, column_index - 1]
    when 'double-up'
      [row_index, column_index + 2]
    end
  end
end