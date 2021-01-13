require_relative 'chess_parts.rb'
require 'colorize'

class Pieces
  include ChessParts

  #create each players' chess pieces with their attributes in a hash
  def create_pieces(piece_color, set = Hash.new)
    PIECE_SET.each do |piece,attr|
      image, row, count, alpha = attr.values

      if piece_color == 'black'
        row = (9 - row)

        image = colorize_piece(image)
      end
    store_piece(piece, image, row, count, alpha, set)
    end
    set
  end

  def store_piece(piece, image, row, iteration, alpha, set)
    iteration.times do |i|
      position = alpha[i]

      set["#{piece}#{i+1}"] = { 'image'=>image, 'position'=>"#{position}#{row}", 'moves'=>[] }
    end
  end

  def colorize_piece(image)
    image.colorize(color: :black)
  end
end
