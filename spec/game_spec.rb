# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do
  subject(:game) { described_class.new }
  describe '#initialize' do
    context 'when the game class is instantiated' do
      it 'creates an instance of Board' do
        board = game.instance_variable_get(:@board)
        expect(board).to be_a(Board)
        game.send(:initialize)
      end

      it 'creates an instance of Piece' do
        piece = game.instance_variable_get(:@piece)
        expect(piece).to be_a(Piece)
        game.send(:initialize)
      end

      it 'calls #initial_playing_field' do
        expect(game).to receive(:initial_playing_field)
        game.send(:initialize)
      end
    end
  end

  describe '#initial_playing_field' do
    context 'when playing field is created' do
      it 'has the pieces and empty squares set up correctly' do
        field = game.instance_variable_get(:@playing_field)
        expect(field).to eq([[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                             [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                             [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                             [:w_queen, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                             [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                             [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                             [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                             [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]])
        game.initial_playing_field
      end
    end
  end

  describe '#move_piece' do
    context 'when a white rook is moved from a1 to a4 legally and does not capture' do
      before do
        allow(game).to receive(:valid_move?).and_return(true)
        allow(game).to receive(:capture).and_return(nil)
      end

      it 'returns nil' do
        move = game.move_piece([0, 0], [0, 3])
        expect(move).to eq(nil)
      end

      it 'leaves a1 empty' do
        game.move_piece([0, 0], [0, 3])
        space = game.instance_variable_get(:@playing_field)[0][0]
        expect(space).to eq(nil)
      end
      it 'puts a white rook in a4' do
        game.move_piece([0, 0], [0, 3])
        space = game.instance_variable_get(:@playing_field)[0][3]
        expect(space).to eq(:w_rook)
      end
    end

    context 'when a white rook attempts to move from a1 to a4 illegally' do
      it 'returns :invalid' do
        allow(game).to receive(:valid_move?).and_return(false)
        move = game.move_piece([0, 0], [0, 3])
        expect(move).to eq(:invalid)
      end
    end

    context 'when a black pawn is moved from g7 to h6 legally and captures a rook' do
      before do
        allow(game).to receive(:valid_move?).and_return(true)
        allow(game).to receive(:capture).and_return(:w_rook)
        game.instance_variable_get(:@playing_field)[7][5] = :w_rook
      end

      it 'returns :w_rook' do
        move = game.move_piece([6, 6], [7, 5])
        expect(move).to eq(:w_rook)
      end

      it 'leaves g7 empty' do
        game.move_piece([6, 6], [7, 5])
        space = game.instance_variable_get(:@playing_field)[6][6]
        expect(space).to eq(nil)
      end

      it 'puts a black pawn in h6' do
        game.move_piece([6, 6], [7, 5])
        space = game.instance_variable_get(:@playing_field)[7][5]
        expect(space).to eq(:b_pawn)
      end
    end
  end

  describe '#valid_move?' do
    context 'when the start and finish square are the same' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 0], [0, 0])
        expect(valid_or_not).to eq(false)
      end

      it 'returns false' do
        valid_or_not = game.valid_move?([4, 5], [4, 5])
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #on_playing_field as well
    context 'when the start coordinates are not on the playing field' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, -1], [0, 5])
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #on_playing_field as well
    context 'when the end coordinates are not on the playing field' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 1], [0, 8])
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #on_playing_field as well
    context 'when neither the start nor the end coordinates are on the playing field' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, -1], [0, 8])
        expect(valid_or_not).to eq(false)
      end
    end

    context 'when the pieces are the same color' do
      it 'returns false' do
        allow(game).to receive(:finish_space_valid?).and_return(false)
        valid_or_not = game.valid_move?([0, 0], [0, 1])
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests SYMBOL_TO_METHOD hash and tests that Piece#rook_path exists
    context 'when the pieces are not the same color and #rook_path? is false' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns false' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:finish_space_valid?).and_return(false)
        allow(piece_valid).to receive(:rook_path?).and_return(false)
        valid_or_not = game.valid_move?([0, 0], [0, 1])
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests SYMBOL_TO_METHOD hash and tests that Piece#rook_path exists
    context 'when the pieces are not the same color and #rook_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:finish_space_valid?).and_return(true)
        allow(piece_valid).to receive(:rook_path?).and_return(true)
        valid_or_not = game.valid_move?([0, 0], [0, 1])
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests SYMBOL_TO_METHOD hash and tests that Piece#knight_path exists
    context 'when the pieces are not the same color and #knight_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:finish_space_valid?).and_return(true)
        allow(piece_valid).to receive(:knight_path?).and_return(true)
        valid_or_not = game.valid_move?([1, 0], [2, 2])
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests SYMBOL_TO_METHOD hash and tests that Piece#queen_path exists
    context 'when the pieces are not the same color and #queen_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:finish_space_valid?).and_return(true)
        allow(piece_valid).to receive(:queen_path?).and_return(true)
        valid_or_not = game.valid_move?([3, 0], [4, 0])
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests SYMBOL_TO_METHOD hash and tests that Piece#queen_path exists
    context 'when the pieces are not the same color and #w_pawn_path? is false' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:finish_space_valid?).and_return(true)
        allow(piece_valid).to receive(:white_pawn_path?).and_return(true)
        valid_or_not = game.valid_move?([3, 1], [3, 2])
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests SYMBOL_TO_METHOD hash and tests that Piece#queen_path exists
    context 'when the pieces are not the same color and #king_path? is false' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns false' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:finish_space_valid?).and_return(true)
        allow(piece_valid).to receive(:king_path?).and_return(false)
        valid_or_not = game.valid_move?([4, 0], [1, 0])
        expect(valid_or_not).to eq(false)
      end
    end
  end

  describe '#on_playing_field?' do
    context 'when [-1, -1] is passed' do
      it 'returns false' do
        is_not_on_playing_field = game.on_playing_field?([-1, -1])
        expect(is_not_on_playing_field).to eq(false)
      end
    end

    context 'when [3, 1] is passed' do
      it 'returns true' do
        is_on_playing_field = game.on_playing_field?([3, 1])
        expect(is_on_playing_field).to eq(true)
      end
    end

    context 'when [8, 9] is passed' do
      it 'returns false' do
        is_not_on_playing_field = game.on_playing_field?([8, 9])
        expect(is_not_on_playing_field).to eq(false)
      end
    end

    context 'when [7, 7] is passed' do
      it 'returns true' do
        is_on_playing_field = game.on_playing_field?([7, 7])
        expect(is_on_playing_field).to eq(true)
      end
    end
  end

  describe '#finish_space_valid?' do
    context 'when the finish space is nil' do
      it 'returns true' do
        finish_space_valid_or_not = game.finish_space_valid?(:b_rook, nil)
        expect(finish_space_valid_or_not).to eq(true)
      end
    end

    context 'when the pieces are the same color' do
      it 'returns false' do
        finish_space_valid_or_not = game.finish_space_valid?(:b_rook, :b_rook)
        expect(finish_space_valid_or_not).to eq(false)
      end
    end

    context 'when the pieces are different colors' do
      it 'returns true' do
        finish_space_valid_or_not = game.finish_space_valid?(:b_rook, :w_rook)
        expect(finish_space_valid_or_not).to eq(true)
      end
    end
  end

  describe 'path_method_from_piece' do
    context 'when a white pawn is passed in' do
      it 'returns :white_pawn_path?' do
        method = game.path_method_from_piece(:w_pawn)
        expect(method).to eq('white_pawn_path?')
      end
    end

    context 'when a black pawn is passed in' do
      it 'returns :black_pawn_path?' do
        method = game.path_method_from_piece(:b_pawn)
        expect(method).to eq('black_pawn_path?')
      end
    end

    context 'when a white rook is passed in' do
      it 'returns :rook_path?' do
        method = game.path_method_from_piece(:w_rook)
        expect(method).to eq('rook_path?')
      end
    end

    context 'when a black king is passed in' do
      it 'returns :king_path?' do
        method = game.path_method_from_piece(:b_king)
        expect(method).to eq('king_path?')
      end
    end
  end

  describe 'capture' do
    context 'when the finish square is empty' do
      it 'returns nil' do
        game.instance_variable_get(:@playing_field)[7][5] = nil
        capture_or_none = game.capture([7, 5])
        expect(capture_or_none).to eq(nil)
      end
    end

    context 'when the finish square has a white rook on it' do
      it 'returns :w_rook' do
        game.instance_variable_get(:@playing_field)[7][5] = :w_rook
        capture_or_none = game.capture([7, 5])
        expect(capture_or_none).to eq(:w_rook)
      end
    end
  end

  describe '#player_move_to_start_finish' do
    context 'when "a1a3" is passed in' do
      it 'returns [[0, 0], [0, 2]]' do
        start_finish = game.player_move_to_start_finish('a1a3')
        expect(start_finish).to eq([[0, 0], [0, 2]])
      end
    end

    context 'when "h7f5" is passed in' do
      it 'returns [[7, 6], [5, 4]]' do
        start_finish = game.player_move_to_start_finish('h7f5')
        expect(start_finish).to eq([[7, 6], [5, 4]])
      end
    end
  end

  describe '#playing_field_to_board' do
    let(:board_field) { instance_double(Board) }
    context 'when a playing field is passed in' do
      it 'calls Board#overwrite_playing_field with the playing field' do
        game.instance_variable_set(:@board, board_field)
        playing_field = [[:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_queen, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_queen],
                         [:w_king, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_king],
                         [:w_bishop, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_bishop],
                         [:w_knight, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_knight],
                         [:w_rook, :w_pawn, nil, nil, nil, nil, :b_pawn, :b_rook]]
        expect(board_field).to receive(:overwrite_playing_field).with(playing_field)
        game.playing_field_to_board(playing_field)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
