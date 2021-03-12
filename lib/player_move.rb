require_relative './modules/helper.rb'
require_relative './modules/user_prompt.rb'
require_relative 'possible_moves.rb'

# processes user input chess moves
class PlayerMove
  attr_accessor :chess_board, :turn_player, :opposing_player, :player_pieces, :player_name,
                :chosen_piece, :piece_position, :piece_name, :possible_moves, :valid_moves

  include Helper
  include UserPrompt

  def initialize(chess_board, turn_player, opposing_player)
    @chess_board = chess_board
    @turn_player = turn_player
    @opposing_player = opposing_player
    @player_pieces = turn_player['active_pieces']
    @player_name = turn_player['name']
  end

  # prompts the user to type the valid move from the valid moves list
  def choose_a_valid_move
    puts choose_valid_move_prompt(piece_name, piece_position),
         possible_moves,
         " \n"

    valid_move = gets.chomp! until valid_moves.include?(valid_move)

    valid_move
  end

  def implement(option)
    case option
    when 'p'
      puts re_select_piece_prompt
    when 'l'
      choose_a_valid_move
    else
      option
    end
  end

  def create_invalid_move_options
    piece_and_list_option = ['p','l']

    valid_moves + piece_and_list_option
  end

  def choose_option_for_the_invalid(chess_move)
    options = create_invalid_move_options

    puts invalid_move_prompt(piece_position, chess_move, piece_name)

    option = gets.chomp! until options.include?(option)

    implement(option)
  end

  def move_is_a_valid?(chess_move)
    @valid_moves = possible_moves.map { |move| move = trim_capture_message(move) }

    valid_moves.include?(chess_move)
  end

  # returns a valid board position as a chess move
  def make_a_move
    puts select_square_prompt(piece_name)

    chess_move = gets.chomp! until chess_board.keys.include?(chess_move)

    move_is_a_valid?(chess_move) ? chess_move : choose_option_for_the_invalid(chess_move)
  end

  def no_possible_move?
    moves = PossibleMoves.new(chosen_piece, chess_board, turn_player, opposing_player)

    p @possible_moves = moves.generate_possible_moves

    possible_moves.length.zero?
  end

  # returns a valid move or an invalid phrase
  def chess_square_to_put(piece)
    @chosen_piece = locate_values_of(piece, player_pieces)

    @piece_name = chosen_piece['name']

    @piece_position = chosen_piece['position']

    no_possible_move? ? no_move_prompt(piece_name, piece_position) : make_a_move
  end

  # prompt the user to select an item from piece_positions arra
  def choose_a_piece_from(piece_positions)
    puts turn_player_prompt(player_name),
         select_piece_prompt(piece_positions)

    chosen_piece = gets.chomp! until piece_positions.include?(chosen_piece)

    chosen_piece
  end

  # returns an array of piece positions
  def sort_turn_player_pieces(positions = [])
    player_pieces.each_value do |val|
      positions << val['position']
    end
    positions
  end

  # returns a piece_position
  def chess_piece_to_move
    piece_positions = sort_turn_player_pieces

    choose_a_piece_from(piece_positions)
  end
end