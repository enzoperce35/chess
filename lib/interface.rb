module ConsoleInterface

  #ask and get the player's name
  def prompt_name_interface(piece_color)
    puts "Who's Playing #{piece_color}?"

    gets.chomp!
  end

  #ask and the player's piece of choice
  def select_piece_interface(player, string)   #working, but needs cleaning
    pieces = string.join.scan(/(\w\. \w+ \w\d)/)

    string = string.join.scan(/(\w\.)/).map { |x| x[0].tr('.', '') }.sort { |a,b| a <=> b }

    puts "#{player}'s turn, please select your chess piece"

    piece = gets.chomp! until string.include?(piece)

    pieces.each { |x| return x[0].scan(/\w\d/).join if x[0].include?(piece + '. ') }
  end
end