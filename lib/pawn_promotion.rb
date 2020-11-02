# frozen_string_literal: true

# methods for handling pawn promotion
module PawnPromotion
  def pawn_to_promote?
    (0..7).each do |column|
      return [:black, [column, 0]] if @playing_field[column][0] == :b_pawn

      return [:white, [column, 7]] if @playing_field[column][7] == :w_pawn
    end
    false
  end
end
