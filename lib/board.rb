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

  def initialize
    opening_board
  end

  # build a board with opening setup
  def opening_board
    @board = Array.new(12) { Array.new(10) { EMPTY_SQUARE } }
    @board[0] = Array.new(10) { BLANK_SPOT }
    @board[1] = [BLANK_SPOT, '   a', ' b', ' c', ' d', ' e', ' f', ' g', ' h', BLANK_SPOT]
    @board[2] = Array.new(10) { BLANK_SPOT }
    @board[3] = [' 1  ', W_ROOK, W_KNIGHT, W_BISHOP, W_QUEEN, W_KING, W_BISHOP, W_KNIGHT, W_ROOK, '   1']
    @board[4] = [' 2  ', W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, W_PAWN, '   2']
    @board[5][0] = ' 3  '
    @board[5][9] = '   3'
    @board[6][0] = ' 4  '
    @board[6][9] = '   4'
    @board[7][0] = ' 5  '
    @board[7][9] = '   5'
    @board[8][0] = ' 6  '
    @board[8][9] = '   6'
    @board[9] = [' 7  ', B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, B_PAWN, '   7']
    @board[10] = [' 8  ', B_ROOK, B_KNIGHT, B_BISHOP, B_QUEEN, B_KING, B_BISHOP, B_KNIGHT, B_ROOK, '   8']
    @board[11] = Array.new(10) { BLANK_SPOT }
    @board[12] = [BLANK_SPOT, '   a', ' b', ' c', ' d', ' e', ' f', ' g', ' h', BLANK_SPOT]
    @board[13] = Array.new(10) { BLANK_SPOT }
  end

  def to_s
    string = ''
    (0..BOARD_HEIGHT - 1).each do |row|
      (0..BOARD_HEIGHT - 1).each { |col| string += @board[BOARD_HEIGHT - 1 - row][col].to_s }
      string += "\n"
    end
    string
  end
end
