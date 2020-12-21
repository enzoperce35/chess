require_relative 'board.rb'

class Chess
  attr_accessor :board

  def initialize
    @board = Board.new
  end

end