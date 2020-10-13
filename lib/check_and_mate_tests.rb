# frozen_string_literal: true

# methods for testing for check and checkmate
module CheckAndMateTests
  def find_king
    current_king = @current_player[0] + '_king'
    current_king_square = []
    @playing_field.each_with_index do |row, row_index|
      row.each_index do |column_index|
        if @playing_field[row_index][column_index] == current_king.to_sym
          current_king_square = [row_index, column_index]
        end
      end
    end
    current_king_square
  end

  #   call the king square finish
  #   for each square on the board
  #     call it start
  #     if valid_move?(start, finish)
  #       return true (king is in check)
  #     end
  #   end
  #   false (king is not in check)
  # end
end
