# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board.rb'

RSpec.describe Board do
  subject(:board) { described_class.new(:white, :minimalist, :dark) }
  describe '#initialize' do
    context 'when the board class is instantiated' do
      it 'calls #set_up_pieces' do
        expect(board).to receive(:set_up_pieces)
        board.send(:initialize, :white, :minimalist, :dark)
      end

      it 'calls #set_up_board' do
        expect(board).to receive(:set_up_board)
        board.send(:initialize, :white, :minimalist, :dark)
      end
    end
  end

  describe '#minimalist_pieces' do
    context 'when :white is passed in and a light font has been selected' do
      it 'sets @w_pawn to " \u265F"' do
        board.instance_variable_set(:@light_or_dark_font, :light)
        board.minimalist_pieces(:white)
        w_pawn = board.instance_variable_get(:@w_pawn)
        expect(w_pawn).to eq(" \u265F")
      end
    end

    context 'when :black is passed in and a dark font has been selected' do
      it 'sets @b_pawn to " \u265F"' do
        board.instance_variable_set(:@light_or_dark_font, :dark)
        board.minimalist_pieces(:black)
        b_pawn = board.instance_variable_get(:@b_pawn)
        expect(b_pawn).to eq(" \u265F")
      end
    end
  end

  describe '#checkerboard_pieces' do
    context 'when :white is passed in' do
      it 'sets @w_pawn to "\033[37m \u265F \033[0m"' do
        board.checkerboard_pieces(:white)
        w_pawn = board.instance_variable_get(:@w_pawn)
        expect(w_pawn).to eq("\033[37m \u265F \033[0m")
      end
    end

    context 'when :black is passed in' do
      it 'sets @b_pawn to "\033[30m \u265F \033[0m"' do
        board.checkerboard_pieces(:black)
        b_pawn = board.instance_variable_get(:@b_pawn)
        expect(b_pawn).to eq("\033[30m \u265F \033[0m")
      end
    end
  end

  describe '#to_s' do
    context 'at the beginning of the game' do
      it 'contains the board setup without pieces' do
        expect { puts(board) }.to output(<<-BOARD).to_stdout

     a b c d e f g h

 8     8  
 7     7  
 6   - - - - - - - -   6  
 5   - - - - - - - -   5  
 4   - - - - - - - -   4  
 3   - - - - - - - -   3  
 2     2  
 1     1  

     a b c d e f g h

        BOARD
      end
    end
  end

  describe '#overwrite_playing_field' do
    context 'when it receives an initial minimalist board from Game' do
      it 'prints out the initial minimalist board' do
        board.overwrite_playing_field([[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                                       [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                                       [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                                       [:w_queen, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                                       [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                                       [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                                       [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                                       [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]])
        expect { puts(board) }.to output(<<-BOARD).to_stdout

     a b c d e f g h

 8   ♜ ♞ ♝ ♛ ♚ ♝ ♞ ♜   8  
 7   ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟   7  
 6   - - - - - - - -   6  
 5   - - - - - - - -   5  
 4   - - - - - - - -   4  
 3   - - - - - - - -   3  
 2   ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙   2  
 1   ♖ ♘ ♗ ♕ ♔ ♗ ♘ ♖   1  

     a b c d e f g h

        BOARD
      end
    end

    context 'when it receives a minimalist board with a few opening moves from Game' do
      it 'prints out the current minimalist board' do
        board.overwrite_playing_field([[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                                       [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, nil],
                                       [nil, :w_pawn, nil, nil, nil, :b_knight, :b_pawn, :b_bishop],
                                       [:w_queen, nil, nil, :w_pawn, :b_pawn, nil, nil, :b_queen],
                                       [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                                       [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                                       [:w_knight, :w_pawn, nil, nil, :w_bishop, nil, :b_pawn, :b_knight],
                                       [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]])
        expect { puts(board) }.to output(<<-BOARD).to_stdout

     a b c d e f g h

 8   ♜ - ♝ ♛ ♚ ♝ ♞ ♜   8  
 7   ♟ ♟ ♟ - ♟ ♟ ♟ ♟   7  
 6   - - ♞ - - - - -   6  
 5   - - - ♟ - - ♗ -   5  
 4   - - - ♙ - - - -   4  
 3   - - - - - - - -   3  
 2   ♙ ♙ ♙ - ♙ ♙ ♙ ♙   2  
 1   ♖ ♘ - ♕ ♔ ♗ ♘ ♖   1  

     a b c d e f g h

        BOARD
      end
    end

    context 'when it receives a minimalist board with an endgame situation' do
      it 'prints out the current minimalist board' do
        board.overwrite_playing_field([[nil, nil, nil, nil, :b_pawn, nil, nil, nil],
                                       [:w_king, nil, :w_pawn, nil, nil, nil, nil, nil],
                                       [nil, nil, :w_pawn, nil, nil, nil, nil, nil],
                                       [nil, nil, nil, :b_king, nil, nil, nil, nil],
                                       [nil, nil, nil, nil, nil, nil, nil, nil],
                                       [nil, nil, nil, nil, nil, :w_pawn, nil, nil],
                                       [nil, nil, :b_queen, nil, nil, nil, nil, nil],
                                       [nil, nil, :w_pawn, nil, nil, nil, nil, nil]])
        expect { puts(board) }.to output(<<-BOARD).to_stdout

     a b c d e f g h

 8   - - - - - - - -   8  
 7   - - - - - - - -   7  
 6   - - - - - ♙ - -   6  
 5   ♟ - - - - - - -   5  
 4   - - - ♚ - - - -   4  
 3   - ♙ ♙ - - - ♛ ♙   3  
 2   - - - - - - - -   2  
 1   - ♔ - - - - - -   1  

     a b c d e f g h

        BOARD
      end
    end
  end

  describe '#checkerboard_square' do
    context 'when it creates a light-colored background square' do
      it 'prints "\033[46m   \033[0m"' do
        square = board.checkerboard_square(2, 3)
        expect(square).to eq("\033[46m   \033[0m")
      end
    end

    context 'when it creates a dark-colored square with a white pawn on it' do
      it "prints '\033[44m#{@w_pawn}\033[0m'" do
        square = board.checkerboard_square(7, 7, @w_pawn)
        expect(square).to eq("\033[45m#{@w_pawn}\033[0m")
      end
    end
  end

  describe '#add_captured_pieces' do
    context 'when it receives a set of captured pieces from Game in the beginning of a game' do
      it 'prints out the board and captured pieces' do
        board.overwrite_playing_field([[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                                       [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                                       [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                                       [nil, :w_queen, nil, nil, nil, :b_pawn, nil, nil],
                                       [:w_king, :w_pawn, nil, nil, :b_pawn, nil, nil, :b_king],
                                       [:w_bishop, :w_pawn, nil, nil, nil, nil, nil, nil],
                                       [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                                       [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :w_knight]])
        board.add_captured_pieces([[:b_rook, :b_bishop, :b_queen, :b_pawn, nil, nil, nil, nil],
                                   [nil, nil, nil, nil, nil, nil, nil, nil],
                                   [:w_bishop, :w_pawn, nil, nil, nil, nil, nil, nil],
                                   [nil, nil, nil, nil, nil, nil, nil, nil]])
        expect { puts(board) }.to output(<<-BOARD).to_stdout

     a b c d e f g h

 8   ♜ ♞ ♝ - ♚ - ♞ ♘   8   ♗ ♙
 7   ♟ ♟ ♟ - - - ♟ ♟   7  
 6   - - - ♟ - - - -   6  
 5   - - - - ♟ - - -   5  
 4   - - - - - - - -   4  
 3   - - - - - - - -   3  
 2   ♙ ♙ ♙ ♕ ♙ ♙ ♙ ♙   2  
 1   ♖ ♘ - - ♔ ♗ - ♖   1   ♜ ♝ ♛ ♟

     a b c d e f g h

        BOARD
      end
    end

    context 'when it receives a set of captured pieces from Game in endgame' do
      it 'prints out the board and captured pieces' do
        board.overwrite_playing_field([[nil, :w_pawn, nil, nil, nil, nil, :b_pawn, nil],
                                       [nil, nil, nil, :w_pawn, nil, nil, :b_bishop, nil],
                                       [:w_rook, nil, nil, :b_pawn, nil, nil, nil, nil],
                                       [nil, nil, nil, nil, nil, nil, nil, nil],
                                       [nil, nil, nil, nil, nil, nil, nil, nil],
                                       [nil, :w_king, nil, nil, nil, nil, nil, nil],
                                       [nil, nil, :w_pawn, :b_king, nil, nil, nil, nil],
                                       [nil, nil, nil, :w_pawn, :b_pawn, nil, nil, nil]])
        board.add_captured_pieces([%i[b_knight b_bishop b_rook b_pawn b_knight b_queen b_pawn b_pawn],
                                   [:b_rook, :b_pawn, :b_pawn, nil, nil, nil, nil, nil],
                                   %i[w_rook w_queen w_pawn w_pawn w_knight w_knight w_bishop w_pawn],
                                   [:w_pawn, :w_bishop, nil, nil, nil, nil, nil, nil]])
        expect { puts(board) }.to output(<<-BOARD).to_stdout

     a b c d e f g h

 8   - - - - - - - -   8   ♖ ♕ ♙ ♙ ♘ ♘ ♗ ♙
 7   ♟ ♝ - - - - - -   7   ♙ ♗
 6   - - - - - - - -   6  
 5   - - - - - - - ♟   5  
 4   - ♙ ♟ - - - ♚ ♙   4  
 3   - - - - - - ♙ -   3  
 2   ♙ - - - - ♔ - -   2   ♜ ♟ ♟
 1   - - ♖ - - - - -   1   ♞ ♝ ♜ ♟ ♞ ♛ ♟ ♟

     a b c d e f g h

        BOARD
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
