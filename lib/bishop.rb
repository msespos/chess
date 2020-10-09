# frozen_string_literal: true

require_relative 'piece.rb'

# bishop class
class Bishop < Piece
  # determine if a path is legal for a bishop using the start, finish and playing field
  # uses methods in Piece
  def path?(start, finish, playing_field)
    return false unless along_positive_diagonal?(start, finish) || along_negative_diagonal?(start, finish)
    return positive_diagonal_free?(start, finish, playing_field) if along_positive_diagonal?(start, finish)
    return negative_diagonal_free?(start, finish, playing_field) if along_negative_diagonal?(start, finish)
  end
end
