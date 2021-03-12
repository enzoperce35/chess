module MoveDirections
  def pawn_moves
    ['up', 'double-up', 'up-left', 'up-right']
  end

  def intercardinal_directions
    ['up-right', 'up-left', 'down-left', 'down-right']
  end

  def cardinal_directions
    ['up', 'down', 'left', 'right']
  end

  def all_directions
    cardinal_directions + intercardinal_directions
  end
end