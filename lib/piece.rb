require_relative 'module.rb'

class Pieces
  attr_accessor :turn_count, :default_set
  include ChessParts

  def initialize(turn_count)
    @turn_count = turn_count
    @default_set = create_pieces(PIECE_SET)
  end

  def create_pieces(pieces, set = Array.new)
    return set if pieces.length < 1

    piece = pieces.shift

    insert_piece(piece[0], piece[1], set)

    create_pieces(pieces, set)
  end

  def insert_piece(piece, image, set)
    case piece
    when :rook, :knight, :bishop
      insert(image, 0, -1, set)
    when :queen, :king
      set.insert(3, image)
    when :pawn
      8.times { set.insert(0, image) }
    end
  end

  def insert(piece, left, right, set)
    2.times do |x|
      set.insert(x.zero? ? left : right, piece)
    end
  end

  def on_top
    set = default_set.each_slice(8).to_a

    set[0], set[1] = set[1], set[0]

    set.flatten!
  end

  def on_bottom
    default_set
  end
end