# frozen_string_literal: true

# queen module
module Queen
  private

  # determine if a path is legal for a queen using the start, finish and playing field
  # uses methods in piece.rb
  def queen_path?(start, finish, playing_field)
    return false unless along_rank_or_file_or_diagonal?(start, finish)
    return rank_free?(start, finish, playing_field) if along_rank?(start, finish)
    return file_free?(start, finish, playing_field) if along_file?(start, finish)
    return positive_diagonal_free?(start, finish, playing_field) if along_positive_diagonal?(start, finish)
    return negative_diagonal_free?(start, finish, playing_field) if along_negative_diagonal?(start, finish)
  end

  def along_rank_or_file_or_diagonal?(start, finish)
    along_rank?(start, finish) || along_file?(start, finish) ||
      along_positive_diagonal?(start, finish) || along_negative_diagonal?(start, finish)
  end
end
