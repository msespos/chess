# frozen_string_literal: true

# methods for testing for check
module CheckValidation
  # check if the king is in check
  def in_check?
    current_king_square = king_location
    attacking_color = @current_player == :white ? :black : :white
    under_attack?(current_king_square, attacking_color)
  end

  # used by #in_check? to find the square that the king is currently on
  def king_location
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

  # used by #in_check? and other methods to check if a square is under attack
  def under_attack?(square, attacking_color)
    finish = [square[0], square[1]]
    @playing_field.each_with_index do |row, row_index|
      row.each_index do |column_index|
        start = [row_index, column_index]
        return true if valid_move?(start, finish, attacking_color)
      end
    end
    false
  end

  # used by #attacker_can_be_captured? and other methods to find
  # the location(s) of the piece(s) attacking a square
  def attacker_squares(square)
    attacking_color = @current_player == :white ? :black : :white
    finish = [square[0], square[1]]
    squares = []
    @playing_field.each_with_index do |row, row_index|
      row.each_index do |column_index|
        start = [row_index, column_index]
        squares.push([row_index, column_index]) if valid_move?(start, finish, attacking_color)
      end
    end
    squares
  end
end
