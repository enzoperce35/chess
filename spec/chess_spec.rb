require './lib/chess.rb'
require './lib/board.rb'

describe Chess do
  subject(:chess) { described_class.new }

  describe "#initialize" do
    it 'board' do
      chess.board.squares = 'test'
      expect(chess.board).to have_attributes(:squares => 'test')
    end
  end
end 