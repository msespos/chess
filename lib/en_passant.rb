# frozen_string_literal: true

# methods for implementing en passant
module EnPassant
  # check to see if a pawn has just moved two squares and in which column
  # if so, set @en_passant_column to that column
  def check_for_en_passant(start, finish)
    finish_piece = @playing_field[finish[0]][finish[1]]
    if finish_piece == :w_pawn && start[1] == 1 && finish[1] == 3
      @en_passant_column = start[0]
    elsif finish_piece == :b_pawn && start[1] == 6 && finish[1] == 4
      @en_passant_column = start[0]
    else
      @en_passant_column = nil
    end
  end
end
