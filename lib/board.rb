require_relative 'module.rb'
require 'colorize'

class Board
  attr_accessor :squares
  include ChessParts

  def initialize
    @squares = nil
  end

  def set_squares(hash, black, white, count)
    return hash if count == 64

    index1,index2 = count.divmod(8)
    if count.between?(0,15)
      put_piece(hash, black.shift, index1 + 1, index2)
    elsif count.between?(48,63)
      put_piece(hash, white.shift, index1 + 1, index2)
    else
      put_piece(hash, "    ", index1 + 1, index2)
    end

    set_squares(hash, black, white, count += 1)
  end

  def put_piece(hash, square, index1, index2)
    alphabet = ALPHA[index2]
    numeric = (index1-9).abs

    piece =
      if numeric.odd?
        index2.odd? ? square : square.colorize(background: :cyan)
      else
        index2.odd? ? square.colorize(background: :cyan) : square
      end

    hash.store("square#{alphabet}#{numeric}", piece)
  end
end