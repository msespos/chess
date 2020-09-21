# frozen_string_literal: true

# board class
class Board
  def initialize
    board
  end

  # build a board with opening setup
  def board
    @board = []
    @board.push(%i[WR WN WB WQ WK WB WN WR])
    @board.push(%i[WP WP WP WP WP WP WP WP])
    @board.push([nil, nil, nil, nil, nil, nil, nil, nil])
    @board.push([nil, nil, nil, nil, nil, nil, nil, nil])
    @board.push([nil, nil, nil, nil, nil, nil, nil, nil])
    @board.push([nil, nil, nil, nil, nil, nil, nil, nil])
    @board.push(%i[BP BP BP BP BP BP BP BP])
    @board.push(%i[BR BN BB BQ BK BB BN BR])
  end
end
