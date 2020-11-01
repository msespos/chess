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

  describe '#initial_board' do
    context 'when #initial_board is called' do
      it 'generates a 14 row board' do
        board_size = board.instance_variable_get(:@board).size
        expect(board_size).to eq(14)
      end

      it 'generates a 10 column board' do
        board_size = board.instance_variable_get(:@board)[0].size
        expect(board_size).to eq(10)
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
end

# rubocop:enable Metrics/BlockLength
