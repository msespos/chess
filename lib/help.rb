# frozen_string_literal: true

require 'io/console'

# text for game intro
module Help
  private

  def help_text
    print "\e[H\e[2J" # clears the screen
    puts <<~HEREDOC
      Help - Tips for playing

      Moving

        1) A move must be in algebraic notation and must be a valid move.
           Examples: a2a4 and b8c6. Use the board's letters and numbers for reference.
      
        2) To castle, if you are able to, move the king two squares towards the rook.
      
        3) When promoting a pawn, choose from the four choices given.

      Other actions
  
        1) Type q to resign and quit the game. You will be prompted once to make sure
           you want to resign.

        2) Type s to save the current game and settings. You will be prompted to choose
           a slot to save the game and settings in. Remember your choice!

        3) Type l to load a game and settings. You will lose the game you are currently
           playing, unless you have saved that one beforehand. Did you remember your choice? :)
           
    HEREDOC
  end

  def leave_help
    print 'Press any key to continue the game!'
    STDIN.getch # gets the input
    print "\e[H\e[2J" # clears the screen
  end
end
