module SideMessage
  def create_message_lines(list, counter = 0)
    arr = Array.new(6) { Array.new }

    list.each do |item|
      counter = 0 if counter == 6

      arr[counter] << item.ljust(13)

      counter += 1
    end
    arr.map! { |i| i.join.rstrip }
  end

  def create_list_items(pieces, arr = [])
    pieces.each do |key,value|
        piece = "   " + key.tr("0-9", "") + " #{value['position']}"
        arr << piece
    end
    arr
  end

  def modify(piece_moves)
    piece_moves.map! { |move| "   " + move}

    piece_moves
  end

  def active_pieces_side_message(player)
    piece_color = player.piece_color
    active_pieces = player.active_pieces

    items = create_list_items(active_pieces)

    upper_line = ["#{piece_color.upcase} PIECES".rjust(26)]
    body_lines = create_message_lines(items)

    upper_line + body_lines
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
end