# frozen_string_literal: true

# methods for testing for check and checkmate
module CheckAndMateValidation
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
    attacking_color = @current_player == :white ? :black : :white
    finish = [position[0], position[1]]
    @playing_field.each_with_index do |row, row_index|
      row.each_index do |column_index|
        start = [row_index, column_index]
        return true if valid_move?(start, finish, attacking_color)
      end
    end
    false
  end

  def in_checkmate?
    # If the King is in Check:
    return false unless in_check?

    return false if can_move_out_of_check?

    return false if attacker_can_be_captured?

    return false if piece_can_be_put_in_the_way?

    # If any of a), b), or c) is true, carry on - otherwise king is in checkmate and game is over
    true
  end

  # a) check if he can move out of check
  #   i) check which spots he can move to at all
  #  ii) check if those spots are under attack
  def can_move_out_of_check?
    squares = accessible_squares
    under_attack?(squares)
  end

  # find the king
  # create an array of all the squares surrounding the king
  # check each square for if it passes valid_move?
  # return the array of squares that pass valid_move?
  def accessible_squares
    attacking_color = @current_player == :white ? :black : :white
    valid_squares = []
    current_king_square = find_king
    squares = surrounding_eight(current_king_square)
    squares.each do |square|
      valid_squares.push(square) if valid_move?(current_king_square, square, attacking_color)
    end
    valid_squares
  end

  def surrounding_eight(current_king_square)
    surrounding_squares = []
    [-1, 0, 1].each { |i| surrounding_squares.push([current_king_square[0] + i, current_king_square[1] - 1]) }
    [-1, 1].each { |i| surrounding_squares.push([current_king_square[0] + i, current_king_square[1]]) }
    [-1, 0, 1].each { |i| surrounding_squares.push([current_king_square[0] + i, current_king_square[1] + 1]) }
    surrounding_squares
  end

  # b) check if the attacking pieces can be captured
  #   i) ID attacking piece or pieces using a version of under attack method
  #  ii) call under_attack on those pieces to see if they can be captured
  def attacker_can_be_captured?; end

  # c) check if a piece can be put in the way
  #   i) if double check, this is not an option
  #  ii) otherwise, use the same version of under attack method as in b)
  # iii) if under attack by a rook, bishop, or queen
	#     A) look at all of the spaces on the rank, file and/or diagonal, depending
	#     B) call under_attack on those spaces
  def piece_can_be_put_in_the_way?; end
end
