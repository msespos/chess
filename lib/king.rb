# frozen_string_literal: true

require_relative 'piece.rb'

# king class
class King < Piece
  # determine if a path is legal for a king using the start, finish and playing field
  # uses methods in Piece
  def path?(start, finish, playing_field)
    return false unless only_one_space?(start, finish) || castling?(start, finish, playing_field)

    true
  end

  def only_one_space?(start, finish)
    (0..1).each { |coord| start[coord] - finish[coord] <= 1 && start[coord] - finish[coord] >= -1 }
  end

  def castling?(start, finish, playing_field)
  end
end