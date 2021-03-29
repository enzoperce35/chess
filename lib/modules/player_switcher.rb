require '/home/edgar/chess/lib/modules/helper.rb'

module PlayerSwitcher

  include Helper

  def switch(chess_players)
    chess_players.each do |player|
      player['active_pieces'].values.map do |piece|
        piece_position = piece['position']

        coordinates = convert_to_board_coordinates(piece_position)

        coordinates = alter_board(*coordinates)

        piece_position = convert_to_piece_position(coordinates)

        piece['position'] = piece_position
      end
    end
  end
end