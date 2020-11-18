# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

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

  def check_for_and_castle(start, finish)
    %i[king queen].each do |side|
      %i[white black].each do |color|
        if move_is_castle?(start, finish, color, side) && can_castle?(color, side)
          castle(color, side)
          return :castled
        end
      end
    end
  end

  def move_is_castle?(start, finish, color, side)
    finish_column = side == :king ? 6 : 2
    row = color == :white ? 0 : 7
    king = (color[0] + '_king').to_sym
    start == [4, row] && finish == [finish_column, row] && @playing_field[4][row] == king
  end

  def can_castle?(color, side)
    if color == :white
      !@white_king_moved &&
        !rook_moved?(color, side) &&
        no_castling_squares_in_check?(color, side) &&
        white_castling_squares_empty?(side)
    else
      !@black_king_moved &&
        !rook_moved?(color, side) &&
        no_castling_squares_in_check?(color, side) &&
        black_castling_squares_empty?(side)
    end
  end

  def rook_moved?(color, side)
    rook_moved = color.to_s + '_' + side.to_s + 'side_rook_moved'
    instance_variable_get("@#{rook_moved}")
  end

  def no_castling_squares_in_check?(color, side)
    attacking_color = color == :white ? :black : :white
    row = color == :white ? 0 : 7
    (4..6).each do |column|
      if side == :king
        return false if under_attack?([column, row], attacking_color)
      elsif under_attack?([column - 2, row], attacking_color)
        return false
      end
    end
    true
  end

  def white_castling_squares_empty?(side)
    if side == :king
      (5..6).each { |column| return false unless @playing_field[column][0].nil? }
    else
      (1..3).each { |column| return false unless @playing_field[column][0].nil? }
    end
    true
  end

  def black_castling_squares_empty?(side)
    if side == :king
      (5..6).each { |column| return false unless @playing_field[column][7].nil? }
    else
      (1..3).each { |column| return false unless @playing_field[column][7].nil? }
    end
    true
  end

  def castle(color, side)
    if color == :white
      @playing_field[4][0] = nil
      if side == :king
        @playing_field[5][0] = :w_rook
        @playing_field[6][0] = :w_king
        @playing_field[7][0] = nil
      else
        @playing_field[3][0] = :w_rook
        @playing_field[2][0] = :w_king
        @playing_field[0][0] = nil
      end
    else
      @playing_field[4][7] = nil
      if side == :king
        @playing_field[5][7] = :b_rook
        @playing_field[6][7] = :b_king
        @playing_field[7][7] = nil
      else
        @playing_field[3][7] = :b_rook
        @playing_field[2][7] = :b_king
        @playing_field[0][7] = nil
      end
    end
  end
end

# rubocop:enable Metrics/ModuleLength
