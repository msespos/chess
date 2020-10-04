# frozen_string_literal: true

# piece class
class Piece
  # determines if a path is legal for a rook using the start, finish and playing field
  # uses #along_rank?, #along_file?, #rank_free? and #file_free?
  def rook_path?(start, finish, playing_field)
    @rook = Rook.new
    @rook.path?(start, finish, playing_field)
  end

  def bishop_path?(start, finish, playing_field)
    @bishop = Bishop.new
    @bishop.path?(start, finish, playing_field)
  end

  def queen_path?(start, finish, playing_field)
    @queen = Queen.new
    @queen.path?(start, finish, playing_field)
  end

  def king_path?(start, finish, _playing_field)
    @king = King.new
    @king.path?(start, finish)
  end

  def knight_path?(start, finish, _playing_field)
    @knight = Knight.new
    @knight.path?(start, finish)
  end

  def white_pawn_path?(start, finish, playing_field)
    @pawn = Pawn.new
    @pawn.path?(start, finish, playing_field, :w)
  end

  def black_pawn_path?(start, finish, playing_field)
    @pawn = Pawn.new
    @pawn.path?(start, finish, playing_field, :b)
  end

  # used by Rook#path? and Queen#path? to determine if all spots on a rank
  # between the start and finish are free
  def rank_free?(start, finish, playing_field)
    if start[0] < finish[0]
      blank_rank_path?(start[0], finish[0], start, playing_field)
    else
      blank_rank_path?(finish[0], start[0], start, playing_field)
    end
  end

  # used by #rank_free to check that the inspected spaces are free
  def blank_rank_path?(left, right, start, playing_field)
    (left + 1..right - 1).each do |file|
      return false unless playing_field[file][start[1]].nil?
    end
    true
  end

  # used by #Rook#path? and Queen#path? to determine if all spaces on a file
  # between the start and finish are free
  def file_free?(start, finish, playing_field)
    if start[1] < finish[1]
      blank_file_path?(start[1], finish[1], start, playing_field)
    else
      blank_file_path?(finish[1], start[1], start, playing_field)
    end
  end

  # used by #file_free to check that the inspected spaces are free
  def blank_file_path?(bottom, top, start, playing_field)
    (bottom + 1..top - 1).each do |rank|
      return false unless playing_field[start[0]][rank].nil?
    end
    true
  end

  # used by #Rook#path? and #Queen#path? to determine if the potential path is along a rank
  def along_rank?(start, finish)
    start[1] == finish[1]
  end

  # used by #Rook#path? and #Queen#path? to determine if the potential path is along a file
  def along_file?(start, finish)
    start[0] == finish[0]
  end

  # used by #Bishop#path? and Queen#path? to determine if all spaces on a positive diagonal
  # between the start and finish are free
  def positive_diagonal_free?(start, finish, playing_field)
    if start[0] < finish[0]
      blank_positive_diagonal_path?(start[0], finish[0], start[1], playing_field)
    else
      blank_positive_diagonal_path?(finish[0], start[0], finish[1], playing_field)
    end
  end

  # used by #positive_diagonal_free to check that the inspected spaces are free
  def blank_positive_diagonal_path?(left, right, bottom, playing_field)
    (1..right - left - 1).each do |step|
      return false unless playing_field[left + step][bottom + step].nil?
    end
    true
  end

  # used by #Bishop#path? and Queen#path? to determine if all spaces on a negative diagonal
  # between the start and finish are free
  def negative_diagonal_free?(start, finish, playing_field)
    if start[0] < finish[0]
      blank_negative_diagonal_path?(start[0], finish[0], start[1], playing_field)
    else
      blank_negative_diagonal_path?(finish[0], start[0], finish[1], playing_field)
    end
  end

  # used by #negative_diagonal_free to check that the inspected spaces are free
  def blank_negative_diagonal_path?(left, right, top, playing_field)
    (1..right - left - 1).each do |step|
      return false unless playing_field[left + step][top - step].nil?
    end
    true
  end

  # used by #Bishop#path? and #Queen#path? to determine if the potential path is along a positive diagonal
  def along_positive_diagonal?(start, finish)
    finish[0] - start[0] == finish[1] - start[1]
  end

  # used by #Bishop#path? and #Queen#path? to determine if the potential path is along a negative diagonal
  def along_negative_diagonal?(start, finish)
    finish[0] - start[1] == start[0] - finish[1]
  end
end
