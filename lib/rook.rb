# frozen_string_literal: true

# rook class
class Rook < Piece
  # determines if a path is legal for a rook using the start, finish and playing field
  # uses #along_rank?, #along_file?, #rank_free? and #file_free?
  def path?(start, finish, playing_field)
    return false unless along_rank?(start, finish) || along_file?(start, finish)

    return rank_free?(start, finish, playing_field) if along_rank?(start, finish)
    return file_free?(start, finish, playing_field) if along_file?(start, finish)
  end
end
