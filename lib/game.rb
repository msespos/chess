# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength

require_relative 'game_modules/move_validation'
require_relative 'game_modules/check_validation'
require_relative 'game_modules/checkmate_validation'
require_relative 'game_modules/stalemate_validation'
require_relative 'game_modules/pawn_promotion'
require_relative 'game_modules/en_passant'
require_relative 'game_modules/castling'
require_relative 'game_modules/save_load'
require_relative 'game_modules/one_player_version'

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
    @current_player = :white
    @previous_move = nil
    @resignation = false
    @captured_pieces = Array.new(4) { Array.new(8) { nil } }
    @en_passant_column = nil
    @moved_castling_pieces = []
    initial_playing_field
  end

  # play the whole game
  def play
    intro
    obtain_initial_player_input
    @board = Board.new(@bottom_color, @minimalist_or_checkerboard, @light_or_dark_font)
    display_board
    play_turn until game_over?
    end_of_game_announcement
  end

  private

  # set up the playing field for the start of the game
  def initial_playing_field
    @playing_field = Array.new(8) { Array.new(8) { nil } }
    @playing_field[0] = %i[w_rook w_knight w_bishop w_queen w_king w_bishop w_knight w_rook]
    @playing_field[1] = %i[w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn]
    @playing_field[6] = %i[b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn]
    @playing_field[7] = %i[b_rook b_knight b_bishop b_queen b_king b_bishop b_knight b_rook]
    @playing_field = @playing_field.transpose
  end

  # used throughout the Game class and modules to define the other player from the current one
  def other_player
    @current_player == :white ? :black : :white
  end

  # used by #play to make integration testing easier
  def intro
    @player.intro
  end

  # used by #play to get the initial input from the user at the start of the game
  def obtain_initial_player_input
    @number_of_players = number_of_players
    @bottom_color = bottom_color
    @minimalist_or_checkerboard = minimalist_or_checkerboard
    @light_or_dark_font = light_or_dark_font
  end

  # used by obtain_initial_player_input to get the number of players
  def number_of_players
    @number_of_players = @player.user_input(:number_of_players).to_i
  end

  # used by obtain_initial_player_input to get the bottom color in the display
  def bottom_color
    if @number_of_players == 1
      @player.user_input(:bottom_color_one_player) == 'w' ? :white : :black
    elsif @number_of_players == 2
      @player.user_input(:bottom_color_two_player) == 'w' ? :white : :black
    end
  end

  # used by obtain_initial_player_input to determine which board design will be used
  def minimalist_or_checkerboard
    @minimalist_or_checkerboard = if @player.user_input(:minimalist_or_checkerboard) == 'm'
                                    :minimalist
                                  else
                                    :checkerboard
                                  end
  end

  # used by obtain_initial_player_input for aligning minimalist boards according to the terminal font
  def light_or_dark_font
    return :light unless @minimalist_or_checkerboard == :minimalist

    @light_or_dark_font = @player.user_input(:light_or_dark_font) == 'l' ? :light : :dark
  end

  # used by #play to send the current playing field to the board and print the board
  def display_board
    playing_field = @bottom_color == :white ? @playing_field : invert_playing_field(@playing_field)
    @board.overwrite_playing_field(playing_field)
    captured_pieces = @bottom_color == :white ? @captured_pieces : invert_captured_pieces(@captured_pieces)
    @board.add_captured_pieces(captured_pieces)
    print "\e[H\e[2J" # clear the screen
    puts previous_player_move unless @previous_move.nil?
    puts @board
  end

  # used by #display_board to rotate the playing_field 180 degrees
  def invert_playing_field(playing_field)
    inverted = Array.new(8) { Array.new(8) { nil } }
    (0..7).each do |column|
      (0..7).each do |row|
        inverted[column][row] = playing_field[7 - column][7 - row]
      end
    end
    inverted
  end

  # used by #display_board to flip the top and bottom displays of captured pieces
  def invert_captured_pieces(captured_pieces)
    inverted = Array.new(4) { Array.new(8) { nil } }
    (0..3).each do |row|
      (0..7).each do |column|
        inverted = fill_inverted_pieces_array(row, column, captured_pieces, inverted)
      end
    end
    inverted
  end

  # used by #invert_captured_pieces to populate the inverted pieces array
  def fill_inverted_pieces_array(row, column, captured_pieces, inverted)
    if [0, 1].include?(row)
      inverted[row][column] = captured_pieces[row + 2][column]
    elsif [2, 3].include?(row)
      inverted[row][column] = captured_pieces[row - 2][column]
    end
    inverted
  end

  # used by #display_board to show the previous player's move
  def previous_player_move
    "#{other_player.capitalize} has played #{@previous_move}."
  end

  # used by #play to implement a full turn
  def play_turn
    intro_announcements
    if @number_of_players == 2 || @current_player == @bottom_color
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

  # used by #play_turn to implement a player turn
  def player_takes_a_turn
    move = player_move
    return :quit_turn if resignation?(move)

    return :quit_turn if save_or_load(move)

    return :quit_turn if help(move)

    start, finish = player_move_to_start_finish(move)
    make_move_when_not_invalid(start, finish)
    @previous_move = move
  end

  # used by #play_turn and to make integration testing easier
  # get the player's move using Player#player_move
  def player_move
    @player.user_input(:move)
  end

  # used by #play_turn and #make_move_when_not_invalid
  # check if the player has resigned
  def resignation?(move)
    return unless move.downcase == 'q'

    if player_resignation_status == 'y'
      @resignation = true
    else
      @resignation = false
      puts 'Back to the game!'
      display_board
    end
    true
  end

  # used by #resignation? and to make integration testing easier
  def player_resignation_status
    @player.user_input(:resignation)
  end

  # used by #play_turn to save or load the game and then display the current board
  def save_or_load(move)
    return unless %w[s l].include?(move.downcase)

    move.downcase == 's' ? save_game : load_game
    display_board
    true
  end

  # used by #play_turn to display the help screen and then display the current board
  def help(move)
    return unless %w[h help].include?(move.downcase)

    @player.help
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
    update_moved_castling_pieces(start)
    update_en_passant_column(start, finish)
    [start, finish]
  end

  # used by #make_move_when_not_invalid
  # move a piece or a pawn (capturing or not) given start and finish coordinates
  # make a copy of the playing field in case the king is in check and revert
  # to that copy if the king is in check as we do not want the king to actually move
  # unless the the third parameter is true - used by #escape_squares_available? to indicate
  # that the method is being used to check a king moving out of check,
  # in which case we do want the king to actually move in this method -
  # (another copy of the playing field is similarly made and used in #escape_squares_available?)
  # the fourth parameter is used to turn adding to captured pieces off for when this
  # method is used just to test moves (for checking stalemate and checkmate), to avoid
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
    @current_player = other_player
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
    puts @player.ending_text(@current_player, type_of_ending)
    puts 'Thanks for playing Chess! See you next time. :)'
  end
end

# rubocop:enable Metrics/ClassLength
