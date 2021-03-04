require_relative 'user_prompt.rb'
require_relative 'pieces.rb'

# creates and modify the players and players' attributes
class ChessPlayer
  attr_accessor :piece_color

  include UserPrompt

  def initialize(piece_color)
    @piece_color = piece_color
  end

  def assign_piece_set
    ChessPieces.new.create_piece_set_for(piece_color)
  end

  def prompt_name
    puts player_name_prompt(piece_color)

    gets.chomp!
  end

  def set_player
    #player_name = prompt_name
    player_name = 'sample_name'

    piece_set = assign_piece_set

    { 'name' => player_name, 'piece_color' => piece_color, 'active_pieces' => piece_set }
  end
end
