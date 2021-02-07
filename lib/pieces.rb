require_relative 'chess_parts.rb'
require_relative 'helper.rb'
require 'colorize'

class Pieces
  attr_accessor :piece_set, :line, :piece_name, :piece_image, :x_coordinate,
                :y_coordinate, :prev_piece_name, :piece_suffix, :piece_color

  include ChessParts
  include Helper

  def initialize(piece_color)
    @piece_set = {}
    @piece_color = piece_color
    @prev_piece_name = ''
  end

  #store key and modified value pairs to '@piece_set'
  def store_piece
    value = { 'name'=>piece_name[0..-2],
              'image'=>piece_image,
              'position'=>"#{x_coordinate}#{y_coordinate}",
              'moved?'=>false,
              'moves'=>[] }

    @piece_set.store("#{piece_name}", value)
  end

  #trim the new space attached to the x_coordinate
  def modify_x_coordinate
    x_coord = line[3]

    @x_coordinate = x_coord.chomp!
  end

  #alter the y_coordinate if '@piece_color' is black
  def modify_y_coordinate
    y_coord = line[2]

    y_coord_for_black_piece = (9 - y_coord.to_i).to_s

    @y_coordinate = piece_color =='black' ? y_coord_for_black_piece : y_coord
  end

  #returns a console compatible string formatted 'piece_image'
  def encode(image)
    image.gsub!('U+','\u')

    image.gsub(/\\u[\da-f]{4}/i) { |m| [m[-4..-1].to_i(16)].pack('U') }
  end

  #modifies a unicode formatted 'piece_image'; colorize if '@piece_color' is black
  def modify_piece_image
    piece_image = line[1]

    encoded_image = encode(piece_image)

    @piece_image = piece_color == 'black' ? colorize_piece(encoded_image) : encoded_image
  end

  #returns true if current and previous 'piece_name' is identical
  def same_as_previous_piece?
    prev_piece_name == piece_name
  end

  #returns the 'piece_name' with number suffix
  def add_suffix
    same_as_previous_piece? ? @piece_suffix += 1 : @piece_suffix = 1

    piece_name + piece_suffix.to_s
  end

  #add a number suffix to 'piece_name' which represents it's multitude
  def modify_piece_name
    @piece_name = line[0]

    piece_with_suffix = add_suffix

    @prev_piece_name = piece_name

    @piece_name = piece_with_suffix
  end

  #modify each fraction of the line from the csv file
  def modify_line
    modify_piece_name

    modify_piece_image

    modify_y_coordinate

    modify_x_coordinate
  end

  #splits a line from the csv file
  def split_line(line)
    @line = line.split(',')
  end

  #reads and accesses necessary values
  def read_csv_file
    File.readlines('chess_pieces.csv')
  end

  #returns a hash of chess_pieces with it's modified values
  def create_piece_set
    lines = read_csv_file

    lines.each_with_index do |line,index|
      next if index.zero?

      split_line(line)

      modify_line

      store_piece
    end
    piece_set
  end
end
