# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/rook.rb'

RSpec.describe Rook do
  subject(:rook) { described_class.new }
  describe '#path?' do
    context 'when the potential path is neither along a rank nor along a file' do
      before do
        allow(rook).to receive(:along_rank?).and_return(false)
        allow(rook).to receive(:along_file?).and_return(false)
      end

      it 'returns false' do
        path_or_not = rook.path?([0, 0], [5, 5], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the potential path is along a rank' do
      before do
        allow(rook).to receive(:along_rank?).and_return(true)
        allow(rook).to receive(:along_file?).and_return(false)
      end

      it 'calls #rank_free?' do
        expect(rook).to receive(:rank_free?)
        rook.path?([0, 0], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a file' do
      before do
        allow(rook).to receive(:along_rank?).and_return(false)
        allow(rook).to receive(:along_file?).and_return(true)
      end

      it 'calls #file_free?' do
        expect(rook).to receive(:file_free?)
        rook.path?([0, 0], [5, 5], ['playing field'])
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
