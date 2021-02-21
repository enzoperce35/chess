require_relative 'helper.rb'
require_relative 'moves.rb'
require_relative 'prompt.rb'

class ConsoleInterface
  attr_accessor :turn_player, :player_name, :player_pieces, :board, :piece_positions,
                :selected_piece, :piece_name, :piece_position, :piece_moves,
                :selected_square, :valid_moves, :chosen_option

  include Helper
  include Prompts

  def initialize(turn_player = nil, board = nil)
    @turn_player = turn_player
    @board = board
  end

  def choose_valid_move
    puts choose_valid_move_prompt(piece_name, piece_position),
         piece_moves,
         add_new_line

    valid_move = gets.chomp! until valid_moves.include?(valid_move)

    valid_move
  end

  def implement_option
    case chosen_option
    when 'p'
      re_select_piece_prompt
    when 'l'
      choose_valid_move
    else
      chosen_option
    end
  end

  def create_invalid_move_options
    piece_and_list_options = ['p','l']

    valid_moves + piece_and_list_options
  end

  def choose_option_for_invalid_move
    options = create_invalid_move_options

    puts invalid_move_prompt(piece_position, selected_square, piece_name)

    @chosen_option = gets.chomp! until options.include?(chosen_option)

    implement_option
  end

  def gather_valid_moves(valid_moves = [])
    piece_moves.each { |move| valid_moves << trim_capture_message(move) }

    valid_moves
  end

  def move_is_valid?
    @valid_moves = gather_valid_moves

    valid_moves.include?(selected_square)
  end

  def implement_move
    move_is_valid? ? selected_square : choose_option_for_invalid_move
  end




  def selected_square_is_valid?
    board_squares = board.squares_hash.keys

    board_squares.include?(selected_square)
  end

  def select_a_move
    puts select_square_prompt(piece_name)

    @selected_square = gets.chomp! until selected_square_is_valid?

    implement_move
  end

  def no_possible_move?
    @piece_moves = selected_piece['moves']

    piece_moves.length.zero?
  end


  def ask_for_move
    @piece_name = selected_piece['name']

    @piece_position = selected_piece['position']

    no_possible_move? ? no_move_prompt(piece_name, piece_position) : select_a_move
  end

  # reset the moves of @selected_piece to none
  def empty_selected_piece_possible_moves
    @selected_piece['moves'] = []
  end

  # populate 'moves' attribute of @selected_piece with it's possible moves
  def gather_possible_moves_for_the_selected_piece
    empty_selected_piece_possible_moves

    @selected_piece = Moves.new(selected_piece, board).generate_possible_moves
  end

  # locate values of @selected_piece in @player_pieces; assign it as a new value for @selected_piece
  def locate_values_of_selected_piece(piece_values = nil)
     player_pieces.each do |piece, attributes|
       piece_position = attributes['position']

       piece_values = player_pieces[piece]

       break if piece_position == selected_piece
    end
    @selected_piece = piece_values
  end

  # prompt the user to select an item from @piece_positions array; assign to @selected_piece
  def select_a_piece_from_gathered_pieces_position
    @player_name = turn_player['name']

    puts turn_player_prompt(player_name),
         select_piece_prompt(piece_positions)

    @selected_piece = gets.chomp! until piece_positions.include?(selected_piece)
  end

  # populate an array with turn player's pieces positions; assign the array to @piece_positions
  def gather_turn_player_pieces_position(arr = [])
    @player_pieces = turn_player['active_pieces']

    player_pieces.each_value do |val|
      arr << val['position']
    end
    @piece_positions = arr
  end

  # returns a user selected piece attributes
  def ask_for_piece
    gather_turn_player_pieces_position

    select_a_piece_from_gathered_pieces_position

    locate_values_of_selected_piece

    gather_possible_moves_for_the_selected_piece
  end

  #ask and get the player's name
  def ask_player_name_for(piece_color)
    puts player_name_prompt(piece_color)

    gets.chomp!
  end
end