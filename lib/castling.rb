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

  def check_for_and_castle(start, finish)
    %i[king queen].each do |side|
      if move_is_castle?(start, finish, side) && can_castle?(side)
        castle(side)
        return :castled
      end
    end
  end

  def move_is_castle?(start, finish, side)
    finish_column = side == :king ? 6 : 2
    row = @current_player == :white ? 0 : 7
    king = (@current_player[0] + '_king').to_sym
    start == [4, row] && finish == [finish_column, row] && @playing_field[4][row] == king
  end

  def can_castle?(side)
    !king_moved? &&
      !rook_moved?(side) &&
      no_castling_squares_in_check?(side) &&
      castling_squares_empty?(side)
  end

  def king_moved?
    king_moved = @current_player.to_s + '_king_moved'
    instance_variable_get("@#{king_moved}")
  end

  def rook_moved?(side)
    rook_moved = @current_player.to_s + '_' + side.to_s + 'side_rook_moved'
    instance_variable_get("@#{rook_moved}")
  end

  def no_castling_squares_in_check?(side)
    attacking_color = @current_player == :white ? :black : :white
    row = @current_player == :white ? 0 : 7
    (4..6).each do |column|
      if side == :king
        return false if under_attack?([column, row], attacking_color)
      elsif under_attack?([column - 2, row], attacking_color)
        return false
      end
    end
    true
  end

  def castling_squares_empty?(side)
    bottom_of_range = side == :king ? 5 : 1
    top_of_range = side == :king ? 6 : 3
    row = @current_player == :white ? 0 : 7
    (bottom_of_range..top_of_range).each { |column| return false unless @playing_field[column][row].nil? }
    true
  end

  def castle(side)
    rook_column, king_column, empty_column = obtain_castling_columns(side)
    row = @current_player == :white ? 0 : 7
    @playing_field[4][row] = nil
    @playing_field[rook_column][row] = (@current_player[0] + '_rook').to_sym
    @playing_field[king_column][row] = (@current_player[0] + '_king').to_sym
    @playing_field[empty_column][row] = nil
  end

  def obtain_castling_columns(side)
    rook_column = side == :king ? 5 : 3
    king_column = side == :king ? 6 : 2
    empty_column = side == :king ? 7 : 0
    [rook_column, king_column, empty_column]
  end
end
