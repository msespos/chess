# frozen_string_literal: true

# text for game ending
module Ending
  # used by Game#end_of_game_announcement
  def ending_text(current_player, type_of_ending)
    winner = current_player == :white ? :black : :white
    winner_congratulations = "#{winner.capitalize} wins.\nCongratulations #{winner.capitalize}!\n\n"
    if type_of_ending == :checkmate
      "\nCheckmate! #{winner_congratulations}"
    elsif type_of_ending == :stalemate
      "\n#{current_player.capitalize} is in stalemate!\nIt's a draw!\n\n"
    elsif type_of_ending == :resignation
      "\n#{current_player.capitalize} resigns! #{winner_congratulations}"
    end
  end
end
