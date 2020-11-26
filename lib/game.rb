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
require_relative 'save_load'
require_relative 'one_player_version'

# game class
class Game
  include MoveValidation
  include CheckValidation
  include CheckmateValidation
  include StalemateValidation
  include PawnPromotion
  include EnPassant
  include Castling
  include SaveLoad
  include OnePlayerVersion

  def initialize
    @piece = Piece.new
    @player = Player.new
    @number_of_players = nil
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
    @number_of_players = number_of_players
    @board = Board.new(minimalist_or_checkerboard, white_or_black_on_bottom, light_or_dark_background)
    display_board
    play_turn until game_over?
    end_of_game_announcement
  end

  def minimalist_or_checkerboard
    @player.user_input(:minimalist_or_checkerboard) == 'm' ? :minimalist : :checkerboard
  end

  def white_or_black_on_bottom
    if @number_of_players == 1
      @player.user_input(:white_or_black_on_bottom) == 'w' ? :white : :black
    end
  end

  def light_or_dark_background
    @player.user_input(:light_or_dark_font) == 'l' ? :light : :dark
  end

  def number_of_players
    @player.user_input(:number_of_players).to_i
  end

  # used by #play to send the current playing field to the board and print the board
  def display_board
    @board.overwrite_playing_field(@playing_field)
    @board.add_captured_pieces(@captured_pieces)
    puts @board
  end

  # used by #play to implement a full turn
  def play_turn
    intro_announcements
    if @number_of_players == 2 || @current_player == :white
      return if player_takes_a_turn == :quit_turn
    else
      computer_takes_a_turn
    end
    complete_turn
  end

  # used by #play_turn
  def intro_announcements
    puts @player.in_check_announcement(@current_player) if in_check?
    puts @player.current_player_announcement(@current_player)
  end

  def player_takes_a_turn
    move = player_move
    return :quit_turn if resignation?(move)

    return :quit_turn if save_or_load(move)

    start, finish = player_move_to_start_finish(move)
    make_move_when_not_invalid(start, finish)
    [start, finish]
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

  def save_or_load(move)
    return unless move.downcase == 's' || move.downcase == 'l'

    move.downcase == 's' ? save_game : load_game
    display_board
    true
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

      start, finish = player_move_to_start_finish(move)
    end
    update_castling_piece_states(:during, start)
    update_en_passant_column(start, finish)
    [start, finish]
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
  # and the fourth parameter is used to turn adding to captured pieces off for when
  # this method is used just to test moves (for checking stalemate and checkmate) to avoid
  # pieces being accidentally displayed that have only been checked and not actually captured
  def move_piece(start, finish, checking_move_out_of_check = false, not_adding_captures = false)
    return if check_for_and_castle(start, finish) == :castled

    return :invalid unless valid_move?(start, finish, @current_player)

    # make a copy of the playing field in case the player is moving into check
    playing_field_before_move = @playing_field.clone.map(&:clone)
    captured = reassign_squares(start, finish)
    if in_check?
      restore_playing_field(playing_field_before_move, checking_move_out_of_check)
      return :invalid
    end
    add_to_captured_pieces(captured) unless captured.nil? || not_adding_captures
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

  # used by #move_piece to restore the playing field
  # to the copy of the playing field made before the move into check
  # do not restore if actually checking a king move made out of check
  # as in that case we want to keep the playing field as is
  def restore_playing_field(playing_field_before_move, checking_move_out_of_check)
    @playing_field = playing_field_before_move unless checking_move_out_of_check
  end

  # used by #move_piece to add any captured piece to the @captured_pieces array
  # after checking the color of the piece, adds to the first row of the array
  # until it is full, then adds to the second row of the array
  def add_to_captured_pieces(piece)
    first_row = piece[0] == 'b' ? 0 : 2
    row_increment = @captured_pieces[first_row].all? ? 1 : 0
    @captured_pieces[first_row + row_increment].unshift(piece).pop
  end

  # used by #play_turn
  def complete_turn
    @current_player = @current_player == :white ? :black : :white
    display_board
    promote_pawn if pawn_to_promote
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
