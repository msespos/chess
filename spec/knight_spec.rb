# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/knight.rb'

RSpec.describe Knight do
  subject(:knight) { described_class.new }
  describe '#path?' do
    context 'when the start and finish are not an L apart from each other' do
      it 'returns true' do
        allow(knight).to receive(:vertical_l?).and_return(false)
        allow(knight).to receive(:horizontal_l?).and_return(false)
        expect(knight).to receive(:path?).and_return(false)
        knight.path?('start', 'finish')
      end
    end
  end

  describe '#vertical_l?' do
    context 'when the start and finish are a vertical L apart' do
      it 'returns true' do
        vertical_l_or_not = knight.vertical_l?([4, 0], [5, 2])
        expect(vertical_l_or_not).to eq(true)
      end

      it 'returns true' do
        vertical_l_or_not = knight.vertical_l?([4, 5], [5, 3])
        expect(vertical_l_or_not).to eq(true)
      end

      it 'returns true' do
        vertical_l_or_not = knight.vertical_l?([2, 3], [1, 1])
        expect(vertical_l_or_not).to eq(true)
      end

      it 'returns true' do
        vertical_l_or_not = knight.vertical_l?([5, 6], [4, 8])
        expect(vertical_l_or_not).to eq(true)
      end
    end

    context 'when the start and finish are not a vertical L apart' do
      it 'returns false' do
        vertical_l_or_not = knight.vertical_l?([0, 0], [5, 2])
        expect(vertical_l_or_not).to eq(false)
      end
    end
  end

  describe '#horizontal_l?' do
    context 'when the start and finish are a horizontal L apart' do
      it 'returns true' do
        horizontal_l_or_not = knight.horizontal_l?([4, 0], [2, 1])
        expect(horizontal_l_or_not).to eq(true)
      end

      it 'returns true' do
        horizontal_l_or_not = knight.horizontal_l?([7, 7], [5, 6])
        expect(horizontal_l_or_not).to eq(true)
      end

      it 'returns true' do
        horizontal_l_or_not = knight.horizontal_l?([0, 2], [2, 3])
        expect(horizontal_l_or_not).to eq(true)
      end

      it 'returns true' do
        horizontal_l_or_not = knight.horizontal_l?([6, 2], [8, 1])
        expect(horizontal_l_or_not).to eq(true)
      end
    end

    context 'when the start and finish are not a horizontal L apart' do
      it 'returns false' do
        horizontal_l_or_not = knight.horizontal_l?([4, 4], [6, 6])
        expect(horizontal_l_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
