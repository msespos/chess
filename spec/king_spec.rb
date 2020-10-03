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

  describe 'only_one_space?' do
    context 'the start and finish are more than one space apart' do
      it 'returns false' do
        only_one_space_or_not = king.only_one_space?([4, 0], [6, 0])
        expect(only_one_space_or_not).to eq(false)
      end

      it 'returns false' do
        only_one_space_or_not = king.only_one_space?([4, 0], [4, 5])
        expect(only_one_space_or_not).to eq(false)
      end

      it 'returns false' do
        only_one_space_or_not = king.only_one_space?([1, 1], [3, 3])
        expect(only_one_space_or_not).to eq(false)
      end

      it 'returns false' do
        only_one_space_or_not = king.only_one_space?([1, 2], [0, 0])
        expect(only_one_space_or_not).to eq(false)
      end
    end

    context 'the start and finish are one space apart' do
      it 'returns true' do
        only_one_space_or_not = king.only_one_space?([4, 0], [5, 0])
        expect(only_one_space_or_not).to eq(true)
      end

      it 'returns true' do
        only_one_space_or_not = king.only_one_space?([4, 0], [4, 1])
        expect(only_one_space_or_not).to eq(true)
      end

      it 'returns true' do
        only_one_space_or_not = king.only_one_space?([1, 1], [2, 2])
        expect(only_one_space_or_not).to eq(true)
      end

      it 'returns true' do
        only_one_space_or_not = king.only_one_space?([1, 2], [2, 3])
        expect(only_one_space_or_not).to eq(true)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
