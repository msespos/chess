# frozen_string_literal: true

# player class
class Player
  def obtain_move
    puts 'Please enter your move'
    gets.chomp
  end

  def move_in_right_format?(move)
    return false if move.length != 4

    move =~ /[a-h][1-8][a-h][1-8]/ ? true : false
  end
end
