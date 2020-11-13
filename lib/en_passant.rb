# frozen_string_literal: true

# methods for implementing en passant
module EnPassant
  # check to see if a pawn has just moved two squares and in which column
  # if so, set @en_passant_column to that column
  def check_for_en_passant(start, finish)
    finish_piece = @playing_field[finish[0]][finish[1]]
    @en_passant_column = if en_passant_white(start, finish, finish_piece) ||
                            en_passant_black(start, finish, finish_piece)
                           start[0]
                         end
  end

  def en_passant_white(start, finish, finish_piece)
    finish_piece == :w_pawn && start[1] == 1 && finish[1] == 3
  end

  def en_passant_black(start, finish, finish_piece)
    finish_piece == :b_pawn && start[1] == 6 && finish[1] == 4
  end

  def meets_en_passant_conditions?(start, finish)
    a_pawn?(start) && finish_on_en_passant_column?(finish) && start_next_to_en_passant_column?(start)
  end

  def a_pawn?(start)
    @playing_field[start[0]][start[1]] == :w_pawn || @playing_field[start[0]][start[1]] == :b_pawn
  end

  def finish_on_en_passant_column?(finish)
    finish[0] == @en_passant_column
  end

  def start_next_to_en_passant_column?(start)
    start[0] == @en_passant_column - 1 || start[0] == @en_passant_column + 1
  end
end
