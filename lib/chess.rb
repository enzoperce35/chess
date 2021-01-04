require_relative 'board.rb'
require_relative 'interface.rb'

class Chess
  attr_accessor :board, :player1, :player2, :interface

  def initialize
    @interface = ConsoleInterface.new
    @board = 'test'
    @player1 = interface.prompt_name(1)
    @player2 = interface.prompt_name(2)
  end
end