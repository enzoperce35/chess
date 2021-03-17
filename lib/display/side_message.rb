require_relative 'chess_board'

class SideMessage < ChessBoard

  def string_convert_each_item_inside(item_container)
    item_container.map! { |item| item.join.rstrip }

    item_container
  end

  # pushes the adjusted message items one at a time into each item containers
  def put_message_items_into(item_container, message_items, line_index = 0)
    message_items.each do |item|
      line_index = 0 if line_index == 6

      adjusted_message_item = adjust_string(item, 'left', 13)

      item_container[line_index] << adjusted_message_item

      line_index += 1
    end
    item_container
  end

  # returns an array of modified chess piece information
  def create_message_items(items = [])
    player_pieces.each do |piece_name, attribute|
      margin = '    '

      piece_name = remove_suffix_to(piece_name)

      blank_space = ' '

      piece_position = attribute['position']

      piece = margin + piece_name + blank_space + piece_position

      items << piece
    end
    items
  end

  # returns an array of stringed informations
  def create_message_body
    item_container = Array.new(6) { [] }

    message_items = create_message_items

    item_container = put_message_items_into(item_container, message_items)

    string_convert_each_item_inside(item_container)
  end


  def create_message_header
    message_header = "#{piece_color.upcase} PIECES"

    centered_message_header = adjust_string(message_header, 'right', 26)

    [centered_message_header]
  end

  # returns an array of message string lines
  def create_side_message
    header = create_message_header

    body = create_message_body

    header + body
  end
end
