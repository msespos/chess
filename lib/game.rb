# frozen_string_literal: true

require 'pry'
require_relative 'move_validation'
require_relative 'check_and_mate_validation'

# game class
class Game
  include MoveValidation
  include CheckAndMateValidation

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
    display_board
    play_turn until game_over?
    puts 'Game Over'
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
    p in_check?
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

  # move a piece or a pawn (capturing or not) given start and finish coordinates
  # castling, en passant and pawn promotion still need to be incorporated
  def move_piece(start, finish)
    return :invalid unless valid_move?(start, finish, @current_player)

    # make a copy of the playing field in case the player is moving into check
    playing_field_before_move = @playing_field.clone.map(&:clone)
    temp = @playing_field[start[0]][start[1]]
    @playing_field[start[0]][start[1]] = nil
    captured = capture(finish)
    @playing_field[finish[0]][finish[1]] = temp
    if in_check?
      # revert to the copy of the playing field made before the move into check
      @playing_field = playing_field_before_move
      return :invalid
    end
    captured
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
