# frozen_string_literal: true

# game class
class Game
  SYMBOL_TO_METHOD = { w_pawn: :pawn_path?,
                       w_knight: :knight_path?,
                       w_bishop: :bishop_path?,
                       w_rook: :rook_path?,
                       w_queen: :queen_path?,
                       w_king: :king_path?,
                       b_pawn: :pawn_path?,
                       b_knight: :knight_path?,
                       b_bishop: :bishop_path?,
                       b_rook: :rook_path?,
                       b_queen: :queen_path?,
                       b_king: :king_path? }.freeze

  def initialize
    @board = Board.new
    starting_playing_field
    @piece = Piece.new
  end

  # set up the playing field for the start of the game
  def starting_playing_field
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

  # move a piece (capturing or not) given start and finish coordinates
  # castling and en passant and pawn promotion still need to be incorporated
  def move_piece(start, finish)
    start0, start1, finish0, finish1 = start_finish_to_variables(start, finish)
    return :invalid unless valid_move?(start0, start1, finish0, finish1)

    temp = @playing_field[start0][start1]
    @playing_field[start0][start1] = nil
    captured = capture?(finish0, finish1) ? @playing_field[finish0][finish1] : nil
    @playing_field[finish0][finish1] = temp
    captured
  end

  # used by #move_piece
  def start_finish_to_variables(start, finish)
    start0 = start[0]
    start1 = start[1]
    finish0 = finish[0]
    finish1 = finish[1]
    [start0, start1, finish0, finish1]
  end

  # check if the move is valid by calling same_color? with the start and finish coordinates,
  # and the appropriate Piece method (using the SYMBOL_TO_METHOD hash to look up the method
  # based on the piece), with the start and finish coordinates and the playing field as arguments
  def valid_move?(start0, start1, finish0, finish1)
    return false if same_color?(@playing_field[start0][start1], @playing_field[finish0][finish1])

    @piece.send(SYMBOL_TO_METHOD[@playing_field[start0][start1]], start0, start1, finish0, finish1, @playing_field)
  end

  # used by #move_piece
  # check if there is a capture in the move by checking if there is a piece in the finish square
  def capture?(finish0, finish1)
    !@playing_field[finish0][finish1].nil?
  end

  # used by #valid_move?
  # check if the pieces in the start and finish square are the same color or not
  def same_color?(start_piece, finish_piece)
    start_piece[0] == finish_piece[0]
  end
end
