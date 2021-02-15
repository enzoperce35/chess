require_relative 'chess_parts.rb'

module Helper

  include ChessParts

  def convert_to_board_position(coordinates)
    alpha = ('a'..'h').to_a

    row_index, column_index = coordinates

    alpha[row_index-1] + column_index.to_s
  end

  def convert_to_board_coordinates(position)
    alpha = ('a'..'h').to_a

    x_coordinate, y_coordinate = position.split('')

    [alpha.index(x_coordinate), y_coordinate.to_i]
  end

  #returns an array of opposing player's piece positions
  def get_opposing_pieces(board, arr = [])
    board.opposing_player['active_pieces'].each_value do |val|
      arr << val['position']
    end
    arr
  end

  def get_turn_player_pieces(board, arr = [])
    board.turn_player['active_pieces'].each_value do |val|
      arr << val['position']
    end
    arr
  end

  def locate_object_values(hash, object)
    hash['active_pieces'].each { |key,val| object = key if val.values.include?(object) }

    hash['active_pieces'][object]
  end

  def add_new_line(count = 1)
    " \n" * 1
  end

  def convert_to_string(squares, str = '')
    squares.values.each do |square|
      sqr_image = square['square']
      row_index = square['row_ind']
      col_index = square['col_ind']

      str += y_coordinate(col_index) if row_index == 1

      str += sqr_image

      str += new_space if row_index == 8
    end
    ("\n"*2) + str + X_COORDINATES.colorize(color: :red) + ("\n"*2)
  end

  def alter(pieces)
    alpha = ('a'..'h').to_a
    pieces.values.map do |value|
      ind = alpha.index(value['position'][0])
      value['position'][0] = alpha[(7-ind).abs]

      value['position'][-1] = (value['position'][-1].to_i - 9).abs.to_s
    end

    pieces.values
  end

  #trim an array item if the item has a capture message. e.g.'h5(capture opposing pawn)' => 'h5'
  def trim_capture_messages(array, trimmed_items = [])
    array.each { |move| trimmed_items << move[0,2] }

    trimmed_items
  end

  def add_top_spacing(string, count = 0)
    ("\n" * count) + string unless count <= 0
  end

  def add_bottom_spacing(string, count = 0)
    string + ("\n" * count) unless count <= 0
  end

  def adjust_string(string, direction, index)
    case direction
    when 'left'
      string.ljust(index)
    when 'right'
      string.rjust(index)
    end
  end

  def remove_piece_name_suffix(piece_name)
    piece_name.tr("0-9", "")
  end

  def put_colour_to(item, color)
    item.colorize(color: :"#{color}")
  end

  def put_background_color(str, color)
    str.colorize(background: :"#{color}")
  end

  def customize_row_index(row_index)
    row_index += 1
  end
end