# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board.rb'

RSpec.describe Board do
  subject(:board) { described_class.new }
  describe '#initialize' do
    context 'when the board class is instantiated' do
      it 'calls #initial_board' do
        expect(board).to receive(:initial_board)
        board.send(:initialize)
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
    context 'when it receives an initial board from Game' do
      it 'prints out the initial board' do
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

    context 'when it receives a board with a few opening moves from Game' do
      it 'prints out the current board' do
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

    context 'when it receives a board with an endgame situation' do
      it 'prints out the current board' do
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
