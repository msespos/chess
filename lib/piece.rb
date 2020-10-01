# frozen_string_literal: true

# piece class
class Piece
  # determines if a path is legal for a rook using the start, finish and playing field
  # uses #along_rank?, #along_file?, #rank_free? and #file_free?
  def rook_path?(start, finish, playing_field)
    return false unless along_rank?(start, finish) || along_file?(start, finish)

    return rank_free?(start, finish, playing_field) if along_rank?(start, finish)
    return file_free?(start, finish, playing_field) if along_file?(start, finish)
  end

  # used by #rook_path? and queen_path? to determine if all spots on a rank
  # between the start and finish are free
  def rank_free?(start, finish, playing_field)
    (start[0] + 1..finish[0] - 1).each do |file|
      return false unless playing_field[file][start[0]].nil?
    end
    true
  end

  # used by #rook_path? and queen_path? to determine if all spots on a rank
  # between the start and finish are free
  def file_free?(start, finish, playing_field)
    (start[1] + 1..finish[1] - 1).each do |rank|
      return false unless playing_field[start[1]][rank].nil?
    end
    true
  end

  # used by #rook_path? and #queen_path? to determine if the potential path is along a rank
  def along_rank?(start, finish)
    start[1] == finish[1]
  end

  # used by #rook_path? and #queen_path? to determine if the potential path is along a file
  def along_file?(start, finish)
    start[0] == finish[0]
  end
end
