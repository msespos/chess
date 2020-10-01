# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/piece.rb'

RSpec.describe Piece do
  subject(:piece) { described_class.new }
  describe '#rook_path?' do
    context 'when it is called' do
      it 'creates an instance of Rook' do
        piece.rook_path?([0, 0], [5, 5], ['playing field'])
        rook = piece.instance_variable_get(:@rook)
        expect(rook).to be_a(Rook)
      end
      it 'the Rook instance calls #path?' do
        piece.rook_path?([0, 0], [5, 5], ['playing field'])
        rook_a = piece.instance_variable_get(:@rook)
        expect(rook_a).to receive(:path?).with([0, 0], [5, 5], ['playing field'])
      end
    end
  end
      
  describe '#rank_free?' do
    context 'when there is a clear path between the start and finish squares along a rank' do
      it 'returns true' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        rank_free_or_not = piece.rank_free?([0, 0], [3, 0], playing_field)
        expect(rank_free_or_not).to eq(true)
      end
    end

    context 'when there is not a clear path between the start and finish squares along a rank' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        rank_free_or_not = piece.rank_free?([0, 0], [7, 0], playing_field)
        expect(rank_free_or_not).to eq(false)
      end
    end
  end

  describe '#file_free?' do
    context 'when there is a clear path between the start and finish squares along a file' do
      it 'returns true' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_queen, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        file_free_or_not = piece.file_free?([0, 1], [0, 5], playing_field)
        expect(file_free_or_not).to eq(true)
      end
    end

    context 'when there is not a clear path between the start and finish squares along a file' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_queen, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        file_free_or_not = piece.file_free?([0, 0], [0, 5], playing_field)
        expect(file_free_or_not).to eq(false)
      end
    end
  end

  describe '#along_rank?' do
    context 'when the potential path is along a rank' do
      it 'returns true' do
        along_rank_or_not = piece.along_rank?([1, 0], [5, 0])
        expect(along_rank_or_not).to eq(true)
      end
    end

    context 'when the potential path is not along a rank' do
      it 'returns false' do
        along_rank_or_not = piece.along_rank?([1, 3], [1, 1])
        expect(along_rank_or_not).to eq(false)
      end
    end
  end

  describe '#along_file?' do
    context 'when the potential path is along a file' do
      it 'returns true' do
        along_file_or_not = piece.along_file?([0, 3], [0, 4])
        expect(along_file_or_not).to eq(true)
      end
    end

    context 'when the potential path is not along a file' do
      it 'returns false' do
        along_file_or_not = piece.along_file?([1, 1], [3, 1])
        expect(along_file_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
