# frozen_string_literal: true

require 'pry'

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

  # play the whole game - not tested
  def play
    puts 'Intro text and Intro board'
    find_king
    display_board
    play_turn until game_over?
  end

  # send the current playing field to the board and print the board - not tested
  def display_board
    playing_field_to_board(@playing_field)
    puts @board
  end

  # will contain end conditions for the game eventually - not tested
  # currently set to loop #play_turn infinitely within #play
  def game_over?
    false
  end

  # used by #play to implement a full turn - not tested
  def play_turn
    puts @player.current_player_announcement(@current_player)
    start, finish = call_player_move_and_convert_it
    while move_piece(start, finish) == :invalid
      puts @player.invalid_move_message
      start, finish = call_player_move_and_convert_it
    end
    @current_player = @current_player == :white ? :black : :white
    display_board
  end

  # used by #play_turn - not tested
  # call Player#player_move and convert the resulting move to [start, finish] format
  def call_player_move_and_convert_it
    move = @player.player_move
    player_move_to_start_finish(move)
  end

  # used by #call_player_move_and_convert_it
  # convert an algebraic notation move to [start, finish] format
  def player_move_to_start_finish(move)
    start = [move[0].ord - 97, move[1].to_i - 1]
    finish = [move[2].ord - 97, move[3].to_i - 1]
    [start, finish]
  end

  def find_king
    current_king = @current_player[0] + '_king'
    current_king_square = []
    @playing_field.each_with_index do |row, row_index|
      row.each_index do |column_index|
        if @playing_field[row_index][column_index] == current_king.to_sym
          current_king_square = [row_index, column_index]
        end
      end
    end
    current_king_square
  end

  #   call the king square finish
  #   for each square on the board
  #     call it start
  #     if valid_move?(start, finish)
  #       return true (king is in check)
  #     end
  #   end
  #   false (king is not in check)
  # end

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
  # check if the move is valid by checking if the start and finish squares are different
  # and checking if the start and finish squares are on the playing field
  # and checking if the start and finish spaces are valid (same color, not nil)
  # and looking up the appropriate Piece path method using path_method_from_piece
  # and calling it on @piece
  def valid_move?(start, finish)
    return false if start == finish

    return false unless on_playing_field?(start) && on_playing_field?(finish)

    return false unless start_and_finish_spaces_valid?(start, finish)

    return false unless correct_color?(@current_player, start)

    start_piece = @playing_field[start[0]][start[1]]
    path_method = path_method_from_piece(start_piece)
    @piece.send(path_method, start, finish, @playing_field)
  end

  # used by #valid_move? to check if the starting piece is the same color as the current player
  def correct_color?(current_player, start)
    start_piece = @playing_field[start[0]][start[1]]
    start_piece[0] == current_player[0]
  end

  # used by #valid_move? to check if a set of coordinates is on the board
  def on_playing_field?(coordinates)
    coordinates[0] >= 0 && coordinates[0] <= 7 && coordinates[1] >= 0 && coordinates[1] <= 7
  end

  # used by valid_move? to check that the start and finish spaces are valid
  # check if start space is occupied
  # and call #finish_space_valid? on the start and finish pieces
  def start_and_finish_spaces_valid?(start, finish)
    start_piece = @playing_field[start[0]][start[1]]
    finish_piece = @playing_field[finish[0]][finish[1]]
    return false if start_piece.nil?

    return false unless finish_space_valid?(start_piece, finish_piece)

    true
  end

  # used by start_and_finish_spaces_valid?
  # check if the piece in the finish square is nil or not
  # or if the pieces in the start and finish square are the same color or not
  def finish_space_valid?(start_piece, finish_piece)
    if finish_piece.nil?
      true
    else
      start_piece[0] != finish_piece[0]
    end
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

  # used by #play_turn
  # transfer a playing field to the board by calling Board#overwrite_playing_field
  def playing_field_to_board(playing_field)
    @board.overwrite_playing_field(playing_field)
  end
end
