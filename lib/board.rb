# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

# board class
class Board
  MINIMALIST_DASH = ' -'
  BLANK_SPOT = '    '
  BOARD_HEIGHT = 14
  BOARD_WIDTH = 18

  def initialize(white_or_black_start, minimalist_or_checkerboard, light_or_dark_font)
    @minimalist_or_checkerboard = minimalist_or_checkerboard
    @light_or_dark_font = light_or_dark_font
    @white_or_black_start = white_or_black_start
    set_up_pieces
    set_up_board
  end

  def set_up_pieces
    if @minimalist_or_checkerboard == :minimalist
      initial_white_minimalist_pieces
      initial_black_minimalist_pieces
    elsif @minimalist_or_checkerboard == :checkerboard
      initial_white_checkerboard_pieces
      initial_black_checkerboard_pieces
    end
  end

  def initial_white_minimalist_pieces
    @w_pawn = @light_or_dark_font == :light ? " \u265F" : " \u2659"
    @w_knight = @light_or_dark_font == :light ? " \u265E" : " \u2658"
    @w_bishop = @light_or_dark_font == :light ? " \u265D" : " \u2657"
    @w_rook = @light_or_dark_font == :light ? " \u265C" : " \u2656"
    @w_queen = @light_or_dark_font == :light ? " \u265B" : " \u2655"
    @w_king = @light_or_dark_font == :light ? " \u265A" : " \u2654"
  end

  def initial_black_minimalist_pieces
    @b_pawn = @light_or_dark_font == :light ? " \u2659" : " \u265F"
    @b_knight = @light_or_dark_font == :light ? " \u2658" : " \u265E"
    @b_bishop = @light_or_dark_font == :light ? " \u2657" : " \u265D"
    @b_rook = @light_or_dark_font == :light ? " \u2656" : " \u265C"
    @b_queen = @light_or_dark_font == :light ? " \u2655" : " \u265B"
    @b_king = @light_or_dark_font == :light ? " \u2654" : " \u265A"
  end

  def initial_white_checkerboard_pieces
    @w_pawn = "\033[37m \u265F \033[0m"
    @w_knight = "\033[37m \u265E \033[0m"
    @w_bishop = "\033[37m \u265D \033[0m"
    @w_rook = "\033[37m \u265C \033[0m"
    @w_queen = "\033[37m \u265B \033[0m"
    @w_king = "\033[37m \u265A \033[0m"
  end

  def initial_black_checkerboard_pieces
    @b_pawn = "\033[30m \u265F \033[0m"
    @b_knight = "\033[30m \u265E \033[0m"
    @b_bishop = "\033[30m \u265D \033[0m"
    @b_rook = "\033[30m \u265C \033[0m"
    @b_queen = "\033[30m \u265B \033[0m"
    @b_king = "\033[30m \u265A \033[0m"
  end

  # build a board with initial setup
  def set_up_board
    @board = Array.new(BOARD_HEIGHT) { Array.new(BOARD_WIDTH) { nil } }
    initial_board_letter_rows
    initial_board_minimalist_dashes
    initial_board_number_columns
  end

  # used by #initial_board to generate the rows of letters
  # at the top and bottom of the board
  def initial_board_letter_rows
    [1, 12].each do |row|
      @board[row][0] = BLANK_SPOT
      if @minimalist_or_checkerboard == :minimalist
        (0..7).each { |column| @board[row][column + 1] = ' ' + (column + 97).chr }
      elsif @minimalist_or_checkerboard == :checkerboard
        (0..7).each { |column| @board[row][column + 1] = ' ' + (column + 97).chr + ' ' }
      end
    end
  end

  # used by #initial_board to generate the minimalist dashes in the middle of the board
  def initial_board_minimalist_dashes
    (5..8).each { |row| @board[row] = Array.new(10) { MINIMALIST_DASH } }
  end

  # used by #initial board to generate the numbers bordering the playing field rows
  # overwrite some of the minimalist dashes generated by #initial_board_minimalist_dashes
  # add spaces to the right of the board for putting captured pieces next to
  def initial_board_number_columns
    (3..10).each { |row| @board[row][0] = ' ' + (row - 2).to_s + '  ' }
    (3..10).each { |row| @board[row][9] = '   ' + (row - 2).to_s + '  ' }
  end

  def to_s
    string = ''
    (0..BOARD_HEIGHT - 1).each do |row|
      (0..BOARD_WIDTH - 1).each { |column| string += @board[BOARD_HEIGHT - 1 - row][column].to_s }
      string += "\n"
    end
    string
  end

  # overwrite the 8x8 playing field section of the board using an 8x8 playing field input from Game
  # by accessing either nil or a piece from the playing field, and converting nil or the piece symbols
  # to Board constants that represent empty squares or the pieces
  def overwrite_playing_field(playing_field)
    (0..7).each do |column|
      (0..7).each do |row|
        @board[row + 3][column + 1] = if playing_field[column][row].nil?
                                        if @minimalist_or_checkerboard == :minimalist
                                          MINIMALIST_DASH
                                        elsif @minimalist_or_checkerboard == :checkerboard
                                          square(row, column)
                                        end
                                      else
                                        piece_as_string = playing_field[column][row].to_s
                                        piece = instance_variable_get("@#{piece_as_string}")
                                        if @minimalist_or_checkerboard == :minimalist
                                          piece
                                        elsif @minimalist_or_checkerboard == :checkerboard
                                          square(row, column, piece)
                                        end
                                      end
      end
    end
  end

  def square(row, column, piece = '   ')
    if row.even? && column.odd? || row.odd? && column.even?
      light_background_square(piece)
    else
      dark_background_square(piece)
    end
  end

  def light_background_square(piece)
    "\033[46m#{piece}\033[0m"
  end

  def dark_background_square(piece)
    "\033[44m#{piece}\033[0m"
  end

  # add the pieces from the Game 4x8 array of captured pieces to the board
  def add_captured_pieces(captured_pieces)
    (0..3).each do |row|
      (0..7).each do |column|
        next if captured_pieces[row][column].nil?

        place_captured_pieces_on_board(captured_pieces, row, column)
      end
    end
  end

  # used by add_captured_pieces to place the pieces
  def place_captured_pieces_on_board(captured_pieces, row, column)
    piece_as_string = captured_pieces[row][column].to_s
    piece = instance_variable_get("@#{piece_as_string}")
    [0, 1].include?(row) ? @board[row + 3][column + 10] = piece : @board[12 - row][column + 10] = piece
  end
end

# rubocop:enable Metrics/ClassLength
