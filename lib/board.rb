require_relative 'piece.rb'
require_relative 'module.rb'
require 'colorize'

class Board < Pieces
  attr_accessor :turn_count, :pieces, :top_pieces, :bottom_pieces
  include ChessParts

  def initialize
    @turn_count = 0
    @pieces = Pieces.new(turn_count)
    @top_pieces = pieces.on_top
    @bottom_pieces = pieces.on_bottom
  end

  def create_squares(hash = {}, sqr_ind = 0)
    return hash if sqr_ind == 64

    index1,index2 = sqr_ind.divmod(8)

    insert_to_hash(hash, sqr_ind, index1, index2)

    create_squares(hash, sqr_ind += 1)
  end

  def insert_to_hash(hash, square, ind1, ind2)
    case square
    when 0..15
      put_piece(hash, top_pieces.shift.colorize(color: :black), ind1 + 1, ind2)
    when 48..63
      put_piece(hash, bottom_pieces.shift.colorize(color: :white), ind1 + 1, ind2)
    else
      put_piece(hash, "    ", ind1 + 1, ind2)
    end
  end

  def put_piece(hash, piece, index1, index2)
    alphabet = ALPHA[index2]
    numeric = (index1-9).abs

    square = create_square(piece, numeric, index2)

    hash.store("square#{alphabet}#{numeric}", square)
  end

  def create_square(piece, numeric, index2)
     if numeric.odd?
        index2.odd? ? piece.colorize(background: :light_black) : piece.colorize(background: :light_cyan)
     else
        index2.odd? ? piece.colorize(background: :light_cyan) : piece.colorize(background: :light_black)
     end
  end

  def draw_board(squares = create_squares, str = '')
    squares.values.each_with_index do |sqr,ind|
      quotient, modulus = (ind + 1).divmod 8

      str = add_y_coordinate(str, quotient) if start_of_a_row(ind)

      str += sqr

      str += "\n" if end_of_a_row(modulus)
    end
    puts str + X_COORDINATES.colorize(color: :red)
  end

  def add_y_coordinate(string, numeric)
    string += "#{8 - numeric} ".colorize(color: :red)
  end

  def start_of_a_row(index)
    index % 8 == 0
  end

  def end_of_a_row(mod)
    mod.zero?
  end
end

x = Board.new
x.draw_board
#x.draw_board
