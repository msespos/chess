# frozen_string_literal: true

# methods for implementing castling
module Castling
  CASTLING_START_SQUARES = { white_king: [4, 0],
                             white_kingside_rook: [7, 0],
                             white_queenside_rook: [0, 0],
                             black_king: [4, 7],
                             black_kingside_rook: [7, 7],
                             black_queenside_rook: [0, 7] }.freeze

  def update_castling_piece_states(point_in_game, start_square = nil)
    CASTLING_START_SQUARES.each do |piece, square|
      piece_moved = piece.to_s + '_moved'
      if point_in_game == :initial
        instance_variable_set("@#{piece_moved}", false)
      elsif start_square == square
        instance_variable_set("@#{piece_moved}", true)
      end
    end
  end
end
