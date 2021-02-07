require_relative 'pieces.rb'
require_relative 'interface.rb'

class Player
  attr_accessor :iteration, :player_a, :player_b, :piece_color

  #returns a set of chess pieces
  def get_piece_set
    Pieces.new(piece_color).create_piece_set
  end

  #returns the name of the player
  def ask_player_name
    #ConsoleInterface.new.prompt_name_interface(piece_color)
    iteration.zero? ? 'John' : 'Mark'  #not included
  end

  #returns the color of pieces to be created
  def assign_piece_color
    @piece_color = iteration.zero? ? 'white' : 'black'
  end

  #returns the player assigned with a hash that will contain player values
  def get_player
    iteration.zero? ? @player_a = {} : @player_b = {}
  end

  #returns an array of players with a hash of player values
  def create_players(players = [])
    2.times do |i|
      @iteration = i

      player = get_player

      color = assign_piece_color

      name = ask_player_name

      piece_set = get_piece_set

      players << { 'piece_color'=>color, 'name'=>name, 'active_pieces'=>piece_set }
    end
    players
  end
end