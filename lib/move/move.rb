require_relative 'move_maker.rb'
require_relative './user_inputs/piece_input.rb'
require_relative './user_inputs/move_input.rb'

# returns the chess move
class Move < MoveMaker
  attr_accessor :turn_piece, :piece_move, :turn_move, :pieces

  def initialize(chess_players, chess_board)
    @chess_players = chess_players
    @chess_board = chess_board
    @piece_moves = []
  end

  def compile_move_attributes
    { 'piece' => turn_piece,
      'move' => piece_move,
      'castling' => turn_move.is_castling?,
      'en_passant' => turn_move.is_en_passant? }
  end

  def user_wants_to_choose_other_piece?
    piece_move.nil?
  end

  def ask_user_for_a_square_to_put_turn_piece
    @turn_move = MoveInput.new(chess_board, piece_moves, piece_name, piece_position)

    @piece_move = turn_move.new_board_square
  end

  def selected_piece_has_no_move?
    piece_moves.length.zero?
  end

  def no_move
    puts no_move_prompt(piece_name, piece_position)

    nil
  end

  def collect_selected_piece_moves
    @piece_moves = make_piece_moves
  end

  def ask_user_to_select_piece
    @turn_piece = PieceInput.new(player_pieces, player_name).turn_piece
  end

  def set_the_chess_piece_to_move
    ask_user_to_select_piece

    collect_selected_piece_moves
  end

  def make_a_move
    set_the_chess_piece_to_move

    return no_move if selected_piece_has_no_move?

    ask_user_for_a_square_to_put_turn_piece

    return nil if user_wants_to_choose_other_piece?

    compile_move_attributes
  end
end
