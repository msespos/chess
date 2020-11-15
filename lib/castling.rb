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

  def white_kingside_castle
    @playing_field[4][0] = nil
    @playing_field[5][0] = :w_rook
    @playing_field[6][0] = :w_king
    @playing_field[7][0] = nil
  end

  def move_is_white_kingside_castle?(start, finish)
    start == [4, 0] && finish == [6, 0] && @playing_field[4][0] == :w_king
  end

  def white_can_kingside_castle?
    !@white_king_moved &&
      !@white_kingside_rook_moved &&
      no_white_kingside_castling_squares_in_check? &&
      white_kingside_castling_squares_empty?
  end

  def no_white_kingside_castling_squares_in_check?
    attacking_color = @current_player == :white ? :black : :white
    (4..6).each do |column|
      return false if under_attack?([column, 0], attacking_color)
    end
    true
  end

  def white_kingside_castling_squares_empty?
    (5..6).each { |column| return false unless @playing_field[column][0].nil? }
    true
  end
end
