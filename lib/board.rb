# frozen_string_literal: true

# board class
class Board
  WP = " \u2659".encode('utf-8')
  WN = " \u2658".encode('utf-8')
  WB = " \u2657".encode('utf-8')
  WR = " \u2656".encode('utf-8')
  WQ = " \u2655".encode('utf-8')
  WK = " \u2654".encode('utf-8')
  BP = " \u265F".encode('utf-8')
  BN = " \u265E".encode('utf-8')
  BB = " \u265D".encode('utf-8')
  BR = " \u265C".encode('utf-8')
  BQ = " \u265B".encode('utf-8')
  BK = " \u265A".encode('utf-8')
  EMPTY = ' -'
  BLANK = '  '

  def initialize
    board
  end

  # build a board with opening setup
  def board
    @board = Array.new(10) { Array.new(10) { EMPTY } }
    @board[0] = [BLANK, ' a', ' b', ' c', ' d', ' e', ' f', ' g', ' h', BLANK]
    @board[1] = [' 1', WR, WN, WB, WQ, WK, WB, WN, WR, ' 1']
    @board[2] = [' 2', WP, WP, WP, WP, WP, WP, WP, WP, ' 2']
    @board[3][0] = ' 3'
    @board[3][9] = ' 3'
    @board[4][0] = ' 4'
    @board[4][9] = ' 4'
    @board[5][0] = ' 5'
    @board[5][9] = ' 5'
    @board[6][0] = ' 6'
    @board[6][9] = ' 6'
    @board[7] = [' 7', BP, BP, BP, BP, BP, BP, BP, BP, ' 7']
    @board[8] = [' 8', BR, BN, BB, BQ, BK, BB, BN, BR, ' 8']
    @board[9] = [BLANK, ' a', ' b', ' c', ' d', ' e', ' f', ' g', ' h', BLANK]
  end

  def to_s
    string = ''
    (0..9).each do |row|
      (0..9).each { |col| string += @board[9 - row][col].to_s }
      string += "\n"
    end
    string
  end
end
