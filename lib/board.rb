# frozen_string_literal: true

# board class
class Board
  W_PAWN = " \u2659".encode('utf-8')
  W_KNIGHT = " \u2658".encode('utf-8')
  W_BISHOP = " \u2657".encode('utf-8')
  W_ROOK = " \u2656".encode('utf-8')
  W_QUEEN = " \u2655".encode('utf-8')
  W_KING = " \u2654".encode('utf-8')
  B_PAWN = " \u265F".encode('utf-8')
  B_KNIGHT = " \u265E".encode('utf-8')
  B_BISHOP = " \u265D".encode('utf-8')
  B_ROOK = " \u265C".encode('utf-8')
  B_QUEEN = " \u265B".encode('utf-8')
  B_KING = " \u265A".encode('utf-8')
  EMPTY_SQUARE = ' -'
  BLANK_SPOT = '  '
  BOARD_HEIGHT = 14

  SYMBOL_TO_CONSTANT = { w_pawn: W_PAWN,
                         w_knight: W_KNIGHT,
                         w_bishop: W_BISHOP,
                         w_rook: W_ROOK,
                         w_queen: W_QUEEN,
                         w_king: W_KING,
                         b_pawn: B_PAWN,
                         b_knight: B_KNIGHT,
                         b_bishop: B_BISHOP,
                         b_rook: B_ROOK,
                         b_queen: B_QUEEN,
                         b_king: B_KING }.freeze
  def initialize
    opening_board
  end

  # build a board with opening setup
  def opening_board
    @board = Array.new(14) { Array.new(10) { nil } }
    opening_board_piece_rows
    opening_board_letter_rows
    opening_board_empty_squares
    opening_board_number_columns
  end

  def opening_board_piece_rows
    @board[3] = [' 1  ', W_ROOK, W_KNIGHT, W_BISHOP, W_QUEEN, W_KING, W_BISHOP, W_KNIGHT, W_ROOK, '   1']
    @board[4] = [' 2  ', W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, '   2']
    @board[9] = [' 7  ', B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, '   7']
    @board[10] = [' 8  ', B_ROOK, B_KNIGHT, B_BISHOP, B_QUEEN, B_KING, B_BISHOP, B_KNIGHT, B_ROOK, '   8']
  end

  def opening_board_letter_rows
    @board[1] = [BLANK_SPOT, '   a', ' b', ' c', ' d', ' e', ' f', ' g', ' h', nil]
    @board[12] = [BLANK_SPOT, '   a', ' b', ' c', ' d', ' e', ' f', ' g', ' h', nil]
  end

  def opening_board_empty_squares
    (5..8).each { |row| @board[row] = Array.new(10) { EMPTY_SQUARE } }
  end

  # the numbers bordering the empty square rows
  def opening_board_number_columns
    (5..8).each { |row| @board[row][0] = ' ' + (row - 2).to_s + '  ' }
    (5..8).each { |row| @board[row][9] = '   ' + (row - 2).to_s }
  end

  def to_s
    string = ''
    (0..BOARD_HEIGHT - 1).each do |row|
      (0..BOARD_HEIGHT - 1).each { |col| string += @board[BOARD_HEIGHT - 1 - row][col].to_s }
      string += "\n"
    end
    string
  end

  def on_board?(coordinates)
    coordinates[0] > 2 && coordinates[0] < 11 && coordinates[1].positive? && coordinates[1] < 9
  end

  # overwrite the playing field using an 8x8 playing field input from Game and #overwrite_square
  def overwrite_playing_field(playing_field)
    (0..7).each do |column|
      (0..7).each do |row|
        @board[row + 3][column + 1] = if playing_field[column][row].nil?
                                        EMPTY_SQUARE
                                      else
                                        SYMBOL_TO_CONSTANT[playing_field[column][row]]
                                      end
      end
    end
  end
end
