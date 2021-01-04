require './piece.rb'

describe Pieces do
  subject(:piece) { described_class.new }

  describe "#initialize" do
    it "white" do
      expect(piece.white).to be_a(Array)
    end

    it "black" do
      expect(piece.black).to be_a(Array)
    end
  end

  describe "#create_pieces" do
    it "creates the chess pieces in proper alignment" do
      sample_set = Array.new(16) { " \u265B  " }

      expect(piece).to receive(:insert_piece).with(any_args).exactly(16).times

      piece.create_pieces(sample_set)
    end
  end

  describe "#insert_piece" do
    it "inserts the chess piece into an array give a key/value pair" do
      sample_piece = [:knight, " ♞  "]

      expect(piece).to receive(:insert).with(" ♞  ", 0, -1, [])

      piece.insert_piece(sample_piece[0], sample_piece[1], [])
    end
  end





end