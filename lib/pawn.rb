# frozen_string_literal: true

# pawn class
class Pawn
  # determine if a standard path is legal for a pawn using the start, finish, playing field and color
  # an en passant path is handled in #en_passant_path? below
  def path?(start, finish, playing_field, color, en_passant_column)
    if on_starting_rank?(start, color)
      return true if two_squares_ahead_free?(start, finish, playing_field, color) ||
                     standard_conditions_met?(start, finish, playing_field, color)
    elsif standard_conditions_met?(start, finish, playing_field, color)
      return true
    elsif en_passant_conditions_met?(start, finish, playing_field, color, en_passant_column)
      return true
    end
    false
  end

  # used by #standard_path? to determine if a pawn is on the second rank
  # (starting position for white pawns)
  def on_starting_rank?(start, color)
    start[1] == if color == :white
                  1
                else
                  6
                end
  end

  # used by #standard_path? to determine if the two squares in front of a
  # starting position pawn are free
  def two_squares_ahead_free?(start, finish, playing_field, color)
    if color == :white
      white_two_squares?(start, finish, playing_field)
    else
      black_two_squares?(start, finish, playing_field)
    end
  end

  # used by two_squares_ahead_free? to determine if the two squares ahead
  # of a white pawn are free
  def white_two_squares?(start, finish, playing_field)
    finish[0] == start[0] && finish[1] == 3 &&
      playing_field[start[0]][2].nil? && playing_field[start[0]][3].nil?
  end

  # used by two_squares_ahead_free? to determine if the two squares ahead
  # of a black pawn are free
  def black_two_squares?(start, finish, playing_field)
    finish[0] == start[0] && finish[1] == 4 &&
      playing_field[start[0]][5].nil? && playing_field[start[0]][4].nil?
  end

  # used by #standard_path? to determine if the standard (not moving two spaces) conditions
  # are met for a pawn to make a move
  def standard_conditions_met?(start, finish, playing_field, color)
    one_square_ahead_free?(start, finish, playing_field, color) ||
      diagonal_capture?(start, finish, playing_field, color)
  end

  # used by #standard_conditions_met? to determine if the square in front of a
  # starting position pawn is free
  def one_square_ahead_free?(start, finish, playing_field, color)
    ahead_increment = color == :white ? 1 : - 1
    finish[0] == start[0] &&
      finish[1] == start[1] + ahead_increment &&
      playing_field[finish[0]][finish[1]].nil?
  end

  # used by #standard_conditions_met? to determine if a diagonal capture is possible
  def diagonal_capture?(start, finish, playing_field, color)
    diagonal_increment = color == :white ? 1 : -1
    (finish[0] == start[0] - diagonal_increment || finish[0] == start[0] + diagonal_increment) &&
      finish[1] == start[1] + diagonal_increment &&
      !square_empty?(finish, playing_field)
  end

  # used by #path? to check if en passant is possible
  def en_passant_conditions_met?(start, finish, playing_field, color, en_passant_column)
    return false unless on_en_passant_starting_rank?(start, color)

    en_passant_increment = color == :white ? 1 : -1
    en_passant_horizontal_shift_correct?(start, finish, en_passant_increment) &&
      en_passant_vertical_shift_correct?(start, finish, en_passant_increment) &&
      next_to_en_passant_column?(start, finish, en_passant_column, en_passant_increment) &&
      square_empty?(finish, playing_field)
  end

  # used by #en_passant_conditions_met? to determine if a pawn is on the rank required
  # to make an en passant capture
  def on_en_passant_starting_rank?(start, color)
    start[1] == if color == :white
                  4
                else
                  3
                end
  end

  # used by #en_passant_conditions_met? to check if the horizontal shift is correct
  def en_passant_horizontal_shift_correct?(start, finish, en_passant_increment)
    finish[0] == start[0] - en_passant_increment || finish[0] == start[0] + en_passant_increment
  end

  # used by #en_passant_conditions_met? to check if the vertical shift is correct
  def en_passant_vertical_shift_correct?(start, finish, en_passant_increment)
    finish[1] == start[1] + en_passant_increment
  end

  # used by #en_passant_conditions_met? to check if the pawn is next to the en passant column
  def next_to_en_passant_column?(start, finish, en_passant_column, en_passant_increment)
    en_passant_column == if finish[0] == start[0] - en_passant_increment
                           start[0] - en_passant_increment
                         else
                           start[0] + en_passant_increment
                         end
  end

  # used by multiple diagonal-check methods to verify that a square is empty
  def square_empty?(finish, playing_field)
    playing_field[finish[0]][finish[1]].nil?
  end
end
