require '/home/edgar/chess/lib/modules/move_directions.rb'
require '/home/edgar/chess/lib/move/move_analyzer.rb'

class CheckAnalyzer < MoveAnalyzer
  attr_accessor :move_count, :blocker, :block_position

  include MoveDirections

  def no_threat?
    new_square_invalid? || !move_is_blocked?
  end

  def pawn_is_on_capture_position?
    direction == 'up-left' || direction == 'up-right'
  end

  def blocker_is_one_move_from_king?
    move_count == 1
  end

  def pawn_is_a_threat?
    blocker_is_one_move_from_king? && pawn_is_on_capture_position?
  end

  def blocker_is_a_knight?
    blocker == 'knight' && direction == 'knight_directions'
  end

  def knight_is_a_threat?
    move_is_blocked? && blocker_is_a_knight?
  end

  def rook_is_a_threat?
    cardinal_directions.include?(direction)
  end

  def bishop_is_a_threat?
    intercardinal_directions.include?(direction)
  end

  def queen_is_a_threat?
    all_directions.include?(direction)
  end

  def king_is_a_threat?
    blocker_is_one_move_from_king?
  end

  def another_square_is_not_possible?
    move_is_on_the_borders? || move_is_blocked?
  end

  def new_square_invalid?
    move_is_ally_blocked? || move_is_out_of_border?
  end
end