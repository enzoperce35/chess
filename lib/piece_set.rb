require_relative './modules/helper.rb'
require 'colorize'

# creates the chess piece set
class PieceSet
  attr_accessor :piece_color, :piece_set

  include Helper

  def initialize(piece_color)
    @piece_color = piece_color
    @piece_set = {}
  end

 # store key and modified value pairs to '@piece_set'
  def keep(piece_name, piece_image, x_coordinate, y_coordinate)
    value = { 'name' => remove_suffix_to(piece_name),
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

  # returns an array of splitted piece name and piece suffix
  def split_piece_name_of_the(last_added_piece)
    last_added_piece.scan(/\d+|\D+/)
  end

  # add a number suffix to 'piece_name' which represents it's multitude
  def add_suffix_to(name)
    last_added_piece = piece_set.keys[-1]

    prev_name, suffix = split_piece_name_of_the(last_added_piece) unless last_added_piece.nil?

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

  # returns a hash of chess_pieces with it's modified values
  def create_piece_set
    lines = File.readlines('chess_pieces.csv')

    lines.each_with_index do |line, index|
      next if index.zero?

      values = line.split(',')

      modified_piece_values = modify_piece(*values)

      keep(*modified_piece_values)
    end
    piece_set
  end
end
