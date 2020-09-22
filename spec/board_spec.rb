# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/board.rb'

RSpec.describe Board do
  subject(:board) { described_class.new }
  describe '#initialize' do
    context 'when the board class is instantiated' do
      it 'calls the #board method' do
        expect(board).to receive(:board)
        board.send(:initialize)
      end
    end
  end

  describe '#board' do
    context 'when #board is called' do
      it 'generates an 8 row board' do
        expect(board.instance_variable_get(:@board)[0].size).to eq(8)
      end

      it 'generates an 8 column board' do
        expect(board.instance_variable_get(:@board).size).to eq(8)
      end

      it 'generates a board with WR in a1' do
        expect(board.instance_variable_get(:@board)[0][0]).to eq(" \u2656".encode('utf-8'))
      end

      it 'generates a board with BR in h8' do
        expect(board.instance_variable_get(:@board)[7][7]).to eq(" \u265C".encode('utf-8'))
      end

      it 'generates a board with nil in a4' do
        expect(board.instance_variable_get(:@board)[3][0]).to eq(nil)
      end

      it 'generates a board with nil in c5' do
        expect(board.instance_variable_get(:@board)[4][2]).to eq(nil)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
