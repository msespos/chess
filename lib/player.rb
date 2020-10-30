# frozen_string_literal: true

# player class
class Player
  # get the player's move and checking it, prompting if invalid moves are entered
  def player_move
    move = obtain_move_from_player
    until move_in_right_format?(move)
      puts invalid_move_message
      move = obtain_move_from_player
    end
    move
  end

  # used by #player_move to get the player's move before checking it
  def obtain_move_from_player
    puts 'Please enter your move.'
    gets.chomp
  end

  # used by #player_move to check if the move is in algebraic notation (e.g. a1a3)
  def move_in_right_format?(move)
    return false if move.length != 4

    move =~ /[a-h][1-8][a-h][1-8]/ ? true : false
  end

  # used by #player_move as the message for an invalid move
  def invalid_move_message
    'That is not a valid move! Please enter a valid move.'
  end

  # used by Game#play
  def intro_text
    'Intro text and Intro board'
  end

  # used by Game#play
  def end_of_game_announcement(current_player, type_of_end)
    if type_of_end == :checkmate
      winner = current_player == :white ? :black : :white
      "Checkmate! #{winner.capitalize} wins!"
    else
      "#{current_player.capitalize} is in stalemate! It's a draw!"
    end
  end

  # used by Game#play_turn
  def in_check_announcement(current_player)
    "#{current_player.capitalize} is in check!"
  end

  # used by Game#play_turn
  def current_player_announcement(current_player)
    "It is #{current_player.capitalize}\'s turn."
  end
end
