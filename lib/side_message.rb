require_relative 'helper.rb'

class SideMessage
  attr_accessor :player_name, :piece_color, :active_pieces, :message_items, :message_lines

  include Helper

  def initialize(turn_player)
    @player_name = turn_player['name']
    @piece_color = turn_player['piece_color']
    @active_pieces = turn_player['active_pieces']
  end





  def modify(piece_moves)
    piece_moves.map! { |move| "   " + move}

    piece_moves
  end



  def possible_moves_side_message(piece)
    piece_name = piece['name']
    piece_position = piece['position']
    piece_moves = piece['moves']

    items = modify(piece_moves)

    upper_line = ["'#{piece_name.upcase} #{piece_position.upcase}' MOVES".rjust(26)]
    body_lines = create_message_lines(piece_moves)

    upper_line + body_lines
  end

  # returns an array of string converted message lines with white spaces removed to it's right side
  def convert_message_line_arrays_into_a_string
    message_lines.map! { |line_arr| line_arr.join.rstrip }
  end

  # pushes the adjusted message items one at a time into each array containers of @message_lines
  def put_message_lines_into_container(line_index = 0)
    message_items.each do |item|
      line_index = 0 if line_index == 6

      adjusted_message_item = adjust_string(item, 'left', 13)

      @message_lines[line_index] << adjusted_message_item

      line_index += 1
    end
  end

  # initializes an array of six empty arrays to contain the message lines
  def create_message_lines_container
    @message_lines = Array.new(6) { Array.new }
  end

  # creates the message lines
  def create_message_lines
    create_message_lines_container

    put_message_lines_into_container

    convert_message_line_arrays_into_a_string
  end

  # returns an array containing the center adjusted message header string
  def create_a_centered_message_header
    message_header = "#{piece_color.upcase} PIECES"

    centered_message_header = adjust_string(message_header, 'right', 26)

    Array.new { centered_message_header }
  end

  # creates and populate an array with the message items
  def create_message_items
    @message_items = []

    active_pieces.each do |piece_name, attribute|
      margin = '    '

      piece_name = remove_piece_name_suffix(piece_name)

      white_space = ' '

      piece_position = attribute['position']

      piece =  margin + piece_name + white_space + piece_position

      @message_items << piece
    end
  end

  # returns an array of side message lines
  def create_side_message
    create_message_items

    message_header = create_a_centered_message_header

    message_body = create_message_lines

    message_header + message_body
  end
end