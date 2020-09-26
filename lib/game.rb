# frozen_string_literal: true

# game class
class Game
  def initialize
    @board = Board.new
    opening_playing_field
  end

  def opening_playing_field
    @playing_field = Array.new(8) { Array.new(8) { nil } }
    @playing_field[0] = %i[w_rook w_knight w_bishop w_queen w_king w_bishop w_knight w_rook]
    @playing_field[1] = %i[w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn]
    @playing_field[6] = %i[b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn]
    @playing_field[7] = %i[b_rook b_knight b_bishop b_queen b_king b_bishop b_knight b_rook]
  end

  def algebraic_to_cartesian(algebraic_expression)
    cartesian_coordinates = [algebraic_expression[0].to_i, algebraic_expression[1].to_i]
  end
end
