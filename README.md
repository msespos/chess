### Chess

![Chess game image](https://msespos.github.io/portfolio/imgs/Chess%20screenshot.png)

## A command line implementation of the classic game, for one or two players.

# Installation:

Clone the repo and run the command `ruby lib/main.rb` from within the `chess` directory.

For best display of the title screen, maximize the terminal window.
For best display of the board, zoom in once the actual game has started.

# Or play the game here:

https://repl.it/@msespos/chess

This is a fully functional version of chess for the command line.

The two player version allows two users to take turns moving.
The one player version plays against a computer that makes random legal moves.

Moves are made using four character algebraic notation, for example a2a4 or b8c6.
The board is labeled with a-h and 1-8 for easy reference.

Castling, pawn promotion, and en passant are all supported as well as standard
move validation, check validation, checkmate validation, and castling validation.

During a turn, besides moving, a player can quit and resign immediately.
A player can also save a game at any point to one of three slots, or load a saved game.
In addition, a help screen is available at any point.

There are various display options for the board:

1) For one player mode, the player can choose to play as white or black.
    The player's color will be displayed at the bottom of the board.
2) For two player mode, the player can choose which color will be displayed
    at the bottom of the board.
3) There are two design options: a minimalist design and a checkerboard design.

Captured pieces are displayed along the side of the board in the order they were captured.

Massive thanks to the Odin Project for providing me with all the tools I needed to finish this project.

Even more massive thanks to rlmoser, AA, and Pandenok for all of their support.
