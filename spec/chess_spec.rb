require './lib/board.rb'

describe Board do
  subject(:board) { described_class.new }

  describe "#initialize" do
    it "squares" do
      expect(board.squares).to include("squareA6"=>"\e[0;39;46m    \e[0m")
    end
  end

  describe "#create_squares" do
    it 'creates the vitual squares of the chess_board' do
      expect(board.create_squares).to include("squareG8"=>"\e[0;39;46m    \e[0m")
    end
  end
end