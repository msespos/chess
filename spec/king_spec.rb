# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/king.rb'

RSpec.describe King do
  subject(:king) { described_class.new }
  describe '#path?' do
    context 'when the start and finish are more than one space apart' do
      it 'returns false' do
        path_or_not = king.path?([4, 0], [6, 0])
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = king.path?([4, 0], [4, 5])
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = king.path?([1, 1], [3, 3])
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = king.path?([1, 2], [0, 0])
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the start and finish are one space apart' do
      it 'returns true' do
        path_or_not = king.path?([4, 0], [5, 0])
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = king.path?([4, 0], [4, 1])
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = king.path?([1, 1], [2, 2])
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = king.path?([1, 2], [2, 3])
        expect(path_or_not).to eq(true)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
