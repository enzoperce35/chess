require './lib/board.rb'

describe Board do

  subject(:board) { described_class.new }

  describe "#initialize" do
    it "squares" do
      expect(board.squares).to be_nil
    end
  end

  describe "#set_squares" do
    it 'creates the virtual squares of the chess_board' do
      white = Array.new(16) { " \u2654  " }
      black = Array.new(16) { " \u265A  " }

      expect(board.set_squares({}, white, black, 0)).to include("squareH7"=>" ♔  ")
    end
  end

  describe "#put_piece" do
    it 'puts chess pieces into board squares' do
      expect(board.put_piece({}, " \u265A ", 0, 0)).to eq("\e[0;39;46m ♚ \e[0m")
    end
  end
end