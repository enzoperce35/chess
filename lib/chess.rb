require_relative 'pieces.rb'
require_relative 'interface.rb'
require_relative 'chess_parts.rb'

class Chess
  attr_accessor :console, :pieces, :player1, :player2

  include ChessParts

  def initialize
    @console = ConsoleInterface.new
    @pieces = Pieces.new
    @player1 = create_player('white')
    @player2 = create_player('black')
  end

  def create_player(piece, hash = Hash.new)
    { 'player'=> console.prompt_name(piece), 'active_pieces'=> pieces.create_pieces(piece) }
  end
end