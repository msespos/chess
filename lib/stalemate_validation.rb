# frozen_string_literal: true

# methods for testing for stalemate
module StalemateValidation
  def in_stalemate?
    return false if in_checkmate?

    # make a copy of the playing field to revert to after testing king moves
    playing_field_before_move = @playing_field.clone.map(&:clone)
    @playing_field.each_with_index do |column, column_index|
      column.each_index do |row_index|
        piece = @playing_field[column_index][row_index]
        next if piece.nil? || piece[0] != @current_player[0]

        @playing_field.each_with_index do |inner_column, inner_column_index|
          inner_column.each_index do |inner_row_index|
            next if move_piece([column_index, row_index], [inner_column_index, inner_row_index]) == :invalid

            # revert to pre-test-move copy of playing field
            @playing_field = playing_field_before_move
            return false
          end
        end
      end
    end
    # revert to pre-test-move copy of playing field
    @playing_field = playing_field_before_move
    true
  end
end
