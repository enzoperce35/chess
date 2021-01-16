module SideMessage

  def active_pieces_side_message(player)
    piece_color = player.piece_color
    active_pieces = player.active_pieces

    items = create_list_items(active_pieces)

    upper_line = ["#{piece_color.upcase} PIECES".rjust(23)]
    body_lines = create_message_lines(items)

    upper_line + body_lines
  end

  def create_list_items(pieces, arr = [], alpha = ('a'..'p').to_a)
    pieces.each do |key,value|
        piece = "#{alpha.shift}. " + key.tr("0-9", "") + " #{value['position']}"
        arr << piece
    end
    arr
  end

  def create_message_lines(list, counter = 0)
    arr = Array.new(6) { Array.new }

    list.each do |item|
        counter = 0 if counter == 6

        arr[counter] << item.ljust(15)

        counter += 1
    end
    arr.map! { |i| i.join.rstrip }
  end
end