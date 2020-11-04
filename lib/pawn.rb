# frozen_string_literal: true

# pawn class
class Pawn
  # determine if a path is legal for a pawn using the start, finish, playing field and color
  def path?(start, finish, playing_field, color)
    if on_starting_rank?(start, color)
      return true if two_squares_ahead_free?(start, finish, playing_field, color) ||
                     standard_conditions_met?(start, finish, playing_field, color)
    elsif standard_conditions_met?(start, finish, playing_field, color)
      return true
    #elsif en_passant_possible?(start, finish, playing_field, color)
    #  return true
    end
    false
  end

  # used by #path? to determine if a pawn is on the second rank
  # (starting position for white pawns)
  def on_starting_rank?(start, color)
    start[1] == if color == :white
                  1
                else
                  6
                end
  end

  # used by #path? to determine if the two squares in front of a
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

  # used by #path? to determine if the standard (not moving two spaces) conditions
  # are met for a pawn to make a move
  def standard_conditions_met?(start, finish, playing_field, color)
    one_square_ahead_free?(start, finish, playing_field, color) ||
      left_diagonal_capture?(start, finish, playing_field, color) ||
      right_diagonal_capture?(start, finish, playing_field, color)
  end

  # used by #standard_conditions_met? to determine if the square in front of a
  # starting position pawn is free
  def one_square_ahead_free?(start, finish, playing_field, color)
    if color == :white
      white_one_square?(start, finish, playing_field)
    else
      black_one_square?(start, finish, playing_field)
    end
  end

  # used by one_square_ahead_free? to determine if the one square ahead
  # of a white pawn is free
  def white_one_square?(start, finish, playing_field)
    finish[0] == start[0] && finish[1] == start[1] + 1 && playing_field[finish[0]][finish[1]].nil?
  end

  # used by one_square_ahead_free? to determine if the one square ahead
  # of a black pawn is free
  def black_one_square?(start, finish, playing_field)
    finish[0] == start[0] && finish[1] == start[1] - 1 && playing_field[finish[0]][finish[1]].nil?
  end

  # used by #standard_conditions_met? to determine if a left diagonal capture is possible
  def left_diagonal_capture?(start, finish, playing_field, color, en_passant = false)
    if color == :white
      white_left_diagonal?(start, finish, playing_field, en_passant = false)
    else
      black_left_diagonal?(start, finish, playing_field, en_passant = false)
    end
  end

  def square_status_given_en_passant_status(en_passant, playing_field, finish)
    en_passant ? playing_field[finish[0]][finish[1]].nil? : !playing_field[finish[0]][finish[1]].nil?
  end

  def white_left_diagonal?(start, finish, playing_field, en_passant = false)
    finish[0] == start[0] - 1 && finish[1] == start[1] + 1 &&
      square_status_given_en_passant_status(en_passant, playing_field, finish)
  end

  def black_left_diagonal?(start, finish, playing_field, en_passant = false)
    finish[0] == start[0] + 1 && finish[1] == start[1] - 1 &&
      square_status_given_en_passant_status(en_passant, playing_field, finish)
  end

  # used by #standard_conditions_met? to determine if a right diagonal capture is possible
  def right_diagonal_capture?(start, finish, playing_field, color, en_passant = false)
    if color == :white
      white_right_diagonal?(start, finish, playing_field, en_passant = false)
    else
      black_right_diagonal?(start, finish, playing_field, en_passant = false)
    end
  end

  def white_right_diagonal?(start, finish, playing_field, en_passant = false)
    finish[0] == start[0] + 1 && finish[1] == start[1] + 1 &&
      square_status_given_en_passant_status(en_passant, playing_field, finish)
  end

  def black_right_diagonal?(start, finish, playing_field, en_passant = false)
    finish[0] == start[0] - 1 && finish[1] == start[1] - 1 &&
     square_status_given_en_passant_status(en_passant, playing_field, finish)
  end

  # used by #en_passant? to determine if a pawn is on the rank required
  # to make an en passant capture
  def on_en_passant_starting_rank?(start, color)
    start[1] == if color == :white
                  4
                else
                  3
                end
  end
end
