module ConsoleInterface

  #ask and get the player's name
  def prompt_name_interface(piece_color)
    puts "Who's Playing #{piece_color}?"

    gets.chomp!
  end

  #ask and the player's piece of choice
  def select_piece_interface(player, string)
    pieces = string.join.scan(/(\w\d)/)

    puts "#{player}'s turn, please select your chess piece. e.g. 'e1'"

    ans = gets.chomp! until pieces.include?([ans])

    ans
  end
end