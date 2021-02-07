require_relative 'helper.rb'
require_relative 'possible_moves.rb'

class ConsoleInterface
  attr_accessor :player, :board

  include Helper

  def initialize(player = nil, board = nil)
    @player = player
    @board = board
  end

  #ask and get the player's name
  def prompt_name_interface(piece_color)
    puts "Who's Playing #{piece_color}?"

    gets.chomp!
  end

  def get_possible_moves(chosen_piece)
    new_move = PossibleMoves.new(chosen_piece, board)

    new_move.generate_possible_moves
  end

  #ask and the player's piece of choice
  def ask_for_piece
    name = player['name']
    player_pieces = get_turn_player_pieces(board)

    puts "#{name}'s turn\n\n".rjust(26),
         "Please select your chess piece. e.g. '#{player_pieces[0]}"

    answer = gets.chomp! until player_pieces.include?(answer)

    ans = locate_object_values(player, answer)

    get_possible_moves(ans)
  end

  def ask_for_move(piece)
    piece_name = piece['name']

    piece_position = piece['position']

    piece_moves = piece['moves']

    all_squares = board.squares.keys

    return "\n\n\nNo possible moves for '#{piece_name}-#{piece_position}'!\n"\
           "Please choose another piece" if piece_moves.length.zero?

    puts "\n\nPlease select a square to put your #{piece_name}"

    ans = gets.chomp! until all_squares.include?(ans)

    validate_answer(ans, piece)
  end

  def validate_answer(ans, piece)
    piece_position = piece['position']
    piece_moves = trim_capture_messages(piece['moves'])
    piece_name = piece['name']
    #trim_capture_messages(piece['moves'])

    if piece_moves.include?(ans)
      ans
    else
      puts "\n\ninvalid move '#{piece_position} to #{ans}'..., please choose an option below\n",
           "'p' => choose another piece",
           "'l' => get a list of '#{piece_name}-#{piece_position}' moves\n\n"
           option = gets.chomp! until ['p','l'].include?(option)
           implement_option(option, piece)
    end
  end

  def implement_option(option, piece)
    piece_position = piece['position']
    piece_moves = piece['moves']
    piece_name = piece['name']
    trimmed_piece_moves = trim_capture_messages(piece_moves)

    if option == 'p'
      "\n\nPlease re-select your piece\n\n"
    elsif option == 'l'
      puts "\n'#{piece_name}-#{piece_position}' valid moves:",
           piece_moves,
           "\n"
      move = gets.chomp! until trimmed_piece_moves.include?(move)
      move
    end
  end
end