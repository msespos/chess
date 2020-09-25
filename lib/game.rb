# frozen_string_literal: true

# game class
class Game
  def initialize
    board = Board.new
    w_pawn_a = Pawn.new(:white)
    w_pawn_b = Pawn.new(:white)
    w_pawn_c = Pawn.new(:white)
    w_pawn_d = Pawn.new(:white)
    w_pawn_e = Pawn.new(:white)
    w_pawn_f = Pawn.new(:white)
    w_pawn_g = Pawn.new(:white)
    w_pawn_h = Pawn.new(:white)
    w_knight_b = Knight.new(:white)
    w_knight_g = Knight.new(:white)
    w_bishop_c = Bishop.new(:white)
    w_bishop_f = Bishop.new(:white)
    w_rook_a = Bishop.new(:white)
    w_rook_h = Bishop.new(:white)
    w_queen = Queen.new(:white)
    w_king = King.new(:white)
    w_pawn_a = Pawn.new(:black)
    b_pawn_b = Pawn.new(:black)
    b_pawn_c = Pawn.new(:black)
    b_pawn_d = Pawn.new(:black)
    b_pawn_e = Pawn.new(:black)
    b_pawn_f = Pawn.new(:black)
    b_pawn_g = Pawn.new(:black)
    b_pawn_h = Pawn.new(:black)
    b_knight_b = Knight.new(:black)
    b_knight_g = Knight.new(:black)
    b_bishop_c = Bishop.new(:black)
    b_bishop_f = Bishop.new(:black)
    b_rook_a = Bishop.new(:black)
    b_rook_h = Bishop.new(:black)
    b_queen = Queen.new(:black)
    b_king = King.new(:black)
  end
end
