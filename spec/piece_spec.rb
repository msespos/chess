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
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a diagonal path' do
      it 'returns false' do
        path_or_not = piece.rook_path?([0, 0], [1, 1], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a rank path that is open, left to right' do
      it 'returns true' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.rook_path?([0, 0], [4, 0], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a rank path that is blocked, left to right' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.rook_path?([0, 1], [4, 1], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a rank path that is blocked, right to left' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.rook_path?([7, 0], [4, 0], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a file path that is blocked, up to down' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.rook_path?([7, 7], [7, 5], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a file path that is blocked, down to up' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.rook_path?([7, 0], [7, 3], playing_field)
        expect(path_or_not).to eq(false)
      end
    end
  end

  describe '#bishop_path?' do
    context 'when it is called' do
      it 'creates an instance of Bishop' do
        piece.bishop_path?([0, 0], [0, 5], ['playing field'])
        bishop = piece.instance_variable_get(:@bishop)
        expect(bishop).to be_a(Bishop)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a non-diagonal path' do
      it 'returns false' do
        path_or_not = piece.bishop_path?([0, 0], [0, 1], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a positive diagonal path that is open, left to right' do
      it 'returns true' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, nil, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.bishop_path?([5, 0], [7, 2], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a positive diagonal path that is blocked, left to right' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.bishop_path?([5, 0], [7, 2], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a positive diagonal path that is blocked, right to left' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.bishop_path?([5, 7], [2, 4], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a negative diagonal path that is blocked, left to right' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.bishop_path?([2, 7], [5, 4], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a negative diagonal path that is blocked, right to left' do
      it 'returns false' do
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [nil, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        path_or_not = piece.bishop_path?([5, 0], [3, 2], playing_field)
        expect(path_or_not).to eq(false)
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
        rank_free_or_not = piece.rank_free?([4, 0], [1, 0], playing_field)
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
        rank_free_or_not = piece.rank_free?([5, 0], [1, 0], playing_field)
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
        file_free_or_not = piece.file_free?([0, 1], [0, 7], playing_field)
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

  describe '#along_positive_diagonal?' do
    context 'when the potential path is along a positive_diagonal' do
      it 'returns true' do
        along_positive_diagonal_or_not = piece.along_positive_diagonal?([1, 0], [4, 3])
        expect(along_positive_diagonal_or_not).to eq(true)
      end
    end

    context 'when the potential path is not along a positive_diagonal' do
      it 'returns false' do
        along_positive_diagonal_or_not = piece.along_positive_diagonal?([1, 3], [3, 3])
        expect(along_positive_diagonal_or_not).to eq(false)
      end
    end
  end

  describe '#along_negative_diagonal?' do
    context 'when the potential path is along a negative_diagonal' do
      it 'returns true' do
        along_negative_diagonal_or_not = piece.along_negative_diagonal?([1, 5], [5, 1])
        expect(along_negative_diagonal_or_not).to eq(true)
      end
    end

    context 'when the potential path is not along a negative_diagonal' do
      it 'returns false' do
        along_negative_diagonal_or_not = piece.along_negative_diagonal?([1, 5], [4, 1])
        expect(along_negative_diagonal_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
