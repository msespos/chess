# frozen_string_literal: true

# methods for testing for check and checkmate
module CheckAndMateValidation
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

  # check if the king is in checkmate using helper methods
  def in_checkmate?
    return false unless in_check?

    return false if can_move_out_of_check?

    return false if attacker_can_be_captured?

    return false if piece_can_be_put_in_the_way?

    true
  end

  # used by #in_checkmate to check if the king can move out of check
  def can_move_out_of_check?
    squares = accessible_squares
    current_king_square = king_location
    attacking_color = @current_player == :white ? :black : :white
    squares.each do |square|
      playing_field_before_move = @playing_field.clone.map(&:clone)
      move_piece(current_king_square, square)
      return true unless under_attack?(square, attacking_color)

      @playing_field = playing_field_before_move
    end
    false
  end

  # used by #can_move_out_of_check? to determine the squares accessible to the king
  # (under attack or not; that will be checked in #can_move_out_of_check?)
  def accessible_squares
    final_squares = []
    possible_squares = surrounding_squares(king_location)
    possible_squares.each do |square|
      final_squares.push(square) if valid_move?(king_location, square, @current_player)
    end
    final_squares
  end

  # used by #accessible_squares to determine the squares surrounding the king
  # (valid or not; includes king; will be validated in #accessible_squares)
  def surrounding_squares(current_square)
    squares = []
    [-1, 0, 1].each do |row_shift|
      [-1, 0, 1].each do |column_shift|
        squares.push([current_square[0] + column_shift, current_square[1] + row_shift])
      end
    end
    squares
  end

  # check if a piece attacking the king can be captured (including the case of double check)
  def attacker_can_be_captured?
    squares = attacker_squares(king_location)
    return false if squares.length > 1

    return false unless under_attack?(squares[0], @current_player)

    true
  end
end
