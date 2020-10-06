# frozen_string_literal: true

# game class
class Game
  SYMBOL_TO_METHOD = { w_pawn: :w_pawn_path?,
                       w_knight: :knight_path?,
                       w_bishop: :bishop_path?,
                       w_rook: :rook_path?,
                       w_queen: :queen_path?,
                       w_king: :king_path?,
                       b_pawn: :b_pawn_path?,
                       b_knight: :knight_path?,
                       b_bishop: :bishop_path?,
                       b_rook: :rook_path?,
                       b_queen: :queen_path?,
                       b_king: :king_path? }.freeze

  def initialize
    @board = Board.new
    initial_playing_field
    @piece = Piece.new
  end

  # set up the playing field for the start of the game
  def initial_playing_field
    @playing_field = Array.new(8) { Array.new(8) { nil } }
    @playing_field[0] = %i[w_rook w_knight w_bishop w_queen w_king w_bishop w_knight w_rook]
    @playing_field[1] = %i[w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn]
    @playing_field[6] = %i[b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn]
    @playing_field[7] = %i[b_rook b_knight b_bishop b_queen b_king b_bishop b_knight b_rook]
    @playing_field = @playing_field.transpose
  end

  # convert an algebraic expression (user input) to cartesian coordinates (for piece manipulation)
  def algebraic_to_cartesian(algebraic_expression)
    [algebraic_expression.ord - 97, algebraic_expression[1].to_i - 1]
  end

  # transfer a playing field to the board by calling Board#overwrite_playing_field
  def playing_field_to_board(playing_field)
    @board.overwrite_playing_field(playing_field)
  end

  # move a piece or a pawn (capturing or not) given start and finish coordinates
  # castling, en passant and pawn promotion still need to be incorporated
  def move_piece(start, finish)
    return :invalid unless valid_move?(start, finish)

    temp = @playing_field[start[0]][start[1]]
    @playing_field[start[0]][start[1]] = nil
    captured = capture(finish)
    @playing_field[finish[0]][finish[1]] = temp
    captured
  end

  # used by #move_piece
  # check if the move is valid by checking if the start and finish squares are different,
  # and checking if the start and finish squares are on the playing field,
  # and checking if the start and finish squares are the same color,
  # and looking up the appropriate Piece path method using the SYMBOL_TO_METHOD hash
  # and the piece on the starting square, and calling it on @piece
  def valid_move?(start, finish)
    return false if start == finish

    return false unless on_playing_field?(start) && on_playing_field?(finish)

    start_piece = @playing_field[start[0]][start[1]]
    finish_piece = @playing_field[finish[0]][finish[1]]
    return false if same_color?(start_piece, finish_piece)

    @piece.send(SYMBOL_TO_METHOD[start_piece], start, finish, @playing_field)
  end

  # used by #valid_move? to check if a set of coordinates is on the board
  def on_playing_field?(coordinates)
    coordinates[0] >= 0 && coordinates[0] <= 7 && coordinates[1] >= 0 && coordinates[1] <= 7
  end

  # used by #valid_move?
  # check if the pieces in the start and finish square are the same color or not
  def same_color?(start_piece, finish_piece)
    start_piece[0] == finish_piece[0]
  end

  # used by #move_piece
  # check if there is a capture in the move by checking if there is a piece in the finish square
  # make the capture and return the piece if there is - otherwise return nil
  def capture(finish)
    return @playing_field[finish[0]][finish[1]] unless @playing_field[finish[0]][finish[1]].nil?

    nil
  end
end
