# frozen_string_literal: true

require_relative 'piece.rb'

# king class
class King
  # determine if a path is legal for a king using the start and finish (playing field not used)
  def path?(start, finish)
    (start[0] - finish[0]).abs <= 1 && (start[1] - finish[1]).abs <= 1
  end
end
