# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

require 'yaml'

# methods for saving and loading the game
# adapted from my Snowman game file at ../../snowman/lib/game.rb
module SaveLoad
  def save_game
    puts save_text
    file = File.open("saved_games/chess_save_#{slot}.yml", 'w')
    file.puts(to_yaml)
    file.close
    puts "Game saved! Let's get back to the game."
  end

  def save_text
    "There are 3 slots to save in, labeled 1, 2, and 3.\n"\
      'Please select a number. You will overwrite any already saved game in that slot.'
  end

  def slot
    slot = gets.chomp.to_i
    until [1, 2, 3].include?(slot)
      puts 'Please select an integer between 1 and 3.'
      slot = gets.chomp.to_i
    end
    slot
  end

  def to_yaml
    YAML.dump({ current_player: @current_player,
                resignation: @resignation,
                captured_pieces: @captured_pieces,
                en_passant_column: @en_passant_column,
                white_king_moved: @white_king_moved,
                white_kingside_rook_moved: @white_kingside_rook_moved,
                white_queenside_rook_moved: @white_queenside_rook_moved,
                black_king_moved: @black_king_moved,
                black_kingside_rook_moved: @black_kingside_rook_moved,
                black_queenside_rook_moved: @black_queenside_rook_moved,
                playing_field: @playing_field })
  end

  def load_game
    puts load_text
    from_yaml("saved_games/chess_save_#{slot}.yml")
  end

  def load_text
    "There are 3 slots that a game could be saved in, labeled 1, 2, and 3.\n"\
      'Please select a number. You should have saved a game in that slot already.'
  end

  def from_yaml(game)
    status = YAML.safe_load(File.read(game), [Symbol])
    assign_all_but_castling_variables(status)
    assign_castling_variables(status)
  end

  def assign_all_but_castling_variables(status)
    @current_player = status[:current_player]
    @resignation = status[:resignation]
    @captured_pieces = status[:captured_pieces]
    @en_passant_column = status[:en_passant_column]
    @playing_field = status[:playing_field]
  end

  def assign_castling_variables(status)
    @white_king_moved = status[:white_king_moved]
    @white_kingside_rook_moved = status[:white_kingside_rook_moved]
    @white_queenside_rook_moved = status[:white_queenside_rook_moved]
    @black_king_moved = status[:black_king_moved]
    @black_kingside_rook_moved = status[:black_kingside_rook_moved]
    @black_queenside_rook_moved = status[:black_queenside_rook_moved]
  end
end

# rubocop:enable Metrics/MethodLength
