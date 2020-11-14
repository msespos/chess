# frozen_string_literal: true

# methods for implementing en passant
module EnPassant
  # used by #make_move_when_not_invalid to determine if and where en passant is possible
  # check to see if a pawn has just moved two squares and in which column
  # if so, set @en_passant_column to that column
  def update_en_passant_column(start, finish)
    finish_piece = @playing_field[finish[0]][finish[1]]
    @en_passant_column = if en_passant_white(start, finish, finish_piece) ||
                            en_passant_black(start, finish, finish_piece)
                           start[0]
                         end
  end

  # used by #update_en_passant_column to check for a white pawn moving on the correct ranks
  def en_passant_white(start, finish, finish_piece)
    finish_piece == :w_pawn && start[1] == 1 && finish[1] == 3
  end

  # used by #update_en_passant_column to check for a white pawn moving on the correct ranks
  def en_passant_black(start, finish, finish_piece)
    finish_piece == :b_pawn && start[1] == 6 && finish[1] == 4
  end

  # used by #reassign_squares to verify the conditions for moving en passant
  def meets_en_passant_conditions?(start, finish)
    a_pawn?(start) && finish_on_en_passant_column?(finish) && start_next_to_en_passant_column?(start)
  end

  # used by #meets_en_passant_conditions? to check if the piece is a pawn or not
  def a_pawn?(start)
    @playing_field[start[0]][start[1]] == :w_pawn || @playing_field[start[0]][start[1]] == :b_pawn
  end

  # used by #meets_en_passant_conditions? to check if the move finishes on the current en passant column
  def finish_on_en_passant_column?(finish)
    finish[0] == @en_passant_column
  end

  # used by #meets_en_passant_conditions? to check if the move starts next to the current en passant column
  def start_next_to_en_passant_column?(start)
    start[0] == @en_passant_column - 1 || start[0] == @en_passant_column + 1
  end
end
