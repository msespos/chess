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
  def user_move_input(type)
    input = obtain_user_move_input(type)
    until move_input_in_right_format?(input, type)
      puts invalid_move_message(type)
      input = obtain_user_move_input(type)
    end
    input
  end

  # used by #user_input to get the player's move before checking it
  def obtain_user_move_input(type)
    if type == :move
      puts 'Please enter your move.'
    else
      puts "You can promote a pawn!\nPlease enter n, b, r or q to promote."
    end
    gets.chomp
  end

  # used by #user_input to check if the move is in algebraic notation (e.g. a1a3),
  # or if type is :piece, to check that the piece is one of n, b, r, and q
  def move_input_in_right_format?(input, type)
    return true if %w[q s l].include?(input.downcase)

    if type == :move
      return false if input.length != 4

      input =~ /[a-h][1-8][a-h][1-8]/ ? true : false
    else
      %w[n b r q].include?(input.downcase)
    end
  end

  # used by #user_input as the message for an invalid move
  def invalid_move_message(type)
    move_or_piece = type == :move ? 'move' : 'piece'
    "That is not a valid #{move_or_piece}! Please enter a valid #{move_or_piece}."
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
