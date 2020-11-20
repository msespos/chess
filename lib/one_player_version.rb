# frozen_string_literal: true

# methods for the one player version of the game
module OnePlayerVersion
  def play_computer_turn
    start = random_square
    finish = random_square
    while move_piece(start, finish, false, true) == invalid
      start = random_square
      finish = random_square
    end
  end

  def random_square
    [rand(8), rand(8)]
  end
end
