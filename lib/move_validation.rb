# frozen_string_literal: true

# methods for testing for check and checkmate
module MoveValidation
  # used by #move_piece
  # check if the move is valid by checking if the start and finish squares are different
  # and checking if the start and finish squares are on the playing field
  # and checking if the start and finish spaces are valid (different color pieces, start not nil)
  # and checking if the piece is the correct color for the player
  # and looking up the appropriate Piece path method using path_method_from_piece
  # and calling it on @piece
  def valid_move?(start, finish, color, checking_current_player = true)
    return false if start == finish

    return false unless on_playing_field?(start) && on_playing_field?(finish)

    return false unless start_and_finish_squares_valid?(start, finish, checking_current_player)

    return false unless correct_color?(start, color)

    start_piece = @playing_field[start[0]][start[1]]
    path_method = path_method_from_piece(start_piece)
    @piece.send(path_method, start, finish, @playing_field)
  end

  # used by #valid_move? to check if a set of coordinates is on the board
  def on_playing_field?(coordinates)
    coordinates[0] >= 0 && coordinates[0] <= 7 && coordinates[1] >= 0 && coordinates[1] <= 7
  end

  # used by valid_move? to check that the start and finish spaces are valid
  # check if start space is occupied
  # and call #finish_space_valid? on the start and finish pieces
  def start_and_finish_squares_valid?(start, finish, checking_current_player = true)
    start_piece = @playing_field[start[0]][start[1]]
    finish_piece = @playing_field[finish[0]][finish[1]]
    return false if start_piece.nil?

    return false unless finish_square_valid?(start_piece, finish_piece, checking_current_player)

    true
  end

  # used by start_and_finish_squares_valid?
  # check if the piece in the finish square is nil or not
  # or if the pieces in the start and finish square are the same color or not
  def finish_square_valid?(start_piece, finish_piece, checking_current_player = true)
    if finish_piece.nil?
      true
    else
      checking_current_player ? start_piece[0] != finish_piece[0] : start_piece[0] == finish_piece[0]
    end
  end

  # used by #valid_move? to check if the starting piece is the same color as the color passed in
  def correct_color?(start, color)
    start_piece = @playing_field[start[0]][start[1]]
    start_piece[0] == color[0]
  end

  # used by #valid_move to get the path method to be used from the piece symbol passed in
  def path_method_from_piece(start_piece)
    if start_piece == :w_pawn
      'white_pawn_path?'
    elsif start_piece == :b_pawn
      'black_pawn_path?'
    else
      (start_piece[2..-1] + '_path?')
    end
  end
end
