# frozen_string_literal: true

# methods for the one player version of the game
module OnePlayerVersion
  private

  # used by #play_turn to take the computer turn
  def computer_takes_a_turn
    start = random_square
    finish = random_square
    while move_piece(start, finish) == :invalid
      start = random_square
      finish = random_square
    end
    update_moved_castling_pieces(start)
    update_en_passant_column(start, finish)
    @previous_move = start_finish_to_move(start, finish)
  end

  # used by #computer_takes_a_turn
  def random_square
    [rand(8), rand(8)]
  end

  # used by #computer_takes_a_turn
  def start_finish_to_move(start, finish)
    (start[0] + 97).chr + (start[1] + 1).to_s + (finish[0] + 97).chr + (finish[1] + 1).to_s
  end
end
