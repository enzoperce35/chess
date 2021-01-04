require './lib/chess.rb'
require './lib/board.rb'

describe Chess do
  subject(:chess) { described_class.new }

  before(:all) do
    @original_stdout = $stdout
    $stdout = File.open(File::NULL, 'w')
  end

  describe "#initialize" do
    it 'board' do
      expect(chess.board).to eq('test')
    end

    it 'player1' do
      expect(chess.player1).to be_nil
    end

    it 'player2' do
      expect(chess.player2).to be_nil
    end
  end
end