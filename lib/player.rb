# frozen_string_literal: true

# rubocop:disable Style/NumericPredicate

require_relative 'type_hashes'
require_relative 'intro'

# player class
class Player
  include TypeHashes
  include Intro

  # used by Game#play
  def intro_text
    'Intro text and Intro board'
  end

  # used by Game#play_turn
  def in_check_announcement(current_player)
    "#{current_player.capitalize} is in check!"
  end

  # used by Game#play_turn
  def current_player_announcement(current_player)
    "It is #{current_player.capitalize}\'s turn."
  end

  # used by Game#player_move and Game#promote_pawn to get the player's input
  # and check it, prompting and re-obtaining if invalid input is entered
  def user_input(type)
    input = obtain_user_input(type)
    until input_in_correct_format?(input, type)
      puts invalid_move_message(type)
      input = obtain_user_input(type)
    end
    input
  end

  # used by #user_input to get the player's move before checking it
  def obtain_user_input(type)
    puts PROMPTS[type]
    gets.chomp
  end

  # used by #user_input to check if the move is in algebraic notation (e.g. a1a3),
  # or if type is :piece, to check that the piece is one of n, b, r, and q
  def input_in_correct_format?(input, type)
    if type == :move
      move_in_correct_format?(input)
    elsif type == :number_of_players
      %w[1 2].include?(input)
    else
      INPUT_FORMATS[type].include?(input.downcase)
    end
  end

  # used by #input_in_correct_format? to test the move for the correct format
  def move_in_correct_format?(input)
    return true if %w[q s l].include?(input.downcase)

    return false if input.length != 4

    (input =~ /[a-h][1-8][a-h][1-8]/) == 0
  end

  # used by #user_input as the message for an invalid move
  def invalid_move_message(type)
    entry = INVALID_MOVE_MESSAGES[type]
    "That is not a valid #{entry}! Please enter a valid #{entry}."
  end

  # used by Game#end_of_game_announcement
  def end_of_game_announcement(current_player, type_of_ending)
    winner = current_player == :white ? :black : :white
    if type_of_ending == :checkmate
      "Checkmate! #{winner.capitalize} wins!"
    elsif type_of_ending == :stalemate
      "#{current_player.capitalize} is in stalemate! It's a draw!"
    else
      "#{current_player.capitalize} resigns! #{winner.capitalize} wins!"
    end
  end
end

# rubocop:enable Style/NumericPredicate
