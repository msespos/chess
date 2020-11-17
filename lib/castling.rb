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

  def white_castle(side)
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
  end

  def move_is_white_castle?(start, finish, side)
    finish_column = side == :king ? 6 : 2
    start == [4, 0] && finish == [finish_column, 0] && @playing_field[4][0] == :w_king
  end

  def white_can_castle?(side)
    !@white_king_moved &&
      !white_rook_moved?(side) &&
      no_white_castling_squares_in_check?(side) &&
      white_castling_squares_empty?(side)
  end

  def white_rook_moved?(side)
    rook_moved = 'white_' + side.to_s + 'side_rook_moved'
    instance_variable_get("@#{rook_moved}")
  end

  def no_white_castling_squares_in_check?(side)
    attacking_color = @current_player == :white ? :black : :white
    (4..6).each do |column|
      if side == :king
        return false if under_attack?([column, 0], attacking_color)
      elsif under_attack?([column - 2, 0], attacking_color)
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

  def black_castle(side)
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

  def move_is_black_castle?(start, finish, side)
    finish_column = side == :king ? 6 : 2
    start == [4, 7] && finish == [finish_column, 7] && @playing_field[4][7] == :b_king
  end

  def black_can_kingside_castle?
    !@black_king_moved &&
      !@black_kingside_rook_moved &&
      no_black_castling_squares_in_check?(:king) &&
      black_kingside_castling_squares_empty?
  end

  def black_can_queenside_castle?
    !@black_king_moved &&
      !@black_queenside_rook_moved &&
      no_black_castling_squares_in_check?(:queen) &&
      black_queenside_castling_squares_empty?
  end

  def no_black_castling_squares_in_check?(side)
    attacking_color = @current_player == :white ? :black : :white
    (4..6).each do |column|
      if side == :king
        return false if under_attack?([column, 7], attacking_color)
      elsif under_attack?([column - 2, 7], attacking_color)
        return false
      end
    end
    true
  end

  def black_kingside_castling_squares_empty?
    (5..6).each { |column| return false unless @playing_field[column][7].nil? }
    true
  end

  def black_queenside_castling_squares_empty?
    (1..3).each { |column| return false unless @playing_field[column][7].nil? }
    true
  end
end

# rubocop:enable Metrics/ModuleLength
