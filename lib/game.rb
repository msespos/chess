# frozen_string_literal: true

require 'pry'
require_relative 'move_validation'
require_relative 'check_validation'
require_relative 'checkmate_validation'
require_relative 'stalemate_validation'

# game class
class Game
  include MoveValidation
  include CheckValidation
  include CheckmateValidation
  include StalemateValidation

  def initialize
    @board = Board.new
    @piece = Piece.new
    @player = Player.new
    @current_player = :white
    @resignation = false
    @captured_pieces = Array.new(4) { Array.new(8) { nil } }
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

  # play the whole game
  def play
    puts @player.intro_text
    display_board
    play_turn until game_over?
    end_of_game_announcement
  end

  # used by #play to send the current playing field to the board and print the board
  def display_board
    @board.overwrite_playing_field(@playing_field)
    @board.add_captured_pieces(@captured_pieces)
    puts @board
  end

  # used by #play to implement a full turn
  def play_turn
    puts @player.in_check_announcement(@current_player) if in_check?
    puts @player.current_player_announcement(@current_player)
    move = obtain_player_move
    return if resignation?(move)

    start, finish = player_move_to_start_finish(move)
    make_move_when_not_invalid(start, finish)
    @current_player = @current_player == :white ? :black : :white
    display_board
  end

  # used by #play_turn
  # get the player's move using Player#player_move
  def obtain_player_move
    @player.player_move
  end

  # used by #play_turn and make_move_when_not_invalid
  # check if the player has resigned
  def resignation?(move)
    @resignation = true if move.downcase == 'q'
  end

  # used by #play_turn
  # convert an algebraic notation move to [start, finish] format
  def player_move_to_start_finish(move)
    start = [move[0].ord - 97, move[1].to_i - 1]
    finish = [move[2].ord - 97, move[3].to_i - 1]
    [start, finish]
  end

  # used by #play_turn to check validity of move and redo it until it is valid
  def make_move_when_not_invalid(start, finish)
    while move_piece(start, finish) == :invalid
      puts @player.invalid_move_message
      move = obtain_player_move
      return if resignation?(move)

      start, finish = player_move_to_start_finish(move)
    end
  end

  # used by #make_move_when_not_invalid
  # move a piece or a pawn (capturing or not) given start and finish coordinates
  # castling, en passant and pawn promotion still need to be incorporated
  def move_piece(start, finish, checking_move_out_of_check = false)
    return :invalid unless valid_move?(start, finish, @current_player)

    # make a copy of the playing field in case the player is moving into check
    playing_field_before_move = @playing_field.clone.map(&:clone)
    captured = reassign_squares(start, finish)
    if in_check?
      # revert to the copy of the playing field made before the move into check
      @playing_field = playing_field_before_move unless checking_move_out_of_check
      return :invalid
    end
    add_to_captured_pieces(captured) unless captured.nil?
  end

  # used by #move_piece
  # reassign the squares necessary to make the move and capture, if also a capture
  def reassign_squares(start, finish)
    temp = @playing_field[start[0]][start[1]]
    @playing_field[start[0]][start[1]] = nil
    captured = capture(finish)
    @playing_field[finish[0]][finish[1]] = temp
    captured
  end

  # used by #reassign_squares
  # check if there is a capture in the move by checking if there is a piece in the finish square
  # make the capture and return the piece if there is - otherwise return nil
  def capture(finish)
    return @playing_field[finish[0]][finish[1]] unless @playing_field[finish[0]][finish[1]].nil?

    nil
  end

  # used by #move_piece to add any captured piece to the @captured_pieces array
  def add_to_captured_pieces(piece)
    if piece[0] == 'b'
      if @captured_pieces[0].all?
        @captured_pieces[1].unshift(piece)
        @captured_pieces[1].pop
      else
        @captured_pieces[0].unshift(piece)
        @captured_pieces[0].pop
      end
    else
      if @captured_pieces[3].all?
        @captured_pieces[2].unshift(piece)
        @captured_pieces[2].pop
      else
        @captured_pieces[3].unshift(piece)
        @captured_pieces[3].pop
      end
    end
  end

  # used by #play to assess if the game is over
  def game_over?
    in_checkmate? || in_stalemate? || @resignation
  end

  # used by #play at the end of the game
  def end_of_game_announcement
    type_of_ending = if in_checkmate?
                       :checkmate
                     elsif in_stalemate?
                       :stalemate
                     else
                       :resignation
                     end
    puts @player.end_of_game_announcement(@current_player, type_of_ending)
  end
end
