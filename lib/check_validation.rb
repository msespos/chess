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
  # if under_attack_by_all_but_king is true, does not check attacks by king
  def under_attack?(square, attacking_color, check_all_but_king = false)
    @playing_field.each_with_index do |row, row_index|
      row.each_index do |column_index|
        return true if under_attack_with_or_without_king?(square, row_index, column_index,
                                                          attacking_color, check_all_but_king)
      end
    end
    false
  end

  # used by under_attack? to determine if the king will be counted among the potential attackers
  def under_attack_with_or_without_king?(square, row_index, column_index,
                                         attacking_color, check_all_but_king)
    start = [row_index, column_index]
    finish = [square[0], square[1]]
    if check_all_but_king
      unless @playing_field[row_index][column_index] == current_king
        return true if valid_move?(start, finish, attacking_color)
      end
    elsif valid_move?(start, finish, attacking_color)
      return true
    end
    false
  end

  # used by under_attack_with_or_without_king to creat the current king from @current_player
  def current_king
    current_king_string = @current_player[0] + '_king'
    current_king_string.to_sym
  end

  # used by #attacker_can_be_captured? and other methods in CheckmateValidation
  # to find the location(s) of the piece(s) attacking a square
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
