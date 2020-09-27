# frozen_string_literal: true

# game class
class Game
  def initialize
    @board = Board.new
    starting_playing_field
    @rook = Rook.new
  end

  # set up the playing field for the start of the game
  def starting_playing_field
    @playing_field = Array.new(8) { Array.new(8) { nil } }
    @playing_field[0] = %i[w_rook w_knight w_bishop w_queen w_king w_bishop w_knight w_rook]
    @playing_field[1] = %i[w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn]
    @playing_field[6] = %i[b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn]
    @playing_field[7] = %i[b_rook b_knight b_bishop b_queen b_king b_bishop b_knight b_rook]
    @playing_field = @playing_field.transpose
  end

  # convert an algebraic expression (user input) to cartesian coordinates (for piece manipulation)
  def algebraic_to_cartesian(algebraic_expression)
    [algebraic_expression.ord - 97, algebraic_expression[1].to_i - 1]
  end

  # move a piece (capturing or not) given start and finish coordinates
  # castling and en passant and pawn promotion still need to be incorporated
  def move_piece(start, finish)
    return :invalid unless valid_move?(start, finish)

    temp = @playing_field[start[0]][start[1]]
    @playing_field[start[0]][start[1]] = nil
    captured = capture?(finish) ? @playing_field[finish[0]][finish[1]] : nil
    @playing_field[finish[0]][finish[1]] = temp
    captured
  end

  # checks if the move is valid by calling path_to? on the piece in the start square
  # and the start and finish coordinates
  def valid_move?(start, finish)
    return false if same_color?(@playing_field[start[0]][start[1]], @playing_field[finish[0]][finish[1]])

    path_to?(@playing_field[start[0]][start[1]], start, finish)
  end

  # checks if there is a capture in the move by checking if there is a piece in the finish square
  def capture?(finish)
    !@playing_field[finish[0]][finish[1]].nil?
  end

  # checks if the pieces in the start and finish square are the same color or not
  def same_color?(start, finish)
    @playing_field[start[0]][start[1]][0] == @playing_field[finish[0]][finish[1]][0]
  end

  # determines if there is a path from the start to the finish using the piece, the start and finish
  # coordinates, and the current state of the playing field
  def path_to?(piece, start, finish) end
end
