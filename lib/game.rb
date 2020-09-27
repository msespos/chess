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
  # castle and en passant and pawn promotion will be separate functions to be incorporated later
  # the validation function will be dependent on the piece and the current playing field
  # the capture function will just be dependent on whether or not there is a piece in the finish square
  def move_piece(start, finish)
    return :invalid unless valid_move?(start, finish)

    s0 = start[0]
    s1 = start[1]
    f0 = finish[0]
    f1 = finish[1]
    temp = @playing_field[s0][s1]
    @playing_field[s0][s1] = nil
    captured = capture?(start, finish) ? @playing_field[f0][f1] : nil
    @playing_field[f0][f1] = temp
    captured
  end

  def valid_move?(start, finish) end

  def capture?(start, finish) end
end
