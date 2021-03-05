module Helper

  #trim an item if the item has a capture message. e.g.'h5(capture opposing pawn)' => 'h5'
  def trim_capture_message(item_with_capture_message)
    item_with_capture_message[0,2]
  end

  def locate_values_of(piece_position, player_values)
    player_values.values.each do |attributes|
      attributes.values.each do |value|
        if value == piece_position
          return attributes
        end
      end
    end
  end

  def add_top_spacing(string, count = 0)
    ("\n" * count) + string unless count <= 0
  end

  def add_bottom_spacing(string, count = 0)
    string + ("\n" * count) unless count <= 0
  end

  # adjusts the string to the left-most or right-most of the string_size extended string
  def adjust_string(string, direction, string_size)
    case direction
    when 'left'
      string.ljust(string_size)
    when 'right'
      string.rjust(string_size)
    end
  end

  # uses colorize gem to put color on the background to a string
  def put_background_color_to(str, color)
    str.colorize(background: :"#{color}")
  end

  # given row index is 0-7; adding 1 corrects it for the 8x8 custom chess board
  def customize_row_index(row_index)
    row_index += 1
  end

  # converts a board position to an array of board coordinates a6 => [0,6]
  def convert_to_board_coordinates(position)
    alpha = ('a'..'h').to_a

    x_coordinate, y_coordinate = position.split('')

    [alpha.index(x_coordinate), y_coordinate.to_i]
  end

  # converts an array of board coordinates to a board position [1,6] => a6
  def convert_to_piece_position(coordinates)
    alpha = ('a'..'h').to_a

    row_index, column_index = coordinates

    alpha[row_index-1] + column_index.to_s
  end

  # uses colorize gem to put color to a string
  def put_colour_to(item, color)
    item.colorize(color: :"#{color}")
  end

  # returns a console compatible string formatted unicode
  def encode(unicode)
    unicode.gsub!('U+', '\u')

    unicode.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') }
  end

  # removes the integer suffix on piece_name. knight2 => knight
  def remove_suffix_to(piece_name)
    piece_name.tr("0-9", "")
  end
end