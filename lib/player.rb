require_relative 'pieces.rb'

class Player < Pieces
  attr_accessor :piece_color

  def initialize(piece_color)
    @piece_color = piece_color
    @name = prompt_name
    @active_pieces = create_pieces
  end

  def prompt_name
    puts "Who's Playing #{piece_color}?"

    gets.chomp!
  end
end