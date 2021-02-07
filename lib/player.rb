require_relative 'pieces.rb'
require_relative 'interface.rb'

# creates and modify the players and players' attributes
class Player
  attr_accessor :iteration, :name, :piece_color, :piece_set

  # returns a set of chess pieces
  def create_piece_set_for_the_player
    @piece_set = Pieces.new(piece_color).create_piece_set
  end

  # returns the name of the player
  def ask_for_player_name
    # ConsoleInterface.new.prompt_name_interface(piece_color)
    @name = iteration.zero? ? 'John' : 'Mark' # not included
  end

  # returns the color of pieces to be created
  def assign_color_to_the_player
    @piece_color = iteration.zero? ? 'white' : 'black'
  end

  # returns an array of players with a hash of player attributes
  def create_players(players = [])
    2.times do |i|
      @iteration = i

      ask_for_player_name

      assign_color_to_the_player

      create_piece_set_for_the_player

      players << { 'piece_color' => piece_color, 'name' => name, 'active_pieces' => piece_set }
    end
    players
  end
end
