require './lib/board.rb'
require './module.rb'

describe Board do
  subject(:board) { described_class.new }


  describe "#initialize" do
    it "squares" do
      expect(board.squares).to include("squareB1"=>" ♞  ")
    end
  end

  describe "#set_squares" do
    it 'creates the virtual squares of the chess_board'
  end

  describe "#put_piece" do
    it 'draws a virtual chess board'
  end
end