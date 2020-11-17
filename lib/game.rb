# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

require 'pry'
require_relative 'move_validation'
require_relative 'check_validation'
require_relative 'checkmate_validation'
require_relative 'stalemate_validation'
require_relative 'pawn_promotion'
require_relative 'en_passant'
require_relative 'castling'

# game class
class Game
  include MoveValidation
  include CheckValidation
  include CheckmateValidation
  include StalemateValidation
  include PawnPromotion
  include EnPassant
  include Castling

  def initialize
    @board = Board.new
    @piece = Piece.new
    @player = Player.new
    @current_player = :white
    @resignation = false
    @captured_pieces = Array.new(4) { Array.new(8) { nil } }
    @en_passant_column = nil
    update_castling_piece_states(:initial)
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
    move = player_move
    return if resignation?(move)

    start, finish = player_move_to_start_finish(move)
    make_move_when_not_invalid(start, finish)
    @current_player = @current_player == :white ? :black : :white
    display_board
    promote_pawn if pawn_to_promote
  end

  # used by #play_turn
  # get the player's move using Player#player_move
  def player_move
    @player.user_input(:move)
  end

  # used by #play_turn and #make_move_when_not_invalid
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
      puts @player.invalid_move_message(:move)
      move = player_move
      return if resignation?(move)

      start, finish = player_move_to_start_finish(move)
    end
    update_castling_piece_states(:during, start)
    update_en_passant_column(start, finish)
  end

  # used by #make_move_when_not_invalid
  # move a piece or a pawn (capturing or not) given start and finish coordinates
  # castling, en passant and pawn promotion still need to be incorporated
  # make a copy of the playing field in case the king is in check and revert
  # to that copy if the king is in check as we do not want the king to actually move
  # except that the third parameter used by #escape_squares_available? to indicate
  # that the method is being used to check a king moving out of check,
  # in which case we do want the king to actually move in this method
  # (another copy of the playing field is similarly made and used in #escape_squares_available?)
  def move_piece(start, finish, checking_move_out_of_check = false, checking_stalemate = false)
    if move_is_white_castle?(start, finish, :king) && white_can_kingside_castle?
      white_castle(:king)
      return
    elsif move_is_white_castle?(start, finish, :queen) && white_can_queenside_castle?
      white_castle(:queen)
      return
    elsif move_is_black_castle?(start, finish, :king) && black_can_kingside_castle?
      black_castle(:king)
      return
    elsif move_is_black_castle?(start, finish, :queen) && black_can_queenside_castle?
      black_castle(:queen)
      return
    end
    return :invalid unless valid_move?(start, finish, @current_player)

    # make a copy of the playing field in case the player is moving into check
    playing_field_before_move = @playing_field.clone.map(&:clone)
    captured = reassign_squares(start, finish)
    if in_check?
      # revert to the copy of the playing field made before the move into check
      # do not revert if actually checking a king move made out of check
      # as in that case we want to keep the playing field as is
      @playing_field = playing_field_before_move unless checking_move_out_of_check
      return :invalid
    end
    add_to_captured_pieces(captured) unless captured.nil? || checking_stalemate
  end

  # used by #move_piece
  # reassign the squares necessary to make the move and capture, if also a capture
  # if in the case of an en passant move, make the move and capture en passant
  def reassign_squares(start, finish)
    if !@en_passant_column.nil? && meets_en_passant_conditions?(start, finish, @current_player)
      move_and_capture(start, finish, true)
    else
      move_and_capture(start, finish)
    end
  end

  # used by #reassign_square to move and capture the pieces, standard or en passant
  def move_and_capture(start, finish, en_passant = false)
    temp = @playing_field[start[0]][start[1]]
    @playing_field[start[0]][start[1]] = nil
    captured = en_passant_or_standard_capture(start, finish, en_passant)
    @playing_field[finish[0]][finish[1]] = temp
    @playing_field[finish[0]][start[1]] = nil if en_passant == true

    captured
  end

  # used by #move_and_capture to select and execute a standard or en passant capture
  def en_passant_or_standard_capture(start, finish, en_passant)
    en_passant == true ? @playing_field[finish[0]][start[1]] : standard_capture(finish)
  end

  # used by #reassign_squares
  # check if there is a capture in the move by checking if there is a piece in the finish square
  # make the capture and return the piece if there is - otherwise return nil
  def standard_capture(finish)
    return @playing_field[finish[0]][finish[1]] unless @playing_field[finish[0]][finish[1]].nil?

    nil
  end

  # used by #move_piece to add any captured piece to the @captured_pieces array
  # after checking the color of the piece, adds to the first row of the array
  # until it is full, then adds to the second row of the array
  def add_to_captured_pieces(piece)
    first_row = piece[0] == 'b' ? 0 : 2
    if @captured_pieces[first_row].all?
      @captured_pieces[first_row + 1].unshift(piece).pop
    else
      @captured_pieces[first_row].unshift(piece).pop
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

# rubocop:enable Metrics/ClassLength
