require '/home/edgar/chess/lib/modules/user_prompt.rb'
require '/home/edgar/chess/lib/modules/helper.rb'

class PieceInput
  attr_accessor :player_pieces, :player_name

  include UserPrompt
  include Helper

  def initialize(player_pieces, player_name)
    @player_pieces = player_pieces
    @player_name = player_name
  end

  def select_a_piece_from(piece_positions)
    puts turn_player_prompt(player_name),
         select_piece_prompt(piece_positions)

    turn_piece = gets.chomp! until piece_positions.include?(turn_piece)

    locate_values_of(turn_piece, player_pieces)
  end

  def sort_turn_player_pieces(positions = [])
    player_pieces.each_value do |val|
      positions << val['position']
    end
    positions
  end

  def turn_piece
    piece_positions = sort_turn_player_pieces

    select_a_piece_from(piece_positions)
  end
end