require_relative 'pieces.rb'
require_relative 'interface.rb'

# creates and modify the players and players' attributes
class Player
  attr_accessor :iteration, :player_name, :piece_color, :piece_set

  # gets a set of chess pieces
  def create_piece_set_for_the_player
    @piece_set = Pieces.new(piece_color).create_piece_set
  end

  # gets the name of the player
  def ask_for_player_name
    #@player_name = ConsoleInterface.new.ask_player_name_for(piece_color)
    @player_name = iteration.zero? ? 'John' : 'Mark' # not included
  end

  # gets the color for the pieces
  def assign_color_to_the_player
    @piece_color = iteration.zero? ? 'white' : 'black'
  end

  # returns an array of players with their attributes
  def create_players(players = [])
    2.times do |i|
      @iteration = i

      assign_color_to_the_player

      ask_for_player_name

      create_piece_set_for_the_player

      players << { 'name' => player_name, 'piece_color' => piece_color, 'active_pieces' => piece_set }
    end
    players
  end
end
