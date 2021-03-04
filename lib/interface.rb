require_relative 'helper.rb'
require_relative 'possible_moves.rb'
require_relative 'user_prompt.rb'

class Interface
  attr_accessor :chess_board, :turn_player, :opposing_player, :player_pieces, :player_name,
                :piece_name, :piece_position, :possible_moves, :selected_square, :valid_squares

  include Helper
  #include UserPrompt

  def initialize(chess_board, turn_player, opposing_player)
    @chess_board = chess_board
    @turn_player = turn_player
    @player_pieces = turn_player['active_pieces']
    @player_name = turn_player['name']
    @opposing_player = opposing_player
  end


end