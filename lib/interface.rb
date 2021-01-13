module ConsoleInterface

  #ask and get the player's name
  def prompt_name(piece_color)
    puts "Who's Playing #{piece_color}?"

    gets.chomp!
  end

  #ask and the player's piece of choice
  def select_piece(player)
    puts "#{player}'s turn, please select your chess piece"

    gets.chomp!
  end
end