# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

# board class
class Board
  MINIMALIST_DASH = ' -'
  PLAYING_FIELD_SIDE = 8
  BOARD_V_SHIFT = 3
  BOARD_H_SHIFT = 1
  CAPTURED_PIECES_HEIGHT = 4
  CAPTURED_PIECES_WIDTH = 8
  BOTTOM_LETTER_ROW = 1
  TOP_LETTER_ROW = 12
  LEFT_NUMBER_COLUMN = 0
  RIGHTWARDS_LETTER_SHIFT = 97
  SHADED_PIECES = { pawn: " \u265F",
                    knight: " \u265E",
                    bishop: " \u265D",
                    rook: " \u265C",
                    queen: " \u265B",
                    king: " \u265A" }.freeze
  OUTLINED_PIECES = { pawn: " \u2659",
                      knight: " \u2658",
                      bishop: " \u2657",
                      rook: " \u2656",
                      queen: " \u2655",
                      king: " \u2654" }.freeze

  def initialize(bottom_color, minimalist_or_checkerboard, light_or_dark_font)
    @bottom_color = bottom_color
    @minimalist_or_checkerboard = minimalist_or_checkerboard
    @light_or_dark_font = light_or_dark_font
    @pieces = {}
    set_up_pieces
    set_up_board
  end

  # used by Game to overwrite the 8x8 playing field section of the board using an 8x8
  # playing field input from Game by accessing either nil or a piece from the playing field,
  # and converting nil or the piece symbols to Board constants that represent empty squares or the pieces
  def overwrite_playing_field(playing_field)
    (0..PLAYING_FIELD_SIDE - 1).each do |column|
      (0..PLAYING_FIELD_SIDE - 1).each do |row|
        @board[row + BOARD_V_SHIFT][column + BOARD_H_SHIFT] = if playing_field[column][row].nil?
                                                                empty_square(row, column)
                                                              else
                                                                square_with_piece(row, column, playing_field)
                                                              end
      end
    end
  end

  # used by Game to add the pieces from the Game 4x8 array of captured pieces to the board
  def add_captured_pieces(captured_pieces)
    (0..CAPTURED_PIECES_HEIGHT - 1).each do |row|
      (0..CAPTURED_PIECES_WIDTH - 1).each do |column|
        next if captured_pieces[row][column].nil?

        place_captured_pieces_on_board(captured_pieces, row, column)
      end
    end
  end

  private

  # used by #initialize to set up the codes for the pieces depending on the chosen style
  def set_up_pieces
    if @minimalist_or_checkerboard == :minimalist
      minimalist_pieces(:white)
      minimalist_pieces(:black)
    elsif @minimalist_or_checkerboard == :checkerboard
      checkerboard_pieces(:white)
      checkerboard_pieces(:black)
    end
  end

  # used by #set_up_pieces to set up the codes for the pieces in a minimalist board
  def minimalist_pieces(color)
    if color == :white
      pieces = @light_or_dark_font == :light ? SHADED_PIECES : OUTLINED_PIECES
    elsif color == :black
      pieces = @light_or_dark_font == :light ? OUTLINED_PIECES : SHADED_PIECES
    end
    prefix = color == :white ? 'w_' : 'b_'
    pieces.each do |piece_as_symbol, code|
      piece = prefix + piece_as_symbol.to_s
      @pieces[piece] = code
    end
  end

  # used by #set_up_pieces to set up the codes for the pieces in a checkerboard board
  def checkerboard_pieces(color)
    piece_prefix = color == :white ? 'w_' : 'b_'
    code_prefix = color == :white ? "\033[37m" : "\033[30m"
    code_suffix = " \033[0m"
    SHADED_PIECES.each do |piece_as_symbol, code|
      piece = piece_prefix + piece_as_symbol.to_s
      full_code = code_prefix + code + code_suffix
      @pieces[piece] = full_code
    end
  end

  # used by #initialize to build a board with the initial setup
  def set_up_board
    @board = Array.new(PLAYING_FIELD_SIDE + 2 * BOARD_V_SHIFT) do
      Array.new(PLAYING_FIELD_SIDE + CAPTURED_PIECES_WIDTH + 2 * BOARD_H_SHIFT) { nil }
    end
    letter_rows
    number_columns
  end

  # used by #initial_board to generate the rows of letters at the top
  # and bottom of the board, with direction depending on the bottom color
  def letter_rows
    spacing = @minimalist_or_checkerboard == :minimalist ? nil : ' '
    [BOTTOM_LETTER_ROW, TOP_LETTER_ROW].each do |row|
      (0..PLAYING_FIELD_SIDE - 1).each do |column|
        @board[row][0] = '    '
        @bottom_color == :white ? rightwards_letters(spacing, row, column) : leftwards_letters(spacing, row, column)
      end
    end
  end

  # used by #letter_rows to print the letters if white is at the bottom
  def rightwards_letters(spacing, row, column)
    @board[row][column + 1] = ' ' + (column + RIGHTWARDS_LETTER_SHIFT).chr + spacing.to_s
  end

  # used by #letter_rows to print the letters if black is at the bottom
  def leftwards_letters(spacing, row, column)
    @board[row][column + 1] = ' ' +
                              (RIGHTWARDS_LETTER_SHIFT + PLAYING_FIELD_SIDE - 1 - column).chr +
                              spacing.to_s
  end

  # used by #upwards_numbers and #downwards_numbers and #to_s
  def playing_field_and_v_shift
    PLAYING_FIELD_SIDE + BOARD_V_SHIFT
  end

  # used by #set_up_board to generate the numbers bordering the playing field rows
  # add spaces to the right of the board for putting captured pieces next to
  def number_columns
    @bottom_color == :white ? upwards_numbers : downwards_numbers
  end

  # used by #number_columns to print the numbers if white is at the bottom
  def upwards_numbers
    (BOARD_V_SHIFT..playing_field_and_v_shift - 1).each do |row|
      @board[row][LEFT_NUMBER_COLUMN] = ' ' + (row - 2).to_s + '  '
      @board[row][right_number_column] = '   ' + (row - 2).to_s + '  '
    end
  end

  # used by #upwards_numbers and #downwards_numbers
  def right_number_column
    LEFT_NUMBER_COLUMN + PLAYING_FIELD_SIDE + 1
  end

  # used by #number_columns to print the numbers if black is at the bottom
  def downwards_numbers
    (BOARD_V_SHIFT..playing_field_and_v_shift - 1).each do |row|
      label = PLAYING_FIELD_SIDE + BOARD_V_SHIFT - row
      @board[row][LEFT_NUMBER_COLUMN] = ' ' + label.to_s + '  '
      @board[row][right_number_column] = '   ' + label.to_s + '  '
    end
  end

  def to_s
    string = "\n"
    (0..playing_field_and_v_shift + 1).each do |row|
      (0..PLAYING_FIELD_SIDE + CAPTURED_PIECES_WIDTH + 2 * BOARD_H_SHIFT - 1).each do |column|
        string += @board[playing_field_and_v_shift + 1 - row][column].to_s
      end
      string += "\n"
    end
    string
  end

  # used by #overwrite_playing_field to generate a minimalist dash or checkerboard square
  def empty_square(row, column)
    @minimalist_or_checkerboard == :minimalist ? MINIMALIST_DASH : checkerboard_square(row, column)
  end

  # used by #overwrite_playing_field to generate a minimalist or checkerboard square with a piece
  def square_with_piece(row, column, playing_field)
    piece_as_string = playing_field[column][row].to_s
    piece = @pieces[piece_as_string]
    @minimalist_or_checkerboard == :minimalist ? piece : checkerboard_square(row, column, piece)
  end

  # used by #empty_square and #square_with_piece to generate the checkerboard squares
  def checkerboard_square(row, column, piece = '   ')
    if row.even? && column.odd? || row.odd? && column.even?
      board_square(piece, :light)
    else
      board_square(piece, :dark)
    end
  end

  # used by #checkerboard_square to generate a light background square with piece
  def board_square(piece, light_or_dark)
    light_or_dark == :light ? "\033[46m#{piece}\033[0m" : "\033[45m#{piece}\033[0m"
  end

  # used by #add_captured_pieces to place the pieces
  def place_captured_pieces_on_board(captured_pieces, row, column)
    piece_as_string = captured_pieces[row][column].to_s
    piece = @pieces[piece_as_string]
    [0, 1].include?(row) ? captured_rows(piece, row, column, :black) : captured_rows(piece, row, column, :white)
  end

  # used by #place_captured_pieces_on_board to set up the captured piece rows
  def captured_rows(piece, row, column, piece_color)
    row_shift = piece_color == :black ? row + 3 : 12 - row
    square_order = row.even? && column.odd? || row.odd? && column.even? ? :first : :second
    light_or_dark = light_or_dark_based_on_order_and_color(piece_color, square_order)
    @board[row_shift][column + 10] = captured_square(piece, light_or_dark)
  end

  # used by #captured_rows to determine if the square will be light or dark
  def light_or_dark_based_on_order_and_color(piece_color, square_order)
    if square_order == :first
      piece_color == :black ? :light : :dark
    elsif square_order == :second
      piece_color == :black ? :dark : :light
    end
  end

  # used by #captured_rows to set up each captured piece square
  def captured_square(piece, light_or_dark)
    @minimalist_or_checkerboard == :minimalist ? piece : board_square(piece, light_or_dark)
  end
end

# rubocop:enable Metrics/ClassLength
