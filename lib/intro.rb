# frozen_string_literal: true

# text for game intro
module Intro
  def intro_text
    print "\e[H\e[2J"
    puts <<~HEREDOC
Welcome to
       ____________       _____      _____      ________________        ______________       ______________
    /____________/|    /_____/|   /_____/|    /_______________/|      /_____________/|      /_____________/|
   /            | |   |     | |  |     | |   |               | |    /              | |    /              | |
  /    _________|/    |     | |__|     | |   |     __________|/    |      _________|/    |      _________|/
 /    / /             |     |/___|     | |   |    |/______/|       |      \\/_____/ \\     |      \\/_____/ \\
|    | |              |                | |   |           | |        \\            \\  \\     \\            \\  \\
|    | | _________    |      ____      | |   |     ______|/____      \\_______     \\  \\     \\_______     \\  \\
 \\    \\/_________/|   |     | |  |     | |   |    |/__________/|    /________/      | |   /________/      | |
  \\             | |   |     | |  |     | |   |               | |   |               | /    |               | /
   \\ ___________|/    |_____|/   |_____|/    |_______________|/    |_____________ //      |_____________ //

The classic game of strategy!

During the game, you will take turns for one or two players using algebraic notation, for example a2a4 or b8c6.

During each turn, you can make a move for the indicated player using algebraic notation.
You can also type q to resign and end the game immediately s to save the game in its current state, or l to load a  saved game.

At the beginning of the game there are up to four setup choices to make, on the next page:

1) Number of players. You can play against the computer (computer plays randomly) or you can play a 2 player game.
2) Position of the colors. If you play one player you can choose to play white or black, and that color will
go on the bottom of the board. If you play two player you can choose which color goes on the bottom of the board.
3) Minimalist or checkerboard design. Select your choice of design. Try each of them out in different games!
4) If you choose the minimalist design, for best display of white and black correctly you need to enter whether your
terminal window's font is light-colored (typically white) or dark-colored (typically black).

Type h or help during the game to see key commands again options.
Have a great game!
HEREDOC
  end

  def leave_intro
    print 'Press any key to start the game!'
    STDIN.getch # gets the input
    print "\e[H\e[2J" # clears the screen
  end
end
