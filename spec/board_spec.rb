# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board.rb'

RSpec.describe Board do
  subject(:board) { described_class.new }
  describe '#initialize' do
    context 'when the board class is instantiated' do
      it 'calls #opening_board' do
        expect(board).to receive(:opening_board)
        board.send(:initialize)
      end
    end
  end

  describe '#opening_board' do
    context 'when #opening_board is called' do
      it 'generates a 14 row board' do
        expect(board.instance_variable_get(:@board).size).to eq(14)
      end

      it 'generates a 10 column board' do
        expect(board.instance_variable_get(:@board)[0].size).to eq(10)
      end

      it 'generates a board with a white rook in a1' do
        expect(board.instance_variable_get(:@board)[3][1]).to eq(" \u2656".encode('utf-8'))
      end

      it 'generates a board with a black rook in h8' do
        expect(board.instance_variable_get(:@board)[10][8]).to eq(" \u265C".encode('utf-8'))
      end

      it 'generates a board with a white knight in c1' do
        expect(board.instance_variable_get(:@board)[3][2]).to eq(" \u2658".encode('utf-8'))
      end

      it 'generates a board with a black pawn in g7' do
        expect(board.instance_variable_get(:@board)[9][7]).to eq(" \u265F".encode('utf-8'))
      end

      it 'generates a board with " -" in a4' do
        expect(board.instance_variable_get(:@board)[6][1]).to eq(' -')
      end

      it 'generates a board with " -" in c5' do
        expect(board.instance_variable_get(:@board)[7][5]).to eq(' -')
      end
    end
  end

  describe '#to_s' do
    context 'at the beginning of the game' do
      it 'displays the opening board setup correctly' do
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
  end

  describe '#on_board?' do
    context 'when [0, 0] is passed' do
      it 'returns false' do
        is_not_on_board = board.on_board?([0, 0])
        expect(is_not_on_board).to eq(false)
      end
    end

    context 'when [3, 1] is passed' do
      it 'returns true' do
        is_on_board = board.on_board?([3, 1])
        expect(is_on_board).to eq(true)
      end
    end

    context 'when [11, 9] is passed' do
      it 'returns false' do
        is_not_on_board = board.on_board?([11, 9])
        expect(is_not_on_board).to eq(false)
      end
    end

    context 'when [10, 8] is passed' do
      it 'returns true' do
        is_on_board = board.on_board?([10, 8])
        expect(is_on_board).to eq(true)
      end
    end
  end

  describe '#translate_coordinates' do
    context 'when [1, 0] is passed' do
      it 'returns [2, 3]' do
        translated = board.translate_coordinates([1, 0])
        expect(translated).to eq([2, 3])
      end
    end
  end

  describe '#swap_coordinates' do
    context 'when [1, 0] is passed' do
      it 'returns [0, 1]' do
        swapped = board.swap_coordinates([1, 0])
        expect(swapped).to eq([0, 1])
      end
    end
  end

  describe '#overwrite_square' do
    context 'when [1, 0] and no other argument is passed' do
      it 'sets board[3][2] to " -"' do
        board.overwrite_square([1, 0])
        expect(board.instance_variable_get(:@board)[3][2]).to eq(' -')
      end
    end

    context 'when [1, 0] and a knight are passed' do
      it 'sets board[3][2] to " ♘"' do
        board.overwrite_square([1, 0], Board::W_KNIGHT)
        expect(board.instance_variable_get(:@board)[3][2]).to eq(' ♘')
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
