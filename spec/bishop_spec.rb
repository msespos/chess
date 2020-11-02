# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/bishop.rb'

RSpec.describe Bishop do
  subject(:bishop) { described_class.new }
  describe '#path?' do
    context 'when the potential path is neither along a positive nor along a negative diagonal' do
      before do
        allow(bishop).to receive(:along_positive_diagonal?).and_return(false)
        allow(bishop).to receive(:along_negative_diagonal?).and_return(false)
      end

      it 'returns false' do
        path_or_not = bishop.path?([1, 0], [1, 7], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the potential path is along a positive diagonal' do
      before do
        allow(bishop).to receive(:along_positive_diagonal?).and_return(true)
        allow(bishop).to receive(:along_negative_diagonal?).and_return(false)
      end

      it 'calls #positive_diagonal_free?' do
        expect(bishop).to receive(:positive_diagonal_free?)
        bishop.path?([1, 1], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a negative diagonal' do
      before do
        allow(bishop).to receive(:along_positive_diagonal?).and_return(false)
        allow(bishop).to receive(:along_negative_diagonal?).and_return(true)
      end
      
      it 'calls #negative_diagonal_free?' do
        expect(bishop).to receive(:negative_diagonal_free?)
        bishop.path?([1, 5], [5, 1], ['playing field'])
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
