# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/piece.rb'

RSpec.describe Piece do
  subject(:piece) { described_class.new }
  describe '#rook_path?' do
    context 'when the potential path is neither along a rank nor along a file' do
      before do
        allow(piece).to receive(:along_rank?).and_return(false)
        allow(piece).to receive(:along_file?).and_return(false)
      end

      it 'returns false' do
        path_or_not = piece.rook_path?([0, 0], [5, 5], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the potential path is along a rank' do
      before do
        allow(piece).to receive(:along_rank?).and_return(true)
        allow(piece).to receive(:along_file?).and_return(false)
      end

      it 'calls #rank_free?' do
        expect(piece).to receive(:rank_free?)
        piece.rook_path?([0, 0], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a file' do
      before do
        allow(piece).to receive(:along_rank?).and_return(false)
        allow(piece).to receive(:along_file?).and_return(true)
      end

      it 'calls #file_free?' do
        expect(piece).to receive(:file_free?)
        piece.rook_path?([0, 0], [5, 5], ['playing field'])
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
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][0] = :w_rook
        playing_field[4][0] = :b_bishop
        path_or_not = piece.rook_path?([0, 0], [4, 0], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a rank path that is blocked, left to right' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_rook
        playing_field[2][1] = :w_rook
        playing_field[4][1] = :b_bishop
        path_or_not = piece.rook_path?([0, 1], [4, 1], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a rank path that is blocked, right to left' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :b_bishop
        playing_field[6][0] = :w_rook
        playing_field[7][0] = :w_rook
        path_or_not = piece.rook_path?([7, 0], [5, 0], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a file path that is open, up to down' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[7][5] = :b_bishop
        playing_field[7][7] = :w_rook
        path_or_not = piece.rook_path?([7, 7], [7, 5], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a file path that is blocked, up to down' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[7][5] = :b_bishop
        playing_field[7][6] = :w_pawn
        playing_field[7][7] = :w_rook
        path_or_not = piece.rook_path?([7, 7], [7, 5], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #rook_path? and Rook#path? and related methods
    context 'when it is called with a file path that is blocked, down to up' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[7][0] = :w_rook
        playing_field[7][1] = :w_pawn
        playing_field[7][3] = :w_rook
        path_or_not = piece.rook_path?([7, 0], [7, 3], playing_field)
        expect(path_or_not).to eq(false)
      end
    end
  end

  describe '#bishop_path?' do
    context 'when the potential path is neither along a positive nor along a negative diagonal' do
      before do
        allow(piece).to receive(:along_positive_diagonal?).and_return(false)
        allow(piece).to receive(:along_negative_diagonal?).and_return(false)
      end

      it 'returns false' do
        path_or_not = piece.send(:bishop_path?, [1, 0], [1, 7], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the potential path is along a positive diagonal' do
      before do
        allow(piece).to receive(:along_positive_diagonal?).and_return(true)
        allow(piece).to receive(:along_negative_diagonal?).and_return(false)
      end

      it 'calls #positive_diagonal_free?' do
        expect(piece).to receive(:positive_diagonal_free?)
        piece.send(:bishop_path?, [1, 1], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a negative diagonal' do
      before do
        allow(piece).to receive(:along_positive_diagonal?).and_return(false)
        allow(piece).to receive(:along_negative_diagonal?).and_return(true)
      end

      it 'calls #negative_diagonal_free?' do
        expect(piece).to receive(:negative_diagonal_free?)
        piece.send(:bishop_path?, [1, 5], [5, 1], ['playing field'])
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a non-diagonal path' do
      it 'returns false' do
        path_or_not = piece.send(:bishop_path?, [0, 0], [0, 1], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a positive diagonal path that is open, left to right' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_bishop
        path_or_not = piece.send(:bishop_path?, [5, 0], [7, 2], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a positive diagonal path that is blocked, left to right' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_bishop
        playing_field[6][1] = :w_pawn
        playing_field[7][2] = :w_rook
        path_or_not = piece.send(:bishop_path?, [5, 0], [7, 2], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a positive diagonal path that is open, right to left' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][7] = :w_bishop
        playing_field[2][4] = :b_bishop
        path_or_not = piece.send(:bishop_path?, [5, 7], [2, 4], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a positive diagonal path that is blocked, right to left' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][7] = :w_bishop
        playing_field[4][6] = :w_pawn
        playing_field[2][4] = :b_bishop
        path_or_not = piece.send(:bishop_path?, [5, 7], [2, 4], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a negative diagonal path that is open, left to right' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[2][7] = :w_bishop
        playing_field[5][4] = :b_bishop
        path_or_not = piece.send(:bishop_path?, [2, 7], [5, 4], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a negative diagonal path that is blocked, left to right' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[2][7] = :w_bishop
        playing_field[3][6] = :w_pawn
        playing_field[5][4] = :b_bishop
        path_or_not = piece.send(:bishop_path?, [2, 7], [5, 4], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a negative diagonal path that is open, right to left' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_bishop
        path_or_not = piece.send(:bishop_path?, [5, 0], [3, 2], playing_field)
        expect(path_or_not).to eq(true)
      end
    end
    # integration test for the second line of #bishop_path? and Bishop#path? and related methods
    context 'when it is called with a negative diagonal path that is blocked, right to left' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_bishop
        playing_field[4][3] = :w_pawn
        playing_field[2][1] = :b_bishop
        path_or_not = piece.send(:bishop_path?, [5, 0], [2, 1], playing_field)
        expect(path_or_not).to eq(false)
      end
    end
  end

  describe '#queen_path?' do
    context 'when the potential path is neither along a rank nor along a file nor along a diagonal' do
      before do
        allow(piece).to receive(:along_rank_or_file_or_diagonal?).and_return(false)
      end

      it 'returns false' do
        path_or_not = piece.queen_path?([0, 0], [5, 5], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the potential path is along a rank' do
      before do
        allow(piece).to receive(:along_rank?).and_return(true)
        allow(piece).to receive(:along_file?).and_return(false)
      end

      it 'calls #rank_free?' do
        expect(piece).to receive(:rank_free?)
        piece.queen_path?([0, 0], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a file' do
      before do
        allow(piece).to receive(:along_rank?).and_return(false)
        allow(piece).to receive(:along_file?).and_return(true)
      end

      it 'calls #file_free?' do
        expect(piece).to receive(:file_free?)
        piece.queen_path?([0, 0], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a positive diagonal' do
      before do
        allow(piece).to receive(:along_positive_diagonal?).and_return(true)
        allow(piece).to receive(:along_negative_diagonal?).and_return(false)
      end

      it 'calls #positive_diagonal_free?' do
        expect(piece).to receive(:positive_diagonal_free?)
        piece.queen_path?([1, 1], [5, 5], ['playing field'])
      end
    end

    context 'when the potential path is along a negative diagonal' do
      before do
        allow(piece).to receive(:along_positive_diagonal?).and_return(false)
        allow(piece).to receive(:along_negative_diagonal?).and_return(true)
      end

      it 'calls #negative_diagonal_free?' do
        expect(piece).to receive(:negative_diagonal_free?)
        piece.queen_path?([1, 5], [5, 1], ['playing field'])
      end
    end
  end

  describe '#along_rank_or_file_or_diagonal?' do
    context 'when the potential path is neither along a rank nor along a file nor along a diagonal' do
      it 'returns false' do
        allow(piece).to receive(:along_rank?).and_return(false)
        allow(piece).to receive(:along_file?).and_return(false)
        allow(piece).to receive(:along_positive_diagonal?).and_return(false)
        allow(piece).to receive(:along_negative_diagonal?).and_return(false)
        along_any_or_none = piece.along_rank_or_file_or_diagonal?([0, 0], [1, 2])
        expect(along_any_or_none).to eq(false)
      end
    end

    context 'when the potential path is along a rank' do
      it 'returns false' do
        allow(piece).to receive(:along_rank?).and_return(true)
        allow(piece).to receive(:along_file?).and_return(false)
        allow(piece).to receive(:along_positive_diagonal?).and_return(false)
        allow(piece).to receive(:along_negative_diagonal?).and_return(false)
        along_any_or_none = piece.along_rank_or_file_or_diagonal?([0, 0], [2, 0])
        expect(along_any_or_none).to eq(true)
      end
    end

    context 'when the potential path is along a file' do
      it 'returns false' do
        allow(piece).to receive(:along_rank?).and_return(false)
        allow(piece).to receive(:along_file?).and_return(true)
        allow(piece).to receive(:along_positive_diagonal?).and_return(false)
        allow(piece).to receive(:along_negative_diagonal?).and_return(false)
        along_any_or_none = piece.along_rank_or_file_or_diagonal?([0, 0], [0, 3])
        expect(along_any_or_none).to eq(true)
      end
    end

    context 'when the potential path is along a positive slope diagonal' do
      it 'returns false' do
        allow(piece).to receive(:along_rank?).and_return(false)
        allow(piece).to receive(:along_file?).and_return(false)
        allow(piece).to receive(:along_positive_diagonal?).and_return(true)
        allow(piece).to receive(:along_negative_diagonal?).and_return(false)
        along_any_or_none = piece.along_rank_or_file_or_diagonal?([0, 0], [5, 5])
        expect(along_any_or_none).to eq(true)
      end
    end

    context 'when the potential path is along a negative slope diagonal' do
      it 'returns false' do
        allow(piece).to receive(:along_rank?).and_return(false)
        allow(piece).to receive(:along_file?).and_return(false)
        allow(piece).to receive(:along_positive_diagonal?).and_return(false)
        allow(piece).to receive(:along_negative_diagonal?).and_return(true)
        along_any_or_none = piece.along_rank_or_file_or_diagonal?([0, 7], [3, 4])
        expect(along_any_or_none).to eq(true)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with an impossible path' do
      it 'returns false' do
        path_or_not = piece.queen_path?([0, 0], [1, 2], ['playing field'])
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a rank path that is open, left to right' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][0] = :w_queen
        playing_field[4][0] = :b_bishop
        path_or_not = piece.queen_path?([0, 0], [4, 0], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a rank path that is blocked, left to right' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_queen
        playing_field[2][1] = :w_queen
        playing_field[4][1] = :b_bishop
        path_or_not = piece.queen_path?([0, 1], [4, 1], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a rank path that is blocked, right to left' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :b_bishop
        playing_field[6][0] = :w_queen
        playing_field[7][0] = :w_queen
        path_or_not = piece.queen_path?([7, 0], [5, 0], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a file path that is open, up to down' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[7][5] = :b_bishop
        playing_field[7][7] = :w_queen
        path_or_not = piece.queen_path?([7, 7], [7, 5], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a file path that is blocked, up to down' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[7][5] = :b_bishop
        playing_field[7][6] = :w_pawn
        playing_field[7][7] = :w_queen
        path_or_not = piece.queen_path?([7, 7], [7, 5], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a file path that is blocked, down to up' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[7][0] = :w_queen
        playing_field[7][1] = :w_pawn
        playing_field[7][3] = :w_queen
        path_or_not = piece.queen_path?([7, 0], [7, 3], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a positive diagonal path that is open, left to right' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_queen
        path_or_not = piece.queen_path?([5, 0], [7, 2], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a positive diagonal path that is blocked, left to right' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_queen
        playing_field[6][1] = :w_pawn
        playing_field[7][2] = :w_rook
        path_or_not = piece.queen_path?([5, 0], [7, 2], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a positive diagonal path that is open, right to left' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][7] = :w_queen
        playing_field[2][4] = :b_queen
        path_or_not = piece.queen_path?([5, 7], [2, 4], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a positive diagonal path that is blocked, right to left' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][7] = :w_queen
        playing_field[4][6] = :w_pawn
        playing_field[2][4] = :b_queen
        path_or_not = piece.queen_path?([5, 7], [2, 4], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a negative diagonal path that is open, left to right' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[2][7] = :w_queen
        playing_field[5][4] = :b_queen
        path_or_not = piece.queen_path?([2, 7], [5, 4], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a negative diagonal path that is blocked, left to right' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[2][7] = :w_queen
        playing_field[3][6] = :w_pawn
        playing_field[5][4] = :b_queen
        path_or_not = piece.queen_path?([2, 7], [5, 4], playing_field)
        expect(path_or_not).to eq(false)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a negative diagonal path that is open, right to left' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_queen
        path_or_not = piece.queen_path?([5, 0], [3, 2], playing_field)
        expect(path_or_not).to eq(true)
      end
    end

    # integration test for the second line of #queen_path? and Queen#path? and related methods
    context 'when it is called with a negative diagonal path that is blocked, right to left' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_queen
        playing_field[4][3] = :w_pawn
        playing_field[2][1] = :b_queen
        path_or_not = piece.queen_path?([5, 0], [2, 1], playing_field)
        expect(path_or_not).to eq(false)
      end
    end
  end

  describe '#king_path?' do
    context 'when the start and finish are more than one space apart' do
      it 'returns false' do
        path_or_not = piece.king_path?([4, 0], [6, 0], 'playing field')
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = piece.king_path?([4, 0], [4, 5], 'playing field')
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = piece.king_path?([1, 1], [3, 3], 'playing field')
        expect(path_or_not).to eq(false)
      end

      it 'returns false' do
        path_or_not = piece.king_path?([1, 2], [0, 0], 'playing field')
        expect(path_or_not).to eq(false)
      end
    end

    context 'when the start and finish are one space apart' do
      it 'returns true' do
        path_or_not = piece.king_path?([4, 0], [5, 0], 'playing field')
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = piece.king_path?([4, 0], [4, 1], 'playing field')
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = piece.king_path?([1, 1], [2, 2], 'playing field')
        expect(path_or_not).to eq(true)
      end

      it 'returns true' do
        path_or_not = piece.king_path?([1, 2], [2, 3], 'playing field')
        expect(path_or_not).to eq(true)
      end
    end
  end

  describe '#knight_path?' do
    context 'when the start and finish are not an L apart from each other' do
      it 'returns true' do
        allow(piece).to receive(:vertical_l?).and_return(false)
        allow(piece).to receive(:horizontal_l?).and_return(false)
        expect(piece).to receive(:knight_path?).and_return(false)
        piece.knight_path?('start', 'finish', 'playing_field')
      end
    end
  end

  describe '#vertical_l?' do
    context 'when the start and finish are a vertical L apart' do
      it 'returns true' do
        vertical_l_or_not = piece.vertical_l?([4, 0], [5, 2])
        expect(vertical_l_or_not).to eq(true)
      end

      it 'returns true' do
        vertical_l_or_not = piece.vertical_l?([4, 5], [5, 3])
        expect(vertical_l_or_not).to eq(true)
      end

      it 'returns true' do
        vertical_l_or_not = piece.vertical_l?([2, 3], [1, 1])
        expect(vertical_l_or_not).to eq(true)
      end

      it 'returns true' do
        vertical_l_or_not = piece.vertical_l?([5, 6], [4, 8])
        expect(vertical_l_or_not).to eq(true)
      end
    end

    context 'when the start and finish are not a vertical L apart' do
      it 'returns false' do
        vertical_l_or_not = piece.vertical_l?([0, 0], [5, 2])
        expect(vertical_l_or_not).to eq(false)
      end
    end
  end

  describe '#horizontal_l?' do
    context 'when the start and finish are a horizontal L apart' do
      it 'returns true' do
        horizontal_l_or_not = piece.horizontal_l?([4, 0], [2, 1])
        expect(horizontal_l_or_not).to eq(true)
      end

      it 'returns true' do
        horizontal_l_or_not = piece.horizontal_l?([7, 7], [5, 6])
        expect(horizontal_l_or_not).to eq(true)
      end

      it 'returns true' do
        horizontal_l_or_not = piece.horizontal_l?([0, 2], [2, 3])
        expect(horizontal_l_or_not).to eq(true)
      end

      it 'returns true' do
        horizontal_l_or_not = piece.horizontal_l?([6, 2], [8, 1])
        expect(horizontal_l_or_not).to eq(true)
      end
    end

    context 'when the start and finish are not a horizontal L apart' do
      it 'returns false' do
        horizontal_l_or_not = piece.horizontal_l?([4, 4], [6, 6])
        expect(horizontal_l_or_not).to eq(false)
      end
    end
  end

  describe '#white_pawn_path?' do
    context 'when it is called' do
      it 'creates an instance of Pawn' do
        piece.white_pawn_path?([0, 1], [0, 2], ['playing field'], 'column')
        pawn = piece.instance_variable_get(:@pawn)
        expect(pawn).to be_a(Pawn)
      end
    end
  end

  describe '#black_pawn_path?' do
    context 'when it is called' do
      it 'creates an instance of Pawn' do
        piece.black_pawn_path?([0, 7], [0, 6], ['playing field'], 'column')
        pawn = piece.instance_variable_get(:@pawn)
        expect(pawn).to be_a(Pawn)
      end
    end
  end

  describe '#rank_free?' do
    context 'when there is a clear path between the start and finish squares along a rank' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][0] = :w_rook
        playing_field[1][0] = :b_rook
        rank_free_or_not = piece.rank_free?([4, 0], [1, 0], playing_field)
        expect(rank_free_or_not).to eq(true)
      end
    end

    context 'when there is not a clear path between the start and finish squares along a rank' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_rook
        playing_field[3][0] = :w_pawn
        playing_field[1][0] = :b_bishop
        rank_free_or_not = piece.rank_free?([5, 0], [1, 0], playing_field)
        expect(rank_free_or_not).to eq(false)
      end
    end
  end

  describe '#file_free?' do
    context 'when there is a clear path between the start and finish squares along a file' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_rook
        file_free_or_not = piece.file_free?([0, 1], [0, 5], playing_field)
        expect(file_free_or_not).to eq(true)
      end
    end

    context 'when there is not a clear path between the start and finish squares along a file' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_rook
        playing_field[0][3] = :w_pawn
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

  describe '#positive_diagonal_free?' do
    context 'when there is a clear path between the start and finish squares along a positive diagonal' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][0] = :w_bishop
        playing_field[7][3] = :b_rook
        positive_diagonal_free_or_not = piece.positive_diagonal_free?([4, 0], [7, 3], playing_field)
        expect(positive_diagonal_free_or_not).to eq(true)
      end
    end

    context 'when there is not a clear path between the start and finish squares along a positive diagonal' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][0] = :w_bishop
        playing_field[6][1] = :w_pawn
        playing_field[7][2] = :b_bishop
        positive_diagonal_free_or_not = piece.positive_diagonal_free?([5, 0], [7, 2], playing_field)
        expect(positive_diagonal_free_or_not).to eq(false)
      end
    end
  end

  describe '#negative_diagonal_free?' do
    context 'when there is a clear path between the start and finish squares along a negative_diagonal' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][1] = :w_bishop
        negative_diagonal_free_or_not = piece.negative_diagonal_free?([5, 1], [0, 6], playing_field)
        expect(negative_diagonal_free_or_not).to eq(true)
      end
    end

    context 'when there is not a clear path between the start and finish squares along a negative_diagonal' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[5][1] = :w_bishop
        playing_field[4][2] = :w_pawn
        negative_diagonal_free_or_not = piece.negative_diagonal_free?([5, 1], [0, 6], playing_field)
        expect(negative_diagonal_free_or_not).to eq(false)
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
