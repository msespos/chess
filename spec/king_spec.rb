# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/king.rb'

RSpec.describe King do
  subject(:king) { described_class.new }
  describe '#path?' do
    context 'when it is not moving only one space or castling' do
      it 'returns false' do
        allow(king).to receive(:only_one_space?).and_return(false)
        allow(king).to receive(:castling?).and_return(false)
        path_or_not = king.path?('start', 'finish', 'playing field')
        expect(path_or_not).to eq(false)
      end
    end

    context 'when it is moving only one space' do
      it 'returns true' do
        allow(king).to receive(:only_one_space?).and_return(true)
        allow(king).to receive(:castling?).and_return(false)
        path_or_not = king.path?('start', 'finish', 'playing field')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is castling' do
      it 'returns true' do
        allow(king).to receive(:only_one_space?).and_return(false)
        allow(king).to receive(:castling?).and_return(true)
        path_or_not = king.path?('start', 'finish', 'playing field')
        expect(path_or_not).to eq(true)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
