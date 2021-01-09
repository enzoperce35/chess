require_relative 'chess_parts.rb'

class Pieces
  attr_accessor :default_piece_set
  include ChessParts

  def create_pieces(piece, set = Hash.new)
    piece_set = piece == 'white' ? WHITE_PIECE_SET : BLACK_PIECE_SET

    piece_set.each do |key,val|
      image, row, count, alpha = val.values

      store_piece(key, image, row, count, alpha, set)
    end
    set
  end

  def store_piece(piece, image, row, iteration, alpha, set)
    iteration.times do |i|
      position = alpha.shift

      set["#{piece}#{i+1}"] = { 'image'=>image, 'position'=>"#{position}#{row}", 'moves'=>[] }
    end
  end
end
