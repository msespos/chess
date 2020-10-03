# frozen_string_literal: true

require_relative 'piece.rb'

# knight class
class Knight < Piece
  # determine if a path is legal for a knight using the start, finish and playing field
  def path?(start, finish)
    vertical_l?(start, finish) || horizontal_l?(start, finish)
  end

  # used by path? to determine if a path is in a vertical l-shape
  def vertical_l?(start, finish)
    (start[0] - finish[0]).abs == 1 && (start[1] - finish[1]).abs == 2
  end

  # used by path? to determine if a path is in a horizontal l-shape
  def horizontal_l?(start, finish)
    (start[0] - finish[0]).abs == 2 && (start[1] - finish[1]).abs == 1
  end
end
