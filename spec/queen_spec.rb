# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/queen.rb'

RSpec.describe Queen do
  subject(:queen) { described_class.new }
  describe '#path?' do
    context 'when the potential path is neither along a rank nor along a file nor along a diagonal' do
      before do
        allow(queen).to receive(:along_rank_or_file_or_diagonal?).and_return(false)
      end

      it 'returns false' do
        path_or_not = queen.path?([0, 0], [5, 5], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the potential path is along a rank' do
      before do
        allow(queen).to receive(:along_rank?).and_return(true)
        allow(queen).to receive(:along_file?).and_return(false)
      end

      it 'calls #rank_free?' do
        expect(queen).to receive(:rank_free?)
        queen.path?([0, 0], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a file' do
      before do
        allow(queen).to receive(:along_rank?).and_return(false)
        allow(queen).to receive(:along_file?).and_return(true)
      end

      it 'calls #file_free?' do
        expect(queen).to receive(:file_free?)
        queen.path?([0, 0], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a positive diagonal' do
      before do
        allow(queen).to receive(:along_positive_diagonal?).and_return(true)
        allow(queen).to receive(:along_negative_diagonal?).and_return(false)
      end

      it 'calls #positive_diagonal_free?' do
        expect(queen).to receive(:positive_diagonal_free?)
        queen.path?([1, 1], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a negative diagonal' do
      before do
        allow(queen).to receive(:along_positive_diagonal?).and_return(false)
        allow(queen).to receive(:along_negative_diagonal?).and_return(true)
      end

      it 'calls #negative_diagonal_free?' do
        expect(queen).to receive(:negative_diagonal_free?)
        queen.path?([1, 5], [5, 1], ['playing field'])
      end
    end
  end

  describe '#along_rank_or_file_or_diagonal?' do
    context 'when the potential path is neither along a rank nor along a file nor along a diagonal' do
      it 'returns false' do
        allow(queen).to receive(:along_rank?).and_return(false)
        allow(queen).to receive(:along_file?).and_return(false)
        allow(queen).to receive(:along_positive_diagonal?).and_return(false)
        allow(queen).to receive(:along_negative_diagonal?).and_return(false)
        along_any_or_none = queen.along_rank_or_file_or_diagonal?([0, 0], [1, 2])
        expect(along_any_or_none).to eq(false)
      end
    end

    context 'when the potential path is along a rank' do
      it 'returns false' do
        allow(queen).to receive(:along_rank?).and_return(true)
        allow(queen).to receive(:along_file?).and_return(false)
        allow(queen).to receive(:along_positive_diagonal?).and_return(false)
        allow(queen).to receive(:along_negative_diagonal?).and_return(false)
        along_any_or_none = queen.along_rank_or_file_or_diagonal?([0, 0], [2, 0])
        expect(along_any_or_none).to eq(true)
      end
    end

    context 'when the potential path is along a file' do
      it 'returns false' do
        allow(queen).to receive(:along_rank?).and_return(false)
        allow(queen).to receive(:along_file?).and_return(true)
        allow(queen).to receive(:along_positive_diagonal?).and_return(false)
        allow(queen).to receive(:along_negative_diagonal?).and_return(false)
        along_any_or_none = queen.along_rank_or_file_or_diagonal?([0, 0], [0, 3])
        expect(along_any_or_none).to eq(true)
      end
    end

    context 'when the potential path is along a positive slope diagonal' do
      it 'returns false' do
        allow(queen).to receive(:along_rank?).and_return(false)
        allow(queen).to receive(:along_file?).and_return(false)
        allow(queen).to receive(:along_positive_diagonal?).and_return(true)
        allow(queen).to receive(:along_negative_diagonal?).and_return(false)
        along_any_or_none = queen.along_rank_or_file_or_diagonal?([0, 0], [5, 5])
        expect(along_any_or_none).to eq(true)
      end
    end

    context 'when the potential path is along a negative slope diagonal' do
      it 'returns false' do
        allow(queen).to receive(:along_rank?).and_return(false)
        allow(queen).to receive(:along_file?).and_return(false)
        allow(queen).to receive(:along_positive_diagonal?).and_return(false)
        allow(queen).to receive(:along_negative_diagonal?).and_return(true)
        along_any_or_none = queen.along_rank_or_file_or_diagonal?([0, 7], [3, 4])
        expect(along_any_or_none).to eq(true)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
