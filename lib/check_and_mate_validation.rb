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

    # a) check if he can move out of check
    #   i) check which spots he can move to at all
    #   ii) check if those spots are under attack
    return false if can_move_out_of_check?

    # b) check if the attacking pieces can be captured
    #   i) ID attacking piece or pieces using a version of under attack method
    #   ii) call under_attack on those pieces to see if they can be captured
    return false if attacker_can_be_captured?

    # c) check if a piece can be put in the way
    #   i) if double check, this is not an option
    #   ii) otherwise, use the same version of under attack method as in b)
    #   iii) if under attack by a rook, bishop, or queen
	  #     A) look at all of the spaces on the rank, file and/or diagonal, depending
	  #     B) call under_attack on those spaces
    return false if piece_can_be_put_in_the_way?

    # If any of a), b), or c) is true, carry on - otherwise king is in checkmate and game is over
    true
  end

  def can_move_out_of_check?; end

  def attacker_can_be_captured?; end

  def piece_can_be_put_in_the_way?; end
end
