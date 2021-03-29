require '/home/edgar/chess/lib/modules/user_prompt.rb'
require '/home/edgar/chess/lib/modules/helper.rb'

# sets the square position the selected piece will move to
class MoveInput
  attr_accessor :chess_board, :piece_moves, :piece_name, :piece_position,
                :new_square, :valid_squares

  include UserPrompt
  include Helper

  def initialize(chess_board, piece_moves, piece_name, piece_position)
    @chess_board = chess_board
    @piece_moves = piece_moves
    @piece_name = piece_name
    @piece_position = piece_position
  end

  def move_is?(special_move)
    piece_moves.each do |move|
      if move.include?(new_square)
        return move.include?(special_move)

        break
      end
    end
  end

  def is_castling?
    move_is?('castling')
  end

  def is_en_passant?
    move_is?('en passant')
  end

  def provide_user_the_valid_squares_list
    puts choose_valid_move_prompt(piece_name, piece_position),
         piece_moves,
         " \n"

    square = gets.chomp! until valid_squares.include?(square)

    @new_square = square

    new_square
  end

  def let_user_choose_another_piece
    puts re_select_piece_prompt

    nil
  end

  def implement(option)
    case option
    when 'p'
      let_user_choose_another_piece
    when 'l'
      provide_user_the_valid_squares_list
    else
      option
    end
  end

  def create_options
    piece_and_list_option = ['p','l']

    valid_squares + piece_and_list_option
  end

  def choose_an_option
    options = create_options

    puts invalid_move_prompt(piece_position, new_square, piece_name)

    option = gets.chomp! until options.include?(option)

    implement(option)
  end

  def square_is_valid?
    @valid_squares = piece_moves.map { |move| move = trim_capture_message(move) }

    valid_squares.include?(new_square)
  end

  def chess_squares
    chess_board.keys
  end

  def ask_user_a_new_square
    puts select_square_prompt(piece_name)

    square = gets.chomp! until chess_squares.include?(square)

    @new_square = square

    square_is_valid? ? new_square : choose_an_option
  end

  def tell_user_piece_has_no_valid_move
    no_move_prompt(piece_name, piece_position)
  end

  def new_board_square
    ask_user_a_new_square
  end
end
