# frozen_string_literal: true

# hashes to use for Player methods based on type
module TypeHashes
  PROMPTS = { move: 'Please enter your move.',
              piece: "You can promote a pawn!\nPlease enter n, b, r or q to promote.",
              number_of_players: 'How many are playing? 1 or 2?',
              minimalist_or_checkerboard: "Would you like a minimalist or checkerboard design?\n\
Please enter m or c.",
              bottom_color_one_player: "Would you like to play as white or black?\nPlease enter w or b.",
              bottom_color_two_player: "Would you like white or black at the bottom of the board?\n\
Please enter w or b.",
              light_or_dark_font: "Is your current terminal font light or dark?\nPlease enter l or d.\n\
(This will allow for the best display of the minimalist board.)" }.freeze

  INPUT_FORMATS = { piece: %w[n b r q],
                    minimalist_or_checkerboard: %w[m c],
                    bottom_color_one_player: %w[w b],
                    bottom_color_two_player: %w[w b],
                    light_or_dark_font: %w[l d] }.freeze

  INVALID_MOVE_MESSAGES = { move: 'move',
                            piece: 'piece',
                            number_of_players: 'number of players',
                            minimalist_or_checkerboard: 'design',
                            bottom_color_one_player: 'color',
                            bottom_color_two_player: 'color',
                            light_or_dark_font: 'type' }.freeze
end