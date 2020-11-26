# frozen_string_literal: true

# player class
class Player
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
    until input_in_right_format?(input, type)
      puts invalid_move_message(type)
      input = obtain_user_input(type)
    end
    input
  end

  # used by #user_input to get the player's move before checking it
  def obtain_user_input(type)
    if type == :move
      puts 'Please enter your move.'
    elsif type == :piece
      puts "You can promote a pawn!\nPlease enter n, b, r or q to promote."
    elsif type == :number_of_players
      puts 'How many are playing? 1 or 2?'
    elsif type == :minimalist_or_checkerboard
      puts "Would you like a minimalist or checkerboard design?\nPlease enter m or c."
    elsif type == :white_or_black_start
      puts "Would you like to play as white or black?\nPlease enter w or b."
    elsif type == :light_or_dark_font
      puts "Is your current terminal font light or dark?\nPlease enter l or d.\n\
(This will allow for the best display of the minimalist board.)"
    end
    gets.chomp
  end

  # used by #user_input to check if the move is in algebraic notation (e.g. a1a3),
  # or if type is :piece, to check that the piece is one of n, b, r, and q
  def input_in_right_format?(input, type)
    if type == :move
      move_in_right_format?(input)
    elsif type == :piece
      %w[n b r q].include?(input.downcase)
    elsif type == :number_of_players
      %w[1 2].include?(input)
    elsif type == :minimalist_or_checkerboard
      %w[m c].include?(input)
    elsif type == :white_or_black_start
      %w[w b].include?(input)
    elsif type == :light_or_dark_font
      %w[l d].include?(input.downcase)
    end
  end

  def move_in_right_format?(input)
    return true if %w[q s l].include?(input.downcase)

    return false if input.length != 4

    (input =~ /[a-h][1-8][a-h][1-8]/) == 0
  end

  # used by #user_input as the message for an invalid move
  def invalid_move_message(type)
    entry = if type == :move
              'move'
            elsif type == :piece
              'piece'
            elsif type == :number_of_players
              'number of players'
            elsif type == :minimalist_or_checkerboard
              'design'
            elsif type == :white_or_black_start
              'color'
            elsif type == :light_or_dark_font
              'type'
            end
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
