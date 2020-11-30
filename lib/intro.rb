# frozen_string_literal: true

# text for game intro
module Intro

  def intro_text
    puts "\e[H\e[2J"
    "Intro\n"
  end

  def leave_intro
    print "Press any key to start the game!"
    STDIN.getch # gets the input
    puts "\e[H\e[2J" # clears the screen
  end
end
