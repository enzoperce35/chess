require './lib/board.rb'

describe Board do

  subject(:board) { described_class.new }

  describe "#draw_board" do
    it 'displays the status of the chess board' do
      expect(board).to receive(:start_of_a_row).with(any_args).exactly(64).times
      board.draw_board
    end
  end

  describe "#set_squares" do
    it "creates a hash of the chess board's squares" do
      expect(board).to receive(:set_squares)
      board.set_squares
    end
  end

  describe "#put_piece" do
    it 'puts chess pieces into board squares' do
      expect(board.put_piece({}, " \u265A ", 0, 0)).to eq("\e[0;39;106m ♚ \e[0m")
    end
  end


end