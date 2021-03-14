require_relative './modules/user_prompt.rb'
require_relative 'piece_set.rb'

# sets the chess players with their attributes
class Player
  attr_accessor :piece_color

  include UserPrompt

  def initialize(piece_color)
    @piece_color = piece_color
  end

  def assign_piece_set
    PieceSet.new(piece_color).create_piece_set
  end

  def prompt_name
    puts player_name_prompt(piece_color)

    gets.chomp!
  end

  def set_player
    player_name = prompt_name

    piece_set = assign_piece_set

    { 'name' => player_name, 'piece_color' => piece_color, 'active_pieces' => piece_set }
  end
end
