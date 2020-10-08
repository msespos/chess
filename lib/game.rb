# frozen_string_literal: true

require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'player.rb'

# game class
class Game
  def initialize
    @board = Board.new
    @piece = Piece.new
    @player = Player.new
    @current_player = :white
    initial_playing_field
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

  def play
    puts 'Intro text and Intro board'
    puts @board
    play_turn
  end

  def play_turn
    move = @player.player_move
    start, finish = player_move_to_start_finish(move)
    move_piece(start, finish)
    @current_player = @current_player == :white ? :black : :white
    playing_field_to_board(@playing_field)
    puts @board
  end

  # transfer a playing field to the board by calling Board#overwrite_playing_field
  def playing_field_to_board(playing_field)
    @board.overwrite_playing_field(playing_field)
  end

  def player_move_to_start_finish(move)
    start = [move[0].ord - 97, move[1].to_i - 1]
    finish = [move[2].ord - 97, move[3].to_i - 1]
    [start, finish]
  end

  # move a piece or a pawn (capturing or not) given start and finish coordinates
  # castling, en passant and pawn promotion still need to be incorporated
  def move_piece(start, finish)
    return nil unless valid_move?(start, finish)

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

    path_method = path_method_from_piece(start_piece)
    @piece.send(path_method, start, finish, @playing_field)
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

  # used by #move_piece
  # check if there is a capture in the move by checking if there is a piece in the finish square
  # make the capture and return the piece if there is - otherwise return nil
  def capture(finish)
    return @playing_field[finish[0]][finish[1]] unless @playing_field[finish[0]][finish[1]].nil?

    nil
  end
end
