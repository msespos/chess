# frozen_string_literal: true

require_relative 'piece.rb'

# pawn class
class Pawn < Piece
  # determine if a path is legal for a pawn using the start, finish, playing field and color
  def path?(start, finish, playing_field, white_or_black)
    if white_or_black == :white
      white_pawn_path?(start, finish, playing_field)
    else
      black_pawn_path?(start, finish, playing_field)
    end
  end

  # determine if a path is legal for a white pawn
  def white_pawn_path?(start, finish, playing_field)
    if on_second_rank?(start)
      return true if two_squares_ahead_free?(start, finish, playing_field) ||
                     standard_conditions_met?(start, finish, playing_field)
    elsif standard_conditions_met?(start, finish, playing_field)
      return true
    end
    false
  end

  # used by #white_pawn_path? to determine if a pawn is on the second rank
  # (starting position for white pawns)
  def on_second_rank?(start)
    start[1] == 1
  end

  # used by #white_pawn_path? to determine if the two squares in front of a
  # starting position pawn are free
  def two_squares_ahead_free?(start, finish, playing_field)
    finish[0] == start[0] && finish[1] == 3 &&
      playing_field[start[0]][2].nil? && playing_field[start[0]][3].nil?
  end

  # used by #white_pawn_path to determine if the standard (not moving two spaces) conditions
  # are met for a pawn to make a move
  def standard_conditions_met?(start, finish, playing_field)
    one_square_ahead_free?(start, finish, playing_field) ||
      left_diagonal_capture?(start, finish, playing_field) ||
      right_diagonal_capture?(start, finish, playing_field)
  end

  # used by #standard_conditions_met? to determine if the square in front of a
  # starting position pawn is free
  def one_square_ahead_free?(start, finish, playing_field)
    finish[0] == start[0] && finish[1] == start[1] + 1 && playing_field[finish[0]][finish[1]].nil?
  end

  # used by #standard_conditions_met? to determine if a left diagonal capture is possible
  def left_diagonal_capture?(start, finish, playing_field)
    finish[0] == start[0].to_i - 1 && finish[1] == start[1] + 1 &&
      !playing_field[finish[0]][finish [1]].nil?
  end

  # used by #standard_conditions_met? to determine if a right diagonal capture is possible
  def right_diagonal_capture?(start, finish, playing_field)
    finish[0] == start[0] + 1 && finish[1] == start[1] + 1 &&
      !playing_field[finish[0]][finish [1]].nil?
  end

  # determine if a path is legal for a black pawn
  def black_pawn_path?(start, finish, playing_field) end
end
