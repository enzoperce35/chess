module Prompts

  def choose_valid_move_prompt(piece_name, piece_position)
    "\n'#{piece_name}-#{piece_position}' valid moves:"
  end

  def re_select_piece_prompt
    "\n\nPlease re-select your piece\n\n"
  end

  def invalid_move_prompt(piece_position, selected_square, piece_name)
    "\n\ninvalid move '#{piece_position} to #{selected_square}'...,\n"\
    "Please retype a valid move or choose an option below\n\n"\
    "'p' => choose another piece\n"\
    "'l' => get a list of '#{piece_name}-#{piece_position}' moves\n\n"
  end

  def select_square_prompt(piece_name)
      "\n\nPlease select a square to put your #{piece_name}"
  end

  def no_move_prompt(piece_name, piece_position)
    "\n\n\nNo possible moves for '#{piece_name}-#{piece_position}'!\n"\
    "Please choose another piece"
  end

  def select_piece_prompt(piece_positions)
    "Please select your chess piece. e.g. '#{piece_positions[0]}"
  end

  def turn_player_prompt(player_name)
    "#{player_name}'s turn\n\n".rjust(26)
  end

  def player_name_prompt(piece_color)
    "Who's Playing #{piece_color}?"
  end
end