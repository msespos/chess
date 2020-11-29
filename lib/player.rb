# frozen_string_literal: true

# rubocop:disable Style/NumericPredicate

# player class
class Player
  PROMPTS = { move: 'Please enter your move.',
              piece: "You can promote a pawn!\nPlease enter n, b, r or q to promote.",
              number_of_players: 'How many are playing? 1 or 2?',
              minimalist_or_checkerboard: "Would you like a minimalist or checkerboard design?\n\
                                           Please enter m or c.",
              bottom_color_one_player: "Would you like to play as white or black?\nPlease enter w or b.",
              bottom_color_two_player: "Would you like white or black at the bottom of the board?\n\
                                        Please enter w or b.",
              light_or_dark_font: "Is your current terminal font light or dark?\nPlease enter l or d.\n\
                                  (This will allow for the best display of the minimalist board.)" }.freeze

  INPUT_FORMATS = { piece: %w[n b r q],
                    number_of_players: %w[1 2],
                    minimalist_or_checkerboard: %w[m c],
                    bottom_color_one_player: %w[w b],
                    bottom_color_two_player: %w[w b],
                    light_or_dark_font: %w[l d] }.freeze

  INVALID_MOVE_MESSAGES = { move: 'move',
                            piece: 'piece',
                            number_of_players: 'number of players',
                            minimalist_or_checkerboard: 'design',
                            bottom_color_one_player: 'color',
                            bottom_color_two_player: 'color',
                            light_or_dark_font: 'type' }.freeze

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
    else
      INPUT_FORMATS[type].include?(input.downcase)
    end
  end

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
