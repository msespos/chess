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

  describe 'on_board?' do
    context 'when [0, 0] is passed' do
      it 'returns false' do
        is_on_board = board.on_board?([0, 0])
        expect(is_on_board).to eq(false)
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
        is_on_board = board.on_board?([11, 9])
        expect(is_on_board).to eq(false)
      end
    end

    context 'when [10, 8] is passed' do
      it 'returns true' do
        is_on_board = board.on_board?([10, 8])
        expect(is_on_board).to eq(true)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
