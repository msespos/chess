# frozen_string_literal: true

# king module
module King
  private

  # determine if a path is legal for a king using the start and finish (playing field not used)
  def king_path?(start, finish, _playing_field)
    (start[0] - finish[0]).abs <= 1 && (start[1] - finish[1]).abs <= 1
  end
end
