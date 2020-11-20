# frozen_string_literal: true

# methods for handling pawn promotion
module PawnPromotion
  INPUT_TO_PIECE = { n: 'knight',
                     b: 'bishop',
                     r: 'rook',
                     q: 'queen' }.freeze

  def pawn_to_promote
    (0..7).each do |column|
      return [:black, column] if @playing_field[column][0] == :b_pawn

      return [:white, column] if @playing_field[column][7] == :w_pawn
    end
    false
  end

  def promote_pawn
    color, column = pawn_to_promote
    input = @player.user_move_input(:piece)
    new_piece = input_to_piece(input, color)
    color == :black ? @playing_field[column][0] = new_piece : @playing_field[column][7] = new_piece
    display_board
  end

  def input_to_piece(input, color)
    input = input.downcase.to_sym
    new_piece_without_color = INPUT_TO_PIECE[input]
    color == :black ? ('b_' + new_piece_without_color).to_sym : ('w_' + new_piece_without_color).to_sym
  end
end
