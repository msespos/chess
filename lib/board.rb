# frozen_string_literal: true

# board class
class Board
  def initialize
    board
  end

  # build a board with opening setup
  def board
    @board = Array.new(8) { Array.new(8) { nil } }
    @board[0] = %i[WR WN WB WQ WK WB WN WR]
    @board[1] = %i[WP WP WP WP WP WP WP WP]
    @board[6] = %i[BP BP BP BP BP BP BP BP]
    @board[7] = %i[BR BN BB BK BQ BB BN BR]
  end
end
