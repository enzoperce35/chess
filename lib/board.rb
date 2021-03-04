require_relative 'helper.rb'

# creates and displays the chess board
class ChessBoard
  attr_reader :chess_players

  include Helper

  def initialize(chess_players)
    @chess_players = chess_players
  end

  def with_same?(row_index, col_index)
    row_index.even? && col_index.even? || row_index.odd? && col_index.odd?
  end

  def color(chess_board)
    chess_board.values.map do |square|
      sqr, *parity = square.values

      color = with_same?(*parity) ? 'blue' : 'light_black'

      square['square'] = put_background_color(sqr, color)
    end

    chess_board
  end

  def put_chess_pieces_into(chess_board)
    chess_players.each do |pieces|
      pieces['active_pieces'].values.map do |piece|
        _piece, image, position = piece.values

        new_square = " #{image}  "

        chess_board[position]['square'].gsub!('    ',  new_square)
      end
    end

    color(chess_board)
  end

  def create_board_coordinates(sqr_ind)
    quotient, remainder = sqr_ind.divmod(8)

    [row_index = customize_row_index(remainder),

     col_index = 8 - quotient]
  end

  def build_chess_board(board = {})
    64.times do |i|
      coordinates = create_board_coordinates(i)

      position = convert_to_piece_position(coordinates)

      board.store(position, { 'square' => '    ', 'col_ind' => coordinates.pop, 'row_ind' => coordinates.pop })
    end
    board
  end

  def put_chess_pieces
    chess_board = build_chess_board

    put_chess_pieces_into(chess_board)
  end
end
