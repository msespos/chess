# frozen_string_literal: true

# methods for handling pawn promotion
module PawnPromotion
  def pawn_to_promote
    (0..7).each do |column|
      return [:black, column] if @playing_field[column][0] == :b_pawn

      return [:white, column] if @playing_field[column][7] == :w_pawn
    end
    false
  end

  def promote_pawn
    color, column = pawn_to_promote
    new_piece = @player.obtain_promotion_piece_choice
    color == :black ? @playing_field[column][0] = new_piece : @playing_field[column][7] = new_piece
  end
end
