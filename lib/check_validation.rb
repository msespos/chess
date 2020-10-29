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
    @playing_field.each_with_index do |column, column_index|
      column.each_index do |row_index|
        if @playing_field[column_index][row_index] == current_king.to_sym
          current_king_square = [column_index, row_index]
        end
      end
    end
    current_king_square
  end

  # used by #in_check? and other methods to check if a square is under attack
  # if check_all_but_king is true, does not check attacks by king
  # check_all_but_king is only used by #possible_blocks_under_attack
  def under_attack?(square, attacking_color, check_all_but_king = false)
    @playing_field.each_with_index do |column, column_index|
      column.each_index do |row_index|
        return true if under_attack_with_or_without_king?(square, column_index, row_index,
                                                          attacking_color, check_all_but_king)
      end
    end
    false
  end

  # used by #under_attack? to determine if the king will be counted among the potential
  # attackers, in most cases, or not, in #possible_blocks_under_attack?
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

  # used by under_attack_with_or_without_king? to create the current king symbol from @current_player
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
    @playing_field.each_with_index do |column, column_index|
      column.each_index do |row_index|
        start = [column_index, row_index]
        squares.push([column_index, row_index]) if valid_move?(start, finish, attacking_color)
      end
    end
    squares
  end

  # used by #attacker_can_be_captured? in CheckmateValidation to check if a piece is
  # protecting the attacking piece and thus the attacking piece cannot be attacked by the king
  # uses fourth #valid_move? argument to tell it to use the color of the attacking piece
  # not of the current player
  def attacking_piece_protected?(attacking_piece_square)
    attacking_color = @current_player == :white ? :black : :white
    @playing_field.each_with_index do |column, column_index|
      column.each_index do |row_index|
        start = [column_index, row_index]
        return true if valid_move?(start, attacking_piece_square, attacking_color, false)
      end
    end
    false
  end
end
