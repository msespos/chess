# frozen_string_literal: true

# player class
class Player
  def player_move
    move = obtain_move_from_player
    until move_in_right_format?(move)
      puts invalid_move_message
      move = obtain_move_from_player
    end
    move
  end

  def obtain_move_from_player
    puts 'Please enter your move'
    gets.chomp
  end

  def move_in_right_format?(move)
    return false if move.length != 4

    move =~ /[a-h][1-8][a-h][1-8]/ ? true : false
  end

  def invalid_move_message
    'That is not a valid move! Please enter a valid move'
  end
end
