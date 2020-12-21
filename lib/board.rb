require_relative 'module.rb'

class Board
  attr_accessor :squares
  include ChessParts

  def initialize
    @squares = create_squares
  end

  def create_squares(square_hash = {}, num = ('1'..'8').to_a, alpha = ('A'..'H').to_a)
    return square_hash if num.length < 1

    number = num.pop
    8.times do |i|
      color = i.odd? ? BLACK : CYAN

      square_hash.store("square#{alpha[i]}#{number}", color)
    end

    create_squares(square_hash, num)
  end

  def draw_board
    'r'
  end
end
