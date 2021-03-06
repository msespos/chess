# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength

require 'yaml'

# methods for saving and loading the game
# adapted from my Snowman game file at ../../snowman/lib/game.rb
module SaveLoad
  # used by #save_or_load
  def save_game
    puts save_text
    file = File.open("saved_games/chess_save_#{slot}.yml", 'w')
    file.puts(to_yaml)
    file.close
    puts "Game saved! Let's get back to the game."
  end

  # used by #save_or_load
  def load_game
    puts load_text
    from_yaml("saved_games/chess_save_#{slot}.yml")
  end

  private

  # used by #save_game
  def save_text
    "There are 3 slots to save in, labeled 1, 2, and 3.\n"\
      'Please select a number. You will overwrite any already saved game in that slot.'
  end

  # used by #save_game and #load_game for the user to select a slot for saving or loading to or from
  def slot
    slot = gets.chomp.to_i
    until [1, 2, 3].include?(slot)
      puts 'Please select an integer between 1 and 3.'
      slot = gets.chomp.to_i
    end
    slot
  end

  # used by #save_game
  def to_yaml
    YAML.dump({ number_of_players: @number_of_players,
                bottom_color: @bottom_color,
                minimalist_or_checkerboard: @minimalist_or_checkerboard,
                light_or_dark_font: @light_or_dark_font,
                current_player: @current_player,
                previous_move: @previous_move,
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

  # used by #load_game
  def load_text
    "There are 3 slots that a game could be saved in, labeled 1, 2, and 3.\n"\
      'Please select a number. You should have saved a game in that slot already.'
  end

  # used by #load_game
  def from_yaml(game)
    status = YAML.safe_load(File.read(game), [Symbol])
    assign_all_but_castling_variables(status)
    assign_castling_variables(status)
    @board = Board.new(@bottom_color, @minimalist_or_checkerboard, @light_or_dark_font)
  end

  # used by from_yaml
  def assign_all_but_castling_variables(status)
    @number_of_players = status[:number_of_players]
    @bottom_color = status[:bottom_color]
    @minimalist_or_checkerboard = status[:minimalist_or_checkerboard]
    @light_or_dark_font = status[:light_or_dark_font]
    @current_player = status[:current_player]
    @previous_move = status[:previous_move]
    @resignation = status[:resignation]
    @captured_pieces = status[:captured_pieces]
    @en_passant_column = status[:en_passant_column]
    @playing_field = status[:playing_field]
  end

  # used by from_yaml
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
