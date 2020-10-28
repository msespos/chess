# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength

# methods for testing for checkmate
module CheckmateValidation
  # check if the king is in checkmate using helper methods
  def in_checkmate?
    return false unless in_check?

    return false if can_move_out_of_check?

    return false if attacker_can_be_captured?

    return false if attacker_can_be_blocked?

    true
  end

  # used by #in_checkmate to check if the king can move out of check
  def can_move_out_of_check?
    attacking_color = @current_player == :white ? :black : :white
    accessible_squares.each do |accessible_square|
      return true if escape_squares_available?(accessible_square, attacking_color) == true
    end
    false
  end

  # used by #can_move_out_of_check? to check if the king can escape to any squares
  def escape_squares_available?(accessible_square, attacking_color)
    # make a copy of the playing field to revert to after testing king moves
    playing_field_before_move = @playing_field.clone.map(&:clone)
    move_piece(king_location, accessible_square, true)
    unless under_attack?(accessible_square, attacking_color)
      # revert to pre-test-move copy of playing field
      @playing_field = playing_field_before_move
      return true
    end
    # revert to pre-test-move copy of playing field
    @playing_field = playing_field_before_move
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

    return false if attacking_piece_protected?(squares[0])

    return false unless under_attack?(squares[0], @current_player)

    true
  end

  # check if a piece can be put in the way of a piece attacking the king
  # if in double check, returns false
  # if not, examine the piece attacking - only rooks, bishops, and queens can be blocked
  # if under attack by a rook, bishop, or queen:
  # look at all of the spaces on the rank, file or diagonal of attack
  # check if any of those spaces are under attack by the current player
  def attacker_can_be_blocked?
    squares = attacker_squares(king_location)
    return false if squares.length != 1

    attacker_square = squares[0]
    return false unless blockable_piece_type?(attacker_square)

    return true if possible_blocks_under_attack?(attacker_square)

    false
  end

  # used by #attacker_can_be_blocked? to determine if the piece is a blockable type
  def blockable_piece_type?(attacker_square)
    piece_type = @playing_field[attacker_square[0]][attacker_square[1]]
    piece_type_without_color = piece_type[2..-1].to_sym
    possible_attackers = %i[rook bishop queen]
    return false unless possible_attackers.include?(piece_type_without_color)

    true
  end

  # used by #attacker_can_be_blocked? to determine if the possible blocks are under attack
  def possible_blocks_under_attack?(attacker_square)
    possible_blocks = squares_between(attacker_square, king_location)
    possible_blocks.each { |possibility| return true if under_attack?(possibility, @current_player, true) }
    false
  end

  # used by possible_blocks_under_attack? to find the squares between two pieces
  def squares_between(square_one, square_two)
    squares = if square_one[0] == square_two[0]
                squares_between_on_file(square_one, square_two)
              elsif square_one[1] == square_two[1]
                squares_between_on_rank(square_one, square_two)
              else
                squares_between_on_diagonal(square_one, square_two)
              end
    squares
  end

  # used by #squares_between to find the squares between two pieces on the same file
  def squares_between_on_file(square_one, square_two)
    squares = []
    square_below = square_one[1] < square_two[1] ? square_one : square_two
    square_above = square_one[1] > square_two[1] ? square_one : square_two
    (square_below[1] + 1..square_above[1] - 1).each { |row| squares.push([square_one[0], row]) }
    squares
  end

  # used by #squares_between to find the squares between two pieces on the same rank
  def squares_between_on_rank(square_one, square_two)
    squares = []
    square_left = square_one[0] < square_two[0] ? square_one : square_two
    square_right = square_one[0] > square_two[0] ? square_one : square_two
    (square_left[0] + 1..square_right[0] - 1).each { |column| squares.push([column, square_one[1]]) }
    squares
  end

  # used by #squares_between to find the squares between two pieces on the same diagonal
  def squares_between_on_diagonal(square_one, square_two)
    square_left = square_one[0] < square_two[0] ? square_one : square_two
    square_right = square_left == square_one ? square_two : square_one
    square_below = square_one[1] < square_two[1] ? square_one : square_two
    find_diagonal_squares(square_left, square_right, square_below)
  end

  # used by squares_between_on_diagonal to find the squares on the diagonal
  def find_diagonal_squares(square_left, square_right, square_below)
    squares = []
    (square_left[0] + 1..square_right[0] - 1).each_with_index do |column, column_index|
      squares.push([column, square_left[1] + column_index + 1]) if square_left == square_below

      squares.push([column, square_left[1] - column_index - 1]) if square_right == square_below
    end
    squares
  end
end

# rubocop:enable Metrics/ModuleLength
