require_relative 'helper.rb'
require 'colorize'

# creates the chess pieces
class ChessPieces
  attr_accessor :piece_color, :piece_set

  include Helper

  def initialize
    @piece_set = {}
  end

  ## returns an array of altered board coordinates
  #def alter_board_coordinate(board_coordinate)
  #  x_coord, y_coord = board_coordinate
#
  #  x_coord = (8 - x_coord).abs
#
  #  y_coord = (9 - y_coord).abs
#
  #  [x_coord, y_coord]
  #end
#
  #def alter_piece_positions_of(chess_players)
  #  chess_players.each do |player_pieces|
  #    player_pieces['active_pieces'].values.map do |value|
  #      piece_position = value['position']
#
  #      board_coordinate = convert_to_board_coordinates(piece_position)
#
  #      altered_board_coordinate = alter_board_coordinate(board_coordinate)
#
  #      altered_piece_position = convert_to_piece_position(altered_board_coordinate)
#
  #      value['position'] = altered_piece_position
  #    end
  #  end
  #  chess_players
  #end

  # store key and modified value pairs to '@piece_set'
  def keep(piece_name, piece_image, x_coordinate, y_coordinate)
    value = { 'name' => remove_piece_name_suffix(piece_name),
              'image' => piece_image,
              'position' => "#{y_coordinate}#{x_coordinate}",
              'color' => piece_color,
              'moved?' => false,
              'moves' => [] }

    @piece_set.store(piece_name, value)
  end

  # alter the y_coordinate if '@piece_color' is white
  def alter_white_piece(y_coord)
    y_coord_for_white_piece = (9 - y_coord.to_i).to_s

    piece_color == 'white' ? y_coord_for_white_piece : y_coord
  end

  # modifies a unicode formatted 'piece_image'; colorize if '@piece_color' is black
  def encode_unicode(image)
    encoded_image = encode(image)

    piece_color == 'black' ? put_colour_to(encoded_image, piece_color) : encoded_image
  end

  # add a number suffix to 'piece_name' which represents it's multitude
  def add_suffix_to(name)
    prev_name = piece_set.keys[-1]

    prev_name, suffix = prev_name.scan(/\d+|\D+/) unless prev_name.nil?

    if name == prev_name
      name += (suffix.to_i + 1).to_s
    else
      name += '1'
    end
  end

  # modify each fraction of the line from the csv file
  def modify_piece(name, image, y_coord, x_coord)
    [piece_name = add_suffix_to(name),

     piece_image = encode_unicode(image),

     y_coordinate = alter_white_piece(y_coord),

     x_coordinate = x_coord.chomp!]
  end

  # splits a line from the csv file
  def split_csv(line)
    line.split(',')
  end

  # returns a hash of chess_pieces with it's modified values
  def create_piece_set_for(piece_color)
    @piece_color = piece_color

    lines = File.readlines('chess_pieces.csv')

    lines.each_with_index do |line, index|
      next if index.zero?

      values = split_csv(line)

      modified_piece_values = modify_piece(*values)

      keep(*modified_piece_values)
    end
    piece_set
  end
end
