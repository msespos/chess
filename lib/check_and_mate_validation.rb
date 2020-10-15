# frozen_string_literal: true

# methods for testing for check and checkmate
module CheckAndMateTests
  def in_check?
    current_king_square = find_king
    under_attack?(current_king_square)
  end

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

  def under_attack?(position)
    finish = [position[0], position[1]]
    @playing_field.each_with_index do |row, row_index|
      row.each_index do |column_index|
        start = [row_index, column_index]
        return true if valid_move?(start, finish)
      end
    end
    false
  end
end
