module ConsoleInterface
  def prompt_name
    puts "Who's Playing #{piece_color}?"

    gets.chomp!
  end

  def select_piece(player)
    puts "#{player}'s turn, please select your chess piece"

    gets.chomp!
  end
end