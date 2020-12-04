# frozen_string_literal: true

# methods for testing for stalemate
module StalemateValidation
  private

  # used by #game_over?
  # check if a player is in stalemate by checking if they have any valid moves
  def in_stalemate?
    return false if in_checkmate?

    # make a copy of the playing field to revert to after testing king moves
    playing_field_before_move = @playing_field.clone.map(&:clone)

    return false unless no_valid_moves_on_board?(playing_field_before_move)

    # revert to pre-test-move copy of playing field
    @playing_field = playing_field_before_move
    true
  end

  # used by #in_stalemate?
  def no_valid_moves_on_board?(playing_field_before_move)
    @playing_field.each_with_index do |column, column_index|
      column.each_index do |row_index|
        piece = @playing_field[column_index][row_index]
        next if piece.nil? || piece[0] != @current_player[0]

        return false unless no_valid_moves_for_piece?(playing_field_before_move,
                                                      column_index, row_index)
      end
    end
    true
  end

  # used by #in_stalemate?
  def no_valid_moves_for_piece?(playing_field_before_move, column_index, row_index)
    @playing_field.each_with_index do |inner_column, inner_column_index|
      inner_column.each_index do |inner_row_index|
        next if move_piece([column_index, row_index],
                           [inner_column_index, inner_row_index], false, true) == :invalid

        # revert to pre-test-move copy of playing field
        @playing_field = playing_field_before_move
        return false
      end
    end
    true
  end
end
