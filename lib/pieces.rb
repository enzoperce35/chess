require_relative 'chess_parts.rb'

class Pieces
  include ChessParts

  def create_pieces(set = Hash.new)
    PIECE_SET.each do |piece,attr|
      image, row, count, alpha = attr.values

      store_piece(piece, image, row, count, alpha, set)
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
