require './lib/helper.rb'

class DirectionalMove
  attr_reader :chess_board, :player_pieces, :current_square,
              :direction, :new_square, :multiple_times

  include Helper

  def initialize(direction, chess_board, player_pieces, current_square, multiple_times)
    @chess_board = chess_board
    @direction = direction
    @player_pieces = player_pieces
    @new_square = current_square
    @multiple_times = multiple_times
  end

  def move_is_out_of_border?
    row_index, column_index = new_square

    !row_index.between?(1,8) || !column_index.between?(1,8)
  end

  def compile_ally_pieces(arr = [])
    player_pieces.each_value do |val|
      arr << val['position']
    end
    arr
  end

  def move_is_a_single_move?
    multiple_times == false
  end

  def move_is_ally_blocked?
    return false if new_square == current_square

    new_piece_position = convert_to_piece_position(new_square)

    ally_pieces = compile_ally_pieces

    ally_pieces.include?(new_piece_position)
  end

  def move_is_blocked?
    return false if new_square == current_square

    new_piece_position = convert_to_piece_position(new_square)

    new_piece_square = chess_board[new_piece_position]['square']

    !new_piece_square.include?('    ')
  end

  def move_is_on_the_borders?
    row_index, column_index = new_square

    case direction
    when 'up',
      column_index == 8
    when 'down'
      column_index == 1
    when 'left'
      row_index == 1
    when 'right'
      row_index == 8
    when 'up-right'
      column_index == 8 || row_index == 8
    when 'up-left'
      column_index == 8 || row_index == 1
    when 'down-right'
      column_index == 1 || row_index == 8
    when 'down-left'
      column_index == 1 || row_index == 1
    end
  end

  def is_not_valid?
    move_is_out_of_border? || move_is_ally_blocked?
  end

  def beyond_is_not_possible?
    move_is_on_the_borders? || move_is_a_single_move? || move_is_blocked?
  end

  def to_a_new_square
    row_index, column_index = new_square

    @new_square =
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
    end
  end
end