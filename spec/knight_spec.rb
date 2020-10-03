# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/knight.rb'

RSpec.describe Knight do
  subject(:knight) { described_class.new }
  describe '#path?' do
    context 'when the start and finish are not a knight"s move apart' do
      it 'returns false' do
        path_or_not = knight.path?([4, 0], [6, 0])
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = knight.path?([4, 0], [4, 5])
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = knight.path?([1, 1], [5, 5])
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = knight.path?([1, 2], [7, 8])
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the start and finish are a knight"s move apart' do
      it 'returns true' do
        path_or_not = knight.path?([4, 0], [5, 2])
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = knight.path?([4, 0], [3, 2])
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = knight.path?([7, 7], [6, 5])
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = knight.path?([7, 2], [5, 3])
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = knight.path?([6, 2], [8, 1])
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = knight.path?([4, 4], [6, 3])
        expect(path_or_not).to eq(true)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
