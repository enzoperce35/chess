require_relative 'move_maker.rb'
require_relative './user_inputs/piece_input.rb'
require_relative './user_inputs/move_input.rb'

class Move < MoveMaker
  attr_accessor :turn_piece, :piece_moves, :piece_move, :turn_move, :pieces

  def initialize(chess_players, chess_board)
    @chess_players = chess_players
    @chess_board = chess_board
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

  def no_move_possible?
    piece_moves.length.zero?
  end

  def collect_valid_turn_piece_moves
    @piece_moves = make_piece_moves
  end

  def ask_user_for_a_piece_to_move
    @turn_piece = PieceInput.new(player_pieces, player_name).turn_piece
  end

  def make_a_move
    ask_user_for_a_piece_to_move

    collect_valid_turn_piece_moves

    if no_move_possible?
      puts no_move_prompt(piece_name, piece_position)

      return nil
    end

    ask_user_for_a_square_to_put_turn_piece

    if user_wants_to_choose_other_piece?
      return nil
    end

    compile_move_attributes
  end
end