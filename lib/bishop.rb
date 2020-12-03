# frozen_string_literal: true

# bishop module
module Bishop
  private

  # determine if a path is legal for a bishop using the start, finish and playing field
  # uses methods in piece.rb
  def bishop_path?(start, finish, playing_field)
    return false unless along_positive_diagonal?(start, finish) || along_negative_diagonal?(start, finish)

    return positive_diagonal_free?(start, finish, playing_field) if along_positive_diagonal?(start, finish)

    return negative_diagonal_free?(start, finish, playing_field) if along_negative_diagonal?(start, finish)
  end
end
