# frozen_string_literal: true

# game class
class Game
  def initialize
    @board = Board.new
    create_pieces
    opening_playing_field
  end

  def create_pieces
    white_pawns
    white_pieces
    black_pawns
    black_pieces
  end

  def white_pawns
    @w_pawn_a = Pawn.new(:white)
    @w_pawn_b = Pawn.new(:white)
    @w_pawn_c = Pawn.new(:white)
    @w_pawn_d = Pawn.new(:white)
    @w_pawn_e = Pawn.new(:white)
    @w_pawn_f = Pawn.new(:white)
    @w_pawn_g = Pawn.new(:white)
    @w_pawn_h = Pawn.new(:white)
  end

  def white_pieces
    @w_knight_b = Knight.new(:white)
    @w_knight_g = Knight.new(:white)
    @w_bishop_c = Bishop.new(:white)
    @w_bishop_f = Bishop.new(:white)
    @w_rook_a = Rook.new(:white)
    @w_rook_h = Rook.new(:white)
    @w_queen = Queen.new(:white)
    @w_king = King.new(:white)
  end

  def black_pawns
    @b_pawn_a = Pawn.new(:black)
    @b_pawn_b = Pawn.new(:black)
    @b_pawn_c = Pawn.new(:black)
    @b_pawn_d = Pawn.new(:black)
    @b_pawn_e = Pawn.new(:black)
    @b_pawn_f = Pawn.new(:black)
    @b_pawn_g = Pawn.new(:black)
    @b_pawn_h = Pawn.new(:black)
  end

  def black_pieces
    @b_knight_b = Knight.new(:black)
    @b_knight_g = Knight.new(:black)
    @b_bishop_c = Bishop.new(:black)
    @b_bishop_f = Bishop.new(:black)
    @b_rook_a = Rook.new(:black)
    @b_rook_h = Rook.new(:black)
    @b_queen = Queen.new(:black)
    @b_king = King.new(:black)
  end

  def opening_playing_field
    @playing_field = Array.new(8) { Array.new(8) { nil } }
    @playing_field[0] = [@w_rook_a, @w_knight_b, @w_bishop_c, @w_queen,
                         @w_king, @w_bishop_f, @w_knight_g, @w_rook_h]
    @playing_field[1] = [@w_pawn_a, @w_pawn_b, @w_pawn_c, @w_pawn_d,
                         @w_pawn_e, @w_pawn_f, @w_pawn_g, @w_pawn_h]
    @playing_field[6] = [@b_pawn_a, @b_pawn_b, @b_pawn_c, @b_pawn_d,
                         @b_pawn_e, @b_pawn_f, @b_pawn_g, @b_pawn_h]
    @playing_field[7] = [@b_rook_a, @b_knight_b, @b_bishop_c, @b_queen,
                         @b_king, @b_bishop_f, @b_knight_g, @b_rook_h]
  end
end
