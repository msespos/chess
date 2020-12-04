# frozen_string_literal: true

require 'io/console'

# text for game intro
module Intro
  private

  # in place until repl.it fixes its full screen
  def pre_intro_for_repl_it
    print "\e[H\e[2J" # clears the screen
    print "Please maximize your terminal window and then press any key."
    STDIN.getch # gets the input
    print "\e[H\e[2J" # clears the screen
  end

  def intro_text
    print "\e[H\e[2J" # clears the screen
    puts <<~HEREDOC
      Welcome to...

                ____________       _____      _____      ________________        ______________        ______________
              /____________/|    /_____/|   /_____/|    /_______________/|      /_____________/|      /_____________/|
             /            | |   |     | |  |     | |   |               | |    /              | |    /              | |
            /    _________|/    |     | |__|     | |   |     __________|/    |      _________|/    |      _________|/
           /    / /             |     |/___|     | |   |    |/______/|       |      \\/_____/ \\     |      \\/_____/ \\
          |    | |              |                | |   |           | |        \\            \\  \\     \\            \\  \\
          |    | | _________    |      ____      | |   |     ______|/____      \\_______     \\  \\     \\_______     \\  \\
           \\    \\/_________/|   |     | |  |     | |   |    |/__________/|    /________/     |  |   /________/     |  |
            \\             | |   |     | |  |     | |   |               | |   |               | /    |               | /
             \\ ___________|/    |_____|/   |_____|/    |_______________|/    |_____________ //      |_____________ //


                                                                                          ...the classic game of strategy!


          This version of chess uses algebraic notation, a four character format in which the first two characters
          represent the square you are moving from, and the second two characters the square you are moving to.

          For example, a first move of d2d4 moves a white pawn from the d2 square to the d4 square.
          Similarly, a followup move of b8c6 moves a black knight from the b8 square to the c6 square.

          The board is labeled with a-h and 1-8 for easy reference.
          Please note that every move must be in algebraic notation, or it will be considered invalid.

          To castle, assuming all the conditions for castling are met, just move the king two squares towards the rook.
          When a pawn is eligible for promotion, you will be given the four options n, b, r, and q to select from.
          And yes, you can capture en passant. :)

          During your turn, besides making a move, you can also type q to resign and end the game.
          You can also type s to save the game in its current state, or l to load a saved game.

          Type h or help during the game to see your options again.

          Have a great game!

          PS: for best display of this title screen, maximize your terminal window.
          PPS: you may want to zoom in once you start the actual game for a better view of the board.

    HEREDOC
  end

  def leave_intro
    print '    ---> Press any key to go to the setup screen and start the game!'
    STDIN.getch # gets the input
    print "\e[H\e[2J" # clears the screen
  end
end
