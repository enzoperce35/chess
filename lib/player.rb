require_relative 'pieces.rb'
require_relative 'interface.rb'

class Player < Pieces
  attr_accessor :piece_color, :name, :active_pieces

  include ConsoleInterface

  def initialize(piece_color)
    @piece_color = piece_color
    @name = prompt_name(piece_color)
    @active_pieces = create_pieces(piece_color)
  end
end