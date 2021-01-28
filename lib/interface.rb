module ConsoleInterface

  #ask and get the player's name
  def prompt_name_interface(piece_color)
    puts "Who's Playing #{piece_color}?"

    gets.chomp!
  end

  #ask and the player's piece of choice
  def select_piece_interface(player, string)
    name = player.name

    pieces = string.join.scan(/(\w\d)/)

    puts "#{name}'s turn\n\n".rjust(26),
         "Please select your chess piece. e.g. '#{pieces[0].join}"

    ans = gets.chomp! until pieces.include?([ans])

    ans
  end

  def ask_for_a_move_interface(piece, board)
    piece_name = piece['name']

    piece_position = piece['position']

    piece_moves = piece['moves']

    all_squares = board.squares.keys

    puts "\n\nPlease select a square to put your #{piece_name}"

    ans = gets.chomp! until all_squares.include?(ans)

    validate_answer(ans, piece, board)
  end

  def validate_answer(ans, piece, board)
    piece_position = piece['position']
    piece_moves = piece['moves']
    piece_name = piece['name']


    if piece_moves.include?(ans)
      ans
    else
      puts "\n\ninvalid move '#{piece_position} to #{ans}'..., please choose an option below\n",
           "'p' => choose another piece",
           "'l' => get a list of '#{piece_name}-#{piece_position}' moves"
           option = gets.chomp! until ['p','l'].include?(option)
           implement_option(option, piece, board)
    end
  end

  def implement_option(option, piece, board)
    piece_position = piece['position']
    piece_moves = piece['moves']
    piece_name = piece['name']

    if option == 'p'
      "select other piece"
    elsif option == 'l'
      puts "\n'#{piece_name}-#{piece_position}' valid moves:",
           piece_moves
      move = gets.chomp! until piece_moves.include?(move)
      move
    end
  end
end