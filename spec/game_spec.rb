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

      it 'creates an instance of Player' do
        player = game.instance_variable_get(:@player)
        expect(player).to be_a(Player)
        game.send(:initialize)
      end

      it 'sets @current_player to :white' do
        current_player = game.instance_variable_get(:@current_player)
        expect(current_player).to eq(:white)
        game.send(:initialize)
      end

      it 'sets @resignation to false' do
        resignation = game.instance_variable_get(:@resignation)
        expect(resignation).to eq(false)
        game.send(:initialize)
      end

      it 'creates @captured_pieces' do
        captured_pieces = game.instance_variable_get(:@captured_pieces)
        initial_captured = [[nil, nil, nil, nil, nil, nil, nil, nil],
                            [nil, nil, nil, nil, nil, nil, nil, nil],
                            [nil, nil, nil, nil, nil, nil, nil, nil],
                            [nil, nil, nil, nil, nil, nil, nil, nil]]
        expect(captured_pieces).to eq(initial_captured)
        game.send(:initialize)
      end

      it 'sets @en_passant_column to nil' do
        column = game.instance_variable_get(:@en_passant_column)
        expect(column).to eq(nil)
        game.send(:initialize)
      end

      it 'calls #update_castling_piece_states)' do
        expect(game).to receive(:update_castling_piece_states)
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

  describe '#display_board' do
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
        expect(board_field).to receive(:add_captured_pieces)
        game.display_board
      end
    end

    context 'when captured pieces are passed in' do
      it 'calls Board#add_captured_pieces with the playing field' do
        game.instance_variable_set(:@board, board_field)
        captured_pieces = [[nil, nil, nil, nil, nil, nil, nil, nil],
                           [nil, nil, nil, nil, nil, nil, nil, nil],
                           [nil, nil, nil, nil, nil, nil, nil, nil],
                           [nil, nil, nil, nil, nil, nil, nil, nil]]
        expect(board_field).to receive(:overwrite_playing_field)
        expect(board_field).to receive(:add_captured_pieces).with(captured_pieces)
        game.display_board
      end
    end
  end

  describe '#resignation?' do
    context 'when "q" is entered' do
      it 'sets @resignation to true' do
        game.resignation?('q')
        resignation_or_not = game.instance_variable_get(:@resignation)
        expect(resignation_or_not).to eq(true)
      end
    end

    context 'when "Q" is entered' do
      it 'sets @resignation to true' do
        game.resignation?('Q')
        resignation_or_not = game.instance_variable_get(:@resignation)
        expect(resignation_or_not).to eq(true)
      end
    end

    context 'when "garbage" is entered' do
      it 'does not set resignation to true' do
        game.resignation?('garbage')
        resignation_or_not = game.instance_variable_get(:@resignation)
        expect(resignation_or_not).to eq(false)
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

  describe '#move_piece' do
    context 'when a white rook is moved from a1 to a4 legally and does not capture' do
      before do
        allow(game).to receive(:valid_move?).and_return(true)
        allow(game).to receive(:reassign_squares).and_return(nil)
        allow(game).to receive(:in_check?).and_return(false)
      end

      it 'returns nil' do
        move = game.move_piece([0, 0], [0, 3])
        expect(move).to eq(nil)
      end
    end

    context 'when a white rook attempts to move from a1 to a4 illegally' do
      it 'returns :invalid' do
        allow(game).to receive(:valid_move?).and_return(false)
        move = game.move_piece([0, 0], [0, 3])
        expect(move).to eq(:invalid)
      end
    end

    # integration tests - test #reassign_squares as well
    context 'when a black pawn is moved from g7 to h6 legally and captures a rook' do
      before do
        allow(game).to receive(:valid_move?).and_return(true)
        allow(game).to receive(:in_check?).and_return(false)
        game.instance_variable_get(:@playing_field)[7][5] = :w_rook
      end

      it 'returns nil' do
        move = game.move_piece([6, 6], [7, 5])
        expect(move).to eq(nil)
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

    context 'when the black king is moved from g7 to h6 legally and moves into check' do
      before do
        allow(game).to receive(:valid_move?).and_return(true)
        allow(game).to receive(:reassign_squares).and_return(:w_rook)
        allow(game).to receive(:in_check?).and_return(true)
        game.instance_variable_get(:@playing_field)[6][6] = :b_king
      end

      it 'returns :invalid' do
        move = game.move_piece([6, 6], [7, 5])
        expect(move).to eq(:invalid)
      end

      it 'resets the board' do
        game.move_piece([6, 6], [7, 5])
        original_king_spot = game.instance_variable_get(:@playing_field)[6][6]
        expect(original_king_spot).to eq(:b_king)
      end
    end
  end

  describe '#reassign_squares' do
    context 'when en passant column is nil' do
      it 'calls #move_and_capture' do
        game.instance_variable_set(:@en_passant_column, nil)
        expect(game).to receive(:move_and_capture)
        game.reassign_squares('start', 'finish')
      end
    end

    context 'when en passant column is not nil and en passant conditions are not met' do
      it 'calls #move_and_capture' do
        game.instance_variable_set(:@en_passant_column, 3)
        allow(game).to receive(:meets_en_passant_conditions?).and_return(false)
        expect(game).to receive(:move_and_capture)
        game.reassign_squares('start', 'finish')
      end
    end

    context 'when en passant column is not nil and en passant conditions are met' do
      it 'calls #move_and_capture' do
        game.instance_variable_set(:@en_passant_column, 3)
        allow(game).to receive(:meets_en_passant_conditions?).and_return(true)
        expect(game).to receive(:move_and_capture)
        game.reassign_squares('start', 'finish')
      end
    end
  end

  # integration tests - test helper methods as well
  describe '#reassign_squares' do
    context 'when a white rook is moved from a1 to a4 legally and does not capture' do
      it 'returns nil' do
        reassign = game.reassign_squares([0, 0], [0, 3])
        expect(reassign).to eq(nil)
      end

      it 'leaves a1 empty' do
        game.reassign_squares([0, 0], [0, 3])
        space = game.instance_variable_get(:@playing_field)[0][0]
        expect(space).to eq(nil)
      end

      it 'puts a white rook in a4' do
        game.reassign_squares([0, 0], [0, 3])
        space = game.instance_variable_get(:@playing_field)[0][3]
        expect(space).to eq(:w_rook)
      end
    end

    context 'when a black pawn is moved from g7 to h6 legally and captures a rook' do
      it 'returns :w_rook' do
        game.instance_variable_get(:@playing_field)[7][5] = :w_rook
        reassign = game.reassign_squares([6, 6], [7, 5])
        expect(reassign).to eq(:w_rook)
      end

      it 'leaves g7 empty' do
        game.reassign_squares([6, 6], [7, 5])
        space = game.instance_variable_get(:@playing_field)[6][6]
        expect(space).to eq(nil)
      end

      it 'puts a black pawn in h6' do
        game.reassign_squares([6, 6], [7, 5])
        space = game.instance_variable_get(:@playing_field)[7][5]
        expect(space).to eq(:b_pawn)
      end
    end

    context 'when a black pawn is moved from g4 to h3 legally and captures en passant' do
      it 'returns :w_pawn' do
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_set(:@en_passant_column, 7)
        game.instance_variable_get(:@playing_field)[6][3] = :b_pawn
        game.instance_variable_get(:@playing_field)[7][3] = :w_pawn
        reassign = game.reassign_squares([6, 3], [7, 2])
        expect(reassign).to eq(:w_pawn)
      end

      it 'leaves g4 empty' do
        game.instance_variable_set(:@en_passant_column, 7)
        game.instance_variable_get(:@playing_field)[6][3] = :b_pawn
        game.instance_variable_get(:@playing_field)[7][3] = :w_pawn
        game.reassign_squares([6, 3], [7, 2])
        space = game.instance_variable_get(:@playing_field)[6][3]
        expect(space).to eq(nil)
      end

      it 'puts a black pawn in h3' do
        game.instance_variable_set(:@en_passant_column, 7)
        game.instance_variable_get(:@playing_field)[6][3] = :b_pawn
        game.instance_variable_get(:@playing_field)[7][3] = :w_pawn
        game.reassign_squares([6, 3], [7, 2])
        space = game.instance_variable_get(:@playing_field)[7][2]
        expect(space).to eq(:b_pawn)
      end
    end
  end

  # integration tests - test helper methods as well
  describe '#move_and_capture' do
    context 'when a white rook is moved from a1 to a4 legally and does not capture' do
      it 'returns nil' do
        captured = game.move_and_capture([0, 0], [0, 3])
        expect(captured).to eq(nil)
      end
    end

    context 'when a white rook is moved from a1 to a4 legally and captures a black rook' do
      it 'returns :b_rook' do
        game.instance_variable_get(:@playing_field)[0][3] = :b_rook
        captured = game.move_and_capture([0, 0], [0, 3])
        expect(captured).to eq(:b_rook)
      end
    end

    context 'when a white pawn is moved from a5 to b6 legally and captures en passant' do
      it 'returns :b_pawn' do
        game.instance_variable_get(:@playing_field)[0][4] = :w_pawn
        game.instance_variable_get(:@playing_field)[1][4] = :b_pawn
        captured = game.move_and_capture([0, 4], [1, 5], true)
        expect(captured).to eq(:b_pawn)
      end
    end

    context 'when a white pawn tries to capture en passant but en passant is not set true' do
      it 'returns nil' do
        game.instance_variable_get(:@playing_field)[0][4] = :w_pawn
        game.instance_variable_get(:@playing_field)[1][4] = :b_pawn
        captured = game.move_and_capture([0, 4], [1, 5])
        expect(captured).to eq(nil)
      end
    end
  end

  describe '#en_passant_or_standard_capture' do
    context 'when en passant is true' do
      it 'returns the piece in the next square over' do
        game.instance_variable_get(:@playing_field)[0][4] = :w_pawn
        game.instance_variable_get(:@playing_field)[1][4] = :b_pawn
        captured = game.en_passant_or_standard_capture([0, 4], [1, 5], true)
        expect(captured).to eq(:b_pawn)
      end
    end

    context 'when en passant is not true and a pawn captures in the standard way' do
      it 'returns the captured piece' do
        game.instance_variable_get(:@playing_field)[0][4] = :w_pawn
        game.instance_variable_get(:@playing_field)[1][5] = :b_pawn
        captured = game.en_passant_or_standard_capture([0, 4], [1, 5], false)
        expect(captured).to eq(:b_pawn)
      end
    end

    context 'when en passant is not true and a white rook is moved from a1 to a4 without capturing' do
      it 'returns nil' do
        captured = game.en_passant_or_standard_capture([0, 0], [0, 3], false)
        expect(captured).to eq(nil)
      end
    end

    context 'when en passant is not true and a white rook is moved from a1 to a4 and captures a black rook' do
      it 'returns :b_rook' do
        game.instance_variable_get(:@playing_field)[0][3] = :b_rook
        captured = game.en_passant_or_standard_capture([0, 0], [0, 3], false)
        expect(captured).to eq(:b_rook)
      end
    end
  end

  describe '#standard_capture' do
    context 'when the finish square is empty' do
      it 'returns nil' do
        game.instance_variable_get(:@playing_field)[7][5] = nil
        standard_capture_or_none = game.standard_capture([7, 5])
        expect(standard_capture_or_none).to eq(nil)
      end
    end

    context 'when the finish square has a white rook on it' do
      it 'returns :w_rook' do
        game.instance_variable_get(:@playing_field)[7][5] = :w_rook
        standard_capture_or_none = game.standard_capture([7, 5])
        expect(standard_capture_or_none).to eq(:w_rook)
      end
    end
  end

  describe '#add_to_captured_pieces' do
    context 'when a white queen is added as the first piece captured' do
      it 'adds the queen to the correct array' do
        capture_update = [[nil, nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil, nil],
                          [:w_queen, nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil, nil]]
        captured_pieces = game.instance_variable_get(:@captured_pieces)
        game.add_to_captured_pieces(:w_queen)
        expect(captured_pieces).to eq(capture_update)
      end
    end

    context 'when a black rook is added as the first piece captured' do
      it 'adds the rook to the correct array' do
        capture_update = [[:b_rook, nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil, nil]]
        captured_pieces = game.instance_variable_get(:@captured_pieces)
        game.add_to_captured_pieces(:b_rook)
        expect(captured_pieces).to eq(capture_update)
      end
    end
    context 'when a white bishop is added as the tenth piece captured' do
      it 'adds the rook to the correct array' do
        previous_captures = [[nil, nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil, nil],
                             %i[w_pawn w_pawn w_pawn w_knight w_pawn w_pawn w_pawn w_knight],
                             [:w_rook, nil, nil, nil, nil, nil, nil]]
        game.instance_variable_set(:@captured_pieces, previous_captures)
        captured_pieces = game.instance_variable_get(:@captured_pieces)
        capture_update = [[nil, nil, nil, nil, nil, nil, nil, nil],
                          [nil, nil, nil, nil, nil, nil, nil, nil],
                          %i[w_pawn w_pawn w_pawn w_knight w_pawn w_pawn w_pawn w_knight],
                          [:w_bishop, :w_rook, nil, nil, nil, nil, nil]]
        game.add_to_captured_pieces(:w_bishop)
        expect(captured_pieces).to eq(capture_update)
      end
    end
  end

  describe '#valid_move?' do
    context 'when the start and finish square are the same' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 0], [0, 0], 'color')
        expect(valid_or_not).to eq(false)
      end

      it 'returns false' do
        valid_or_not = game.valid_move?([4, 5], [4, 5], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #on_playing_field? as well
    context 'when the start coordinates are not on the playing field' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, -1], [0, 5], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #on_playing_field? as well
    context 'when the end coordinates are not on the playing field' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 1], [0, 8], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #on_playing_field? as well
    context 'when neither the start nor the end coordinates are on the playing field' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, -1], [0, 8], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #start_and_finish_squares_valid? as well
    context 'when the pieces are the same color' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 0], [0, 1], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #start_and_finish_squares_valid? as well
    context 'when the start piece is nil' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 2], [0, 1], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #start_and_finish_squares_valid? as well
    context 'when the finish piece is nil' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 0], [0, 2], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests Board#overwrite_playing_field and #call_path_method_in_piece_class
    # and tests that Piece#rook_path exists
    context 'when both spaces are valid and the color is correct and #rook_path? is false' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns false' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_squares_valid?).and_return(true)
        allow(piece_valid).to receive(:rook_path?).and_return(false)
        valid_or_not = game.valid_move?([0, 0], [0, 1], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests Board#overwrite_playing_field and #call_path_method_in_piece_class
    # and tests that Piece#rook_path exists
    context 'when both spaces are valid and the color is correct and #rook_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_squares_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:rook_path?).and_return(true)
        valid_or_not = game.valid_move?([0, 0], [0, 1], 'color')
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests Board#overwrite_playing_field and #call_path_method_in_piece_class
    # and tests that Piece#knight_path exists
    context 'when both spaces are valid and the color is correct and #knight_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_squares_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:knight_path?).and_return(true)
        valid_or_not = game.valid_move?([1, 0], [2, 2], 'color')
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests Board#overwrite_playing_field and #call_path_method_in_piece_class
    # and tests that Piece#queen_path exists
    context 'when both spaces are valid and the color is correct and #queen_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_squares_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:queen_path?).and_return(true)
        valid_or_not = game.valid_move?([3, 0], [4, 0], 'color')
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests Board#overwrite_playing_field and #call_path_method_in_piece_class
    # and tests that Piece#white_pawn_path exists
    context 'when both spaces are valid and the color is correct and #white_pawn_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_squares_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:white_pawn_path?).and_return(true)
        valid_or_not = game.valid_move?([3, 1], [3, 2], 'color')
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests Board#overwrite_playing_field and #call_path_method_in_piece_class
    # and tests that Piece#king_path exists
    context 'when both spaces are valid and the color is correct and #king_path? is false' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns false' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_squares_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:king_path?).and_return(false)
        valid_or_not = game.valid_move?([4, 0], [1, 0], 'color')
        expect(valid_or_not).to eq(false)
      end
    end
  end

  describe '#correct_color?' do
    context 'when the start piece is white and white is passed in' do
      it 'returns true' do
        correct_color_or_not = game.correct_color?([0, 1], :white)
        expect(correct_color_or_not).to eq(true)
      end
    end

    context 'when the start piece is white and black is passed in' do
      it 'returns false' do
        correct_color_or_not = game.correct_color?([0, 1], :black)
        expect(correct_color_or_not).to eq(false)
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

  describe '#start_and_finish_squares_valid?' do
    context 'when the start piece is nil and the finish space is valid' do
      it 'returns false' do
        allow(game).to receive(:finish_square_valid?).and_return(true)
        start_and_finish_squares_valid_or_not = game.start_and_finish_squares_valid?([0, 2], [0, 3])
        expect(start_and_finish_squares_valid_or_not).to eq(false)
      end
    end

    context 'when the start piece is not nil and the finish space is valid' do
      it 'returns true' do
        allow(game).to receive(:finish_square_valid?).and_return(true)
        start_and_finish_squares_valid_or_not = game.start_and_finish_squares_valid?([0, 1], [0, 3])
        expect(start_and_finish_squares_valid_or_not).to eq(true)
      end
    end

    context 'when the start piece is not nil and the finish space is not valid' do
      it 'returns false' do
        allow(game).to receive(:finish_square_valid?).and_return(false)
        start_and_finish_squares_valid_or_not = game.start_and_finish_squares_valid?([0, 1], [0, 3])
        expect(start_and_finish_squares_valid_or_not).to eq(false)
      end
    end
  end

  describe '#finish_square_valid?' do
    context 'when the finish piece is nil' do
      it 'returns true' do
        finish_square_valid_or_not = game.finish_square_valid?(:b_rook, nil)
        expect(finish_square_valid_or_not).to eq(true)
      end
    end

    context 'when the pieces are the same color' do
      it 'returns false' do
        finish_square_valid_or_not = game.finish_square_valid?(:b_rook, :b_rook)
        expect(finish_square_valid_or_not).to eq(false)
      end
    end

    context 'when the pieces are different colors' do
      it 'returns true' do
        finish_square_valid_or_not = game.finish_square_valid?(:b_rook, :w_rook)
        expect(finish_square_valid_or_not).to eq(true)
      end
    end
  end

  describe 'path_method_from_piece' do
    context 'when a white pawn is passed in' do
      it 'returns "white_pawn_path?"' do
        method = game.path_method_from_piece(:w_pawn)
        expect(method).to eq('white_pawn_path?')
      end
    end

    context 'when a black pawn is passed in' do
      it 'returns "black_pawn_path?"' do
        method = game.path_method_from_piece(:b_pawn)
        expect(method).to eq('black_pawn_path?')
      end
    end

    context 'when a white rook is passed in' do
      it 'returns "rook_path?"' do
        method = game.path_method_from_piece(:w_rook)
        expect(method).to eq('rook_path?')
      end
    end

    context 'when a black king is passed in' do
      it 'returns "king_path?"' do
        method = game.path_method_from_piece(:b_king)
        expect(method).to eq('king_path?')
      end
    end

    # integration test - tests #path_method_from_pawn as well
    context 'when a white pawn is passed in and it is not en passant' do
      it 'returns "white_pawn_path?"' do
        method = game.path_method_from_piece(:w_pawn)
        expect(method).to eq('white_pawn_path?')
      end
    end
  end

  # integration test that also tests #king_location and #under_attack and #valid_move?
  describe '#in_check?' do
    before do
      blank_playing_field = Array.new(8) { Array.new(8) { nil } }
      game.instance_variable_set(:@playing_field, blank_playing_field)
    end

    context 'when the white king is in check and it is white\'s turn' do
      it 'returns true' do
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[1][3] = :b_bishop
        game.instance_variable_set(:@current_player, :white)
        check_or_not = game.in_check?
        expect(check_or_not).to eq(true)
      end
    end
  end

  describe '#in_check?' do
    before do
      allow(game).to receive(:under_attack?).and_return(true)
    end

    context 'when the white king is in check' do
      it 'returns true' do
        game.instance_variable_set(:@current_player, :white)
        check_or_not = game.in_check?
        expect(check_or_not).to eq(true)
      end
    end
  end

  describe '#king_location' do
    before do
      blank_playing_field = Array.new(8) { Array.new(8) { nil } }
      game.instance_variable_set(:@playing_field, blank_playing_field)
    end

    context 'when the white king is on e1 (initial) and it is white\'s turn' do
      it 'returns [4, 0]' do
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_set(:@current_player, :white)
        current_square = game.king_location
        expect(current_square).to eq([4, 0])
      end
    end

    context 'when the white king is on a1 and it is white\'s turn' do
      it 'returns [4, 0]' do
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_set(:@current_player, :white)
        current_square = game.king_location
        expect(current_square).to eq([0, 0])
      end
    end

    context 'when the black king is on b7 and it is black\'s turn' do
      it 'returns [1, 6]' do
        game.instance_variable_get(:@playing_field)[1][6] = :b_king
        game.instance_variable_set(:@current_player, :black)
        current_square = game.king_location
        expect(current_square).to eq([1, 6])
      end
    end
  end

  # integration tests that also test #valid_move?
  describe '#under_attack?' do
    before do
      blank_playing_field = Array.new(8) { Array.new(8) { nil } }
      game.instance_variable_set(:@playing_field, blank_playing_field)
    end

    context 'when the white king is on e1 and under attack and it is white\'s turn' do
      it 'returns true' do
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[6][2] = :b_bishop
        under_attack_or_not = game.under_attack?([4, 0], :black)
        expect(under_attack_or_not).to eq(true)
      end
    end

    context 'when a black bishop is under attack and it is black\'s turn' do
      it 'returns true' do
        game.instance_variable_get(:@playing_field)[3][3] = :b_bishop
        game.instance_variable_get(:@playing_field)[3][0] = :w_rook
        under_attack_or_not = game.under_attack?([3, 3], :white)
        expect(under_attack_or_not).to eq(true)
      end
    end
  end

  describe '#attacker_squares' do
    before do
      blank_playing_field = Array.new(8) { Array.new(8) { nil } }
      game.instance_variable_set(:@playing_field, blank_playing_field)
    end

    context 'when no one is attacking the white king on a5' do
      it 'returns []' do
        game.instance_variable_get(:@playing_field)[0][4] = :w_king
        game.instance_variable_get(:@playing_field)[4][4] = :b_bishop
        game.instance_variable_set(:@current_player, :white)
        squares = game.attacker_squares([0, 4])
        expect(squares).to eq([])
      end
    end

    context 'when a black bishop on e5 is attacking the white king on a0' do
      it 'returns [4, 4]' do
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[4][4] = :b_bishop
        game.instance_variable_set(:@current_player, :white)
        squares = game.attacker_squares([0, 0])
        expect(squares).to eq([[4, 4]])
      end
    end

    context 'when a black bishop on e5 and a black rook on a3 are attacking the white king on a0' do
      it 'returns [4, 4]' do
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[4][4] = :b_bishop
        game.instance_variable_get(:@playing_field)[0][2] = :b_rook
        game.instance_variable_set(:@current_player, :white)
        squares = game.attacker_squares([0, 0])
        expect(squares).to eq([[0, 2], [4, 4]])
      end
    end

    context 'when a white bishop on e5 and a white rook on a3 are attacking the black king on a0' do
      it 'returns [4, 4]' do
        game.instance_variable_get(:@playing_field)[0][0] = :b_king
        game.instance_variable_get(:@playing_field)[4][4] = :w_bishop
        game.instance_variable_get(:@playing_field)[0][2] = :w_rook
        game.instance_variable_set(:@current_player, :black)
        squares = game.attacker_squares([0, 0])
        expect(squares).to eq([[0, 2], [4, 4]])
      end
    end
  end

  describe '#attacking_piece_protected?' do
    context 'when the attacking piece is protected' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][1] = :b_queen
        game.instance_variable_get(:@playing_field)[1][2] = :b_bishop
      end

      it 'returns true' do
        protected_or_not = game.attacking_piece_protected?([0, 1])
        expect(protected_or_not).to eq(true)
      end
    end

    context 'when the attacking piece is protected' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
        game.instance_variable_get(:@playing_field)[1][3] = :b_bishop
      end

      it 'returns true' do
        protected_or_not = game.attacking_piece_protected?([0, 2])
        expect(protected_or_not).to eq(true)
      end
    end

    context 'when the attacking piece is not protected' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][1] = :b_queen
      end

      it 'returns false' do
        protected_or_not = game.attacking_piece_protected?([0, 1])
        expect(protected_or_not).to eq(false)
      end
    end

    context 'when the attacking piece is not protected' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
      end

      it 'returns false' do
        protected_or_not = game.attacking_piece_protected?([0, 2])
        expect(protected_or_not).to eq(false)
      end
    end
  end

  describe '#in_checkmate?' do
    context 'when not in check' do
      it 'returns false' do
        allow(game).to receive(:in_check?).and_return(false)
        allow(game).to receive(:can_move_out_of_check?).and_return(false)
        allow(game).to receive(:attacker_can_be_captured?).and_return(false)
        allow(game).to receive(:attacker_can_be_blocked?).and_return(false)
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when in check but can move out of check' do
      it 'returns false' do
        allow(game).to receive(:in_check?).and_return(true)
        allow(game).to receive(:can_move_out_of_check?).and_return(true)
        allow(game).to receive(:attacker_can_be_captured?).and_return(false)
        allow(game).to receive(:attacker_can_be_blocked?).and_return(false)
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when in check but attacker can be captured' do
      it 'returns false' do
        allow(game).to receive(:in_check?).and_return(true)
        allow(game).to receive(:can_move_out_of_check?).and_return(false)
        allow(game).to receive(:attacker_can_be_captured?).and_return(true)
        allow(game).to receive(:attacker_can_be_blocked?).and_return(false)
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when in check but attacker can be blocked' do
      it 'returns false' do
        allow(game).to receive(:in_check?).and_return(true)
        allow(game).to receive(:can_move_out_of_check?).and_return(false)
        allow(game).to receive(:attacker_can_be_captured?).and_return(false)
        allow(game).to receive(:attacker_can_be_blocked?).and_return(true)
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when in checkmate' do
      it 'returns true' do
        allow(game).to receive(:in_check?).and_return(true)
        allow(game).to receive(:can_move_out_of_check?).and_return(false)
        allow(game).to receive(:attacker_can_be_captured?).and_return(false)
        allow(game).to receive(:attacker_can_be_blocked?).and_return(false)
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end
  end

  # integration tests - test other methods involved in checkmate validation
  # use a static playing field for the tests
  describe '#in_checkmate?' do
    context 'when the white king is not in check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[1][2] = :b_queen
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when the white king can move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[1][2] = :b_knight
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when the white king can move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when the white king is in checkmate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
        game.instance_variable_get(:@playing_field)[1][3] = :b_rook
      end

      it 'returns true' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when the black king is in checkmate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[0][7] = :b_king
        game.instance_variable_get(:@playing_field)[0][6] = :w_queen
        game.instance_variable_get(:@playing_field)[1][5] = :w_bishop
      end

      it 'returns true' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when the black king can capture the attacker' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[0][7] = :b_king
        game.instance_variable_get(:@playing_field)[0][6] = :w_queen
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when a black piece can block the attacker' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[0][7] = :b_king
        game.instance_variable_get(:@playing_field)[0][5] = :w_rook
        game.instance_variable_get(:@playing_field)[1][6] = :b_rook
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when a black piece can block the attacker' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[7][7] = :b_king
        game.instance_variable_get(:@playing_field)[0][0] = :w_queen
        game.instance_variable_get(:@playing_field)[5][3] = :b_bishop
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when black is in checkmate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[7][7] = :b_king
        game.instance_variable_get(:@playing_field)[0][7] = :w_queen
        game.instance_variable_get(:@playing_field)[3][6] = :w_rook
      end

      it 'returns true' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when black can capture the attacker' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[1][7] = :b_king
        game.instance_variable_get(:@playing_field)[2][6] = :w_queen
        game.instance_variable_get(:@playing_field)[1][5] = :w_knight
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when black is in checkmate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[1][7] = :b_king
        game.instance_variable_get(:@playing_field)[2][6] = :w_queen
        game.instance_variable_get(:@playing_field)[1][5] = :w_knight
        game.instance_variable_get(:@playing_field)[3][5] = :w_pawn
      end

      it 'returns true' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white is in checkmate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][3] = :b_rook
        game.instance_variable_get(:@playing_field)[1][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[1][0] = :w_rook
      end

      it 'returns true' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white can block the attacker' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][3] = :b_rook
        game.instance_variable_get(:@playing_field)[1][1] = :w_bishop
        game.instance_variable_get(:@playing_field)[1][0] = :w_rook
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when white is in checkmate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[6][0] = :w_king
        game.instance_variable_get(:@playing_field)[5][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[6][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[7][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[0][0] = :b_rook
      end

      it 'returns true' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white is in Fool\'s Mate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[3][0] = :w_queen
        game.instance_variable_get(:@playing_field)[3][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[4][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[5][0] = :w_bishop
        game.instance_variable_get(:@playing_field)[5][2] = :w_pawn
        game.instance_variable_get(:@playing_field)[7][3] = :b_queen
      end

      it 'returns true' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white is in checkmate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[3][0] = :w_rook
        game.instance_variable_get(:@playing_field)[3][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[4][1] = :b_queen
        game.instance_variable_get(:@playing_field)[5][0] = :w_rook
        game.instance_variable_get(:@playing_field)[5][2] = :w_pawn
        game.instance_variable_get(:@playing_field)[3][3] = :b_knight
      end

      it 'returns true' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white can capture the attacker' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[3][0] = :w_rook
        game.instance_variable_get(:@playing_field)[3][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[4][1] = :b_queen
        game.instance_variable_get(:@playing_field)[5][0] = :w_rook
        game.instance_variable_get(:@playing_field)[5][2] = :w_pawn
      end

      it 'returns false' do
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end
  end

  # integration tests - test other methods involved in gameplay and checkmate validation
  # use a sequence of moves for the tests
  describe '#in_checkmate?' do
    context 'when white is put in Fool\'s Mate' do
      before do
        allow(game).to receive(:player_move).and_return('f2f3', 'e7e5', 'g2g4', 'd8h4')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when black is put in Reversed Fool\'s Mate' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'f7f6', 'd2d4', 'g7g5', 'd1h5')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when black is checkmated in Mike\'s Mate I (with plenty of invalid moves)' do
      before do
        allow(game).to receive(:player_move).and_return('d2d4', 'd7d5', 'e2e3', 'e7e6', 'f1b4',
                                                        'f1b5', 'h7h6', 'e8d7', 'd8d7', 'b5d7',
                                                        'e8d7', 'd1f3', 'd7e8', 'g1g3', 'g1h3',
                                                        'a7a5', 'h3g5', 'b7b6', 'f3f7', 'e8f7',
                                                        'e8f8', 'e8d8', 'c2c3', 'c8b7', 'g5e6',
                                                        'd8d7', 'd8e8', 'd8c8', 'f7e8')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when black is checkmated in Scholar\'s Mate' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'e7e5', 'f1c4', 'b8c6', 'd1h5',
                                                        'g8f6', 'h5f7')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white makes a bunch of invalid moves and then is checkmated in back rank mate' do
      before do
        allow(game).to receive(:player_move).and_return('a2a5', 'b3b8', 'e1d1', 'f1h3', 'h7h6',
                                                        'e2e4', 'a7a5', 'f1c4', 'a8a6', 'g1f3',
                                                        'a6e6', 'e1f1', 'e6e4', 'f1g1', 'b7b5',
                                                        'f3g5', 'e4e5', 'd1f3', 'b5c4', 'd2d3',
                                                        'e5e1')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white is checkmated by a black queen and king in endgame' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[2][3] = :b_queen
        game.instance_variable_get(:@playing_field)[4][4] = :b_king
        game.instance_variable_set(:@current_player, :black)
        allow(game).to receive(:player_move).and_return('c4d4', 'e1e2', 'd4c3', 'e2f1', 'c3c2',
                                                        'f1e1', 'e5e4', 'e1f1', 'e4e3', 'f1e1',
                                                        'c2e2')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when black is checkmated by a white queen and king and rook in Katie\'s Mate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[1][0] = :b_king
        game.instance_variable_get(:@playing_field)[5][2] = :w_rook
        game.instance_variable_get(:@playing_field)[1][2] = :w_king
        game.instance_variable_get(:@playing_field)[3][1] = :w_queen
        game.instance_variable_set(:@current_player, :black)
        allow(game).to receive(:player_move).and_return("Katie\'s", 'awesome', 'b1a1', 'f3f1')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when replicating a bug that put black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('g2g3', 'd7d6', 'g3g4', 'd6d5', 'g4g5',
                                                        'd5d4', 'f2f4', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when trying to replicate a bug that puts black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'e4d5', 'b7b6', 'f2f4', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when trying to replicate a bug that puts black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'e4d5', 'b7b6', 'c2c4', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when trying to replicate a bug that puts black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'e4e5', 'b7b6', 'f2f4', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when trying to replicate a bug that puts black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'e4e5', 'b7b5', 'f2f4', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when trying to replicate a bug that puts black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'e4e5', 'b7b5', 'd2d4', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when trying to replicate a bug that puts black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'e4e5', 'b7b5', 'h2h4', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when trying to replicate a bug that puts black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'g1f3', 'd5d4', 'e4e5', 'c7c5', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when trying to replicate a bug that puts black in checkmate by mistake' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'g1f3', 'd5d4', 'e4e5', 'a7a5', 'q')
      end

      it 'returns false' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(false)
      end
    end

    context 'when white captures en passant and black checkmates' do
      before do
        allow(game).to receive(:player_move).and_return('g2g4', 'e7e5', 'g4g5', 'h7h5', 'g5h6',
                                                        'd8h4', 'c2c3', 'f8c5', 'c3c4', 'h4f2')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when black tries an illegal move then captures en passant and checkmates' do
      before do
        allow(game).to receive(:player_move).and_return('a2a4', 'g7g5', 'b1c3', 'g5g4', 'f2f4',
                                                        'g4h3', 'g4f3', 'c3d5', 'e7e6', 'a4a5',
                                                        'd8f6', 'b2b4', 'f3f2')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white and black both kingside castle and white then checkmates' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'e7e5', 'f1c4', 'f8c5', 'g1f3',
                                                        'g8f6', 'e1g1', 'e8g8', 'f3e5', 'f6e4',
                                                        'e5f7', 'd8g5', 'f7h6', 'g7h6', 'f8f7',
                                                        'g8h8', 'd1f3', 'c5d4', 'f3f8')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white and black both queenside castle and white then checkmates' do
      before do
        allow(game).to receive(:player_move).and_return('d2d4', 'd7d5', 'c1e3', 'd8d6', 'e1c1',
                                                        'c2c3', 'b8c6', 'b1d2', 'c8d7', 'd1a4',
                                                        'e8c8', 'e1c1', 'd6a3', 'a4b4', 'c6b4',
                                                        'h2h4', 'a3a2', 'h4h5', 'a2a1', 'd2b1',
                                                        'a1b2', 'c1c2', 'c1d2', 'c1b2', 'b4c2',
                                                        'h1h4', 'c2e3', 'd1e1', 'g7g5', 'g2g3',
                                                        'e3f5', 'h4f4', 'f5d4', 'f4d4', 'f7f5',
                                                        'd4a4', 'e7e5', 'a4a7', 'h7h6', 'a7a8')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end

    context 'when white tries to kingside castle and cannot and black then checkmates' do
      before do
        allow(game).to receive(:player_move).and_return('f2f4', 'c7c6', 'e2e4', 'd8b6', 'g1f3',
                                                        'g8f6', 'f1c4', 'f6g4', 'e1g1', 'a2a4',
                                                        'b6f2')
      end

      it 'returns true' do
        game.play
        in_checkmate_or_not = game.in_checkmate?
        expect(in_checkmate_or_not).to eq(true)
      end
    end
  end

  # integration tests - also test #escape_squares_available? and
  # accessible_squares and #surrounding_squares and #king_location and #valid_move?
  describe '#can_move_out_of_check?' do
    context 'when the white king can move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
        game.instance_variable_set(:@current_player, :white)
      end

      it 'returns true' do
        can_move_or_not = game.can_move_out_of_check?
        expect(can_move_or_not).to eq(true)
      end
    end

    context 'when the white king can move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[7][7] = :b_bishop
        game.instance_variable_set(:@current_player, :white)
      end

      it 'returns true' do
        can_move_or_not = game.can_move_out_of_check?
        expect(can_move_or_not).to eq(true)
      end
    end

    context 'when the white king can move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][1] = :b_queen
        game.instance_variable_set(:@current_player, :white)
      end

      it 'returns true' do
        can_move_or_not = game.can_move_out_of_check?
        expect(can_move_or_not).to eq(true)
      end
    end

    context 'when the white king cannot move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][1] = :b_queen
        game.instance_variable_get(:@playing_field)[0][2] = :b_rook
        game.instance_variable_set(:@current_player, :white)
      end

      it 'returns false' do
        can_move_or_not = game.can_move_out_of_check?
        expect(can_move_or_not).to eq(false)
      end
    end

    context 'when the white king cannot move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
        game.instance_variable_get(:@playing_field)[1][3] = :b_rook
        game.instance_variable_set(:@current_player, :white)
      end

      it 'returns false' do
        can_move_or_not = game.can_move_out_of_check?
        expect(can_move_or_not).to eq(false)
      end
    end

    context 'when the black king cannot move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :b_king
        game.instance_variable_get(:@playing_field)[6][1] = :w_rook
        game.instance_variable_get(:@playing_field)[7][0] = :w_rook
        game.instance_variable_set(:@current_player, :black)
      end

      it 'returns false' do
        can_move_or_not = game.can_move_out_of_check?
        expect(can_move_or_not).to eq(false)
      end
    end

    context 'when the black king cannot move out of check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :b_king
        game.instance_variable_get(:@playing_field)[4][6] = :w_queen
        game.instance_variable_get(:@playing_field)[4][5] = :w_rook
        game.instance_variable_set(:@current_player, :black)
      end

      it 'returns false' do
        can_move_or_not = game.can_move_out_of_check?
        expect(can_move_or_not).to eq(false)
      end
    end
  end

  describe '#accessible_squares' do
    before do
      blank_playing_field = Array.new(8) { Array.new(8) { nil } }
      game.instance_variable_set(:@playing_field, blank_playing_field)
      game.instance_variable_set(:@current_player, :white)
    end

    context 'when the white king is at a5 with free squares on b4, b5, and b6' do
      it 'returns those three squares' do
        allow(game).to receive(:king_location).and_return([4, 0])
        game.instance_variable_get(:@playing_field)[3][0] = :w_queen
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[5][0] = :w_rook
        accessible = game.accessible_squares
        expect(accessible).to eq([[3, 1], [4, 1], [5, 1]])
      end
    end

    context 'when the white king is at a0 with free squares on a1, a2, and b1' do
      it 'returns those three squares' do
        allow(game).to receive(:king_location).and_return([0, 0])
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][1] = :b_queen
        accessible = game.accessible_squares
        expect(accessible).to eq([[1, 0], [0, 1], [1, 1]])
      end
    end
  end

  describe 'surrounding_squares' do
    context 'when the king is at a5' do
      it 'returns the eight squares around a5 and a5 (valid or not)' do
        around_a5 = [[3, -1], [4, -1], [5, -1], [3, 0], [4, 0], [5, 0], [3, 1], [4, 1], [5, 1]]
        surrounding = game.surrounding_squares([4, 0])
        expect(surrounding).to eq(around_a5)
      end
    end
  end

  # integration tests - also test #attacker_squares and #under_attack
  # and #king_location and #valid_move?
  describe '#attacker_can_be_captured?' do
    context 'when the white king is in check by a black queen that can be captured' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        allow(game).to receive(:attacking_piece_protected?).and_return(false)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][1] = :b_queen
      end

      it 'returns true' do
        can_be_captured_or_not = game.attacker_can_be_captured?
        expect(can_be_captured_or_not).to eq(true)
      end
    end

    context 'when the white king is in check by a black queen that cannot be captured' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][1] = :b_queen
        game.instance_variable_get(:@playing_field)[1][2] = :b_bishop
      end

      it 'returns false' do
        can_be_captured_or_not = game.attacker_can_be_captured?
        expect(can_be_captured_or_not).to eq(false)
      end
    end

    context 'when the white king is in check by a black queen that cannot be captured' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
      end

      it 'returns false' do
        can_be_captured_or_not = game.attacker_can_be_captured?
        expect(can_be_captured_or_not).to eq(false)
      end
    end

    context 'when the white king is in check by a black queen that can be captured' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        allow(game).to receive(:attacking_piece_protected?).and_return(false)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
        game.instance_variable_get(:@playing_field)[0][4] = :w_rook
      end

      it 'returns true' do
        can_be_captured_or_not = game.attacker_can_be_captured?
        expect(can_be_captured_or_not).to eq(true)
      end
    end

    context 'when the white king is in check by a black knight that can be captured' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        allow(game).to receive(:attacking_piece_protected?).and_return(false)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[1][2] = :b_knight
        game.instance_variable_get(:@playing_field)[2][4] = :w_knight
      end

      it 'returns true' do
        can_be_captured_or_not = game.attacker_can_be_captured?
        expect(can_be_captured_or_not).to eq(true)
      end
    end

    context 'when the white king is in double check and one attacker can be captured' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
        game.instance_variable_get(:@playing_field)[2][0] = :b_rook
        game.instance_variable_get(:@playing_field)[4][0] = :w_rook
      end

      it 'returns false' do
        can_be_captured_or_not = game.attacker_can_be_captured?
        expect(can_be_captured_or_not).to eq(false)
      end
    end

    context 'when the white king is in double check and both attackers can be captured' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
        game.instance_variable_get(:@playing_field)[0][4] = :w_rook
        game.instance_variable_get(:@playing_field)[2][0] = :b_rook
        game.instance_variable_get(:@playing_field)[4][0] = :w_rook
      end

      it 'returns false' do
        can_be_captured_or_not = game.attacker_can_be_captured?
        expect(can_be_captured_or_not).to eq(false)
      end
    end
  end

  # integration tests that also test #attacker_squares and #king_location
  # and #possible_blocks_under_attack? and#squares_between and helper methods
  describe '#attacker_can_be_blocked?' do
    context 'when the white king is in check and can block the check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][2] = :b_queen
        game.instance_variable_get(:@playing_field)[2][1] = :w_rook
      end

      it 'returns true' do
        can_be_blocked_or_not = game.attacker_can_be_blocked?
        expect(can_be_blocked_or_not).to eq(true)
      end
    end

    context 'when the white king is in check and can block the check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[3][3] = :b_bishop
        game.instance_variable_get(:@playing_field)[4][2] = :w_rook
      end

      it 'returns true' do
        can_be_blocked_or_not = game.attacker_can_be_blocked?
        expect(can_be_blocked_or_not).to eq(true)
      end
    end

    context 'when the white king is in check and cannot block the check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[3][3] = :b_bishop
        game.instance_variable_get(:@playing_field)[4][3] = :w_rook
      end

      it 'returns false' do
        can_be_blocked_or_not = game.attacker_can_be_blocked?
        expect(can_be_blocked_or_not).to eq(false)
      end
    end

    context 'when the white king is in double check and can block each check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[4][4] = :w_king
        game.instance_variable_get(:@playing_field)[4][7] = :b_rook
        game.instance_variable_get(:@playing_field)[7][7] = :b_bishop
        game.instance_variable_get(:@playing_field)[6][5] = :w_rook
        game.instance_variable_get(:@playing_field)[7][6] = :w_rook
      end

      it 'returns false' do
        can_be_blocked_or_not = game.attacker_can_be_blocked?
        expect(can_be_blocked_or_not).to eq(false)
      end
    end

    context 'when the black king is in check and can block the check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[4][4] = :b_king
        game.instance_variable_get(:@playing_field)[7][7] = :w_queen
        game.instance_variable_get(:@playing_field)[5][0] = :b_rook
      end

      it 'returns true' do
        can_be_blocked_or_not = game.attacker_can_be_blocked?
        expect(can_be_blocked_or_not).to eq(true)
      end
    end

    context 'when the black king is in check and cannot block the check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[4][4] = :b_king
        game.instance_variable_get(:@playing_field)[7][7] = :w_bishop
        game.instance_variable_get(:@playing_field)[0][0] = :b_rook
      end

      it 'returns false' do
        can_be_blocked_or_not = game.attacker_can_be_blocked?
        expect(can_be_blocked_or_not).to eq(false)
      end
    end

    context 'when the black king is in check and cannot block the check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[4][4] = :b_king
        game.instance_variable_get(:@playing_field)[5][6] = :w_knight
      end

      it 'returns false' do
        can_be_blocked_or_not = game.attacker_can_be_blocked?
        expect(can_be_blocked_or_not).to eq(false)
      end
    end
  end

  describe '#blockable_piece_type?' do
    context 'when it is a rook' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][4] = :b_rook
        blockable_or_not = game.blockable_piece_type?([0, 4])
        expect(blockable_or_not).to eq(true)
      end
    end

    context 'when it is a knight' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[1][2] = :b_knight
        blockable_or_not = game.blockable_piece_type?([1, 2])
        expect(blockable_or_not).to eq(false)
      end
    end
  end

  # integration tests that also test #attacker_squares and #king_location
  # and #squares_between and helper methods
  describe '#possible_blocks_under_attack?' do
    context 'when a square between the white king and an attacker is under attack' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][4] = :b_rook
        game.instance_variable_get(:@playing_field)[2][2] = :w_rook
        under_attack_or_not = game.possible_blocks_under_attack?([0, 4])
        expect(under_attack_or_not).to eq(true)
      end
    end

    context 'when no square between the white king and an attacker is under attack' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[0][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][4] = :b_rook
        under_attack_or_not = game.possible_blocks_under_attack?([0, 4])
        expect(under_attack_or_not).to eq(false)
      end
    end

    context 'when a square between the white king and an attacker is under attack' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[6][4] = :w_king
        game.instance_variable_get(:@playing_field)[3][4] = :b_queen
        game.instance_variable_get(:@playing_field)[5][2] = :w_rook
        under_attack_or_not = game.possible_blocks_under_attack?([3, 4])
        expect(under_attack_or_not).to eq(true)
      end
    end

    context 'when no square between the white king and an attacker is under attack' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[6][4] = :w_king
        game.instance_variable_get(:@playing_field)[3][4] = :b_queen
        under_attack_or_not = game.possible_blocks_under_attack?([3, 4])
        expect(under_attack_or_not).to eq(false)
      end
    end

    context 'when a square between the black king and an attacker is under attack' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[6][4] = :b_king
        game.instance_variable_get(:@playing_field)[4][2] = :w_bishop
        game.instance_variable_get(:@playing_field)[5][2] = :b_rook
        under_attack_or_not = game.possible_blocks_under_attack?([4, 2])
        expect(under_attack_or_not).to eq(true)
      end
    end

    context 'when no square between the white king and an attacker is under attack' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[6][4] = :b_king
        game.instance_variable_get(:@playing_field)[4][2] = :w_bishop
        under_attack_or_not = game.possible_blocks_under_attack?([4, 2])
        expect(under_attack_or_not).to eq(false)
      end
    end

    context 'when two squares between the black king and an attacker are under attack' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[2][6] = :b_king
        game.instance_variable_get(:@playing_field)[6][6] = :w_rook
        game.instance_variable_get(:@playing_field)[2][4] = :b_bishop
        game.instance_variable_get(:@playing_field)[5][2] = :b_rook
        under_attack_or_not = game.possible_blocks_under_attack?([6, 6])
        expect(under_attack_or_not).to eq(true)
      end
    end

    context 'when no square between the black king and an attacker is under attack' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :black)
        game.instance_variable_get(:@playing_field)[2][6] = :b_king
        game.instance_variable_get(:@playing_field)[3][5] = :w_pawn
        under_attack_or_not = game.possible_blocks_under_attack?([3, 5])
        expect(under_attack_or_not).to eq(false)
      end
    end
  end

  # integration tests that also test all the helper methods for #squares_between
  # tests are repeated for helper methods
  describe '#squares_between' do
    context 'the first piece is on a1 and the second is on a7' do
      it 'returns all the squares in between' do
        squares_between = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5]]
        end_squares = game.squares_between([0, 0], [0, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a7 and the second is on a1' do
      it 'returns all the squares in between' do
        squares_between = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5]]
        end_squares = game.squares_between([0, 6], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b5 and the second is on b7' do
      it 'returns the square in between' do
        squares_between = [[1, 5]]
        end_squares = game.squares_between([1, 4], [1, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a2 and the second is on a1' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between([0, 1], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a2 and the second is on d2' do
      it 'returns all the squares in between' do
        squares_between = [[1, 1], [2, 1]]
        end_squares = game.squares_between([0, 1], [3, 1])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a1 and the second is on g1' do
      it 'returns all the squares in between' do
        squares_between = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]
        end_squares = game.squares_between([0, 0], [6, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a7 and the second is on a1' do
      it 'returns all the squares in between' do
        squares_between = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]
        end_squares = game.squares_between([6, 0], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b5 and the second is on d5' do
      it 'returns the square in between' do
        squares_between = [[2, 4]]
        end_squares = game.squares_between([1, 4], [3, 4])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b1 and the second is on a1' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between([1, 0], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a2 and the second is on a4' do
      it 'returns all the squares in between' do
        squares_between = [[0, 2]]
        end_squares = game.squares_between([0, 1], [0, 3])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a1 and the second is on g7' do
      it 'returns all the squares in between' do
        squares_between = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]
        end_squares = game.squares_between([0, 0], [6, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on g7 and the second is on a1' do
      it 'returns all the squares in between' do
        squares_between = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]
        end_squares = game.squares_between([6, 6], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b5 and the second is on e7' do
      it 'returns the square in between' do
        squares_between = [[2, 5]]
        end_squares = game.squares_between([1, 4], [3, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b2 and the second is on a1' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between([1, 1], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a7 and the second is on g1' do
      it 'returns all the squares in between' do
        squares_between = [[1, 5], [2, 4], [3, 3], [4, 2], [5, 1]]
        end_squares = game.squares_between([0, 6], [6, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on g1 and the second is on a7' do
      it 'returns all the squares in between' do
        squares_between = [[1, 5], [2, 4], [3, 3], [4, 2], [5, 1]]
        end_squares = game.squares_between([6, 0], [0, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on d5 and the second is on f3' do
      it 'returns the square in between' do
        squares_between = [[4, 3]]
        end_squares = game.squares_between([3, 4], [5, 2])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b2 and the second is on a1' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between([1, 1], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end
  end

  describe '#squares_between_on_file' do
    context 'the first piece is on a1 and the second is on a7' do
      it 'returns all the squares in between' do
        squares_between = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5]]
        end_squares = game.squares_between_on_file([0, 0], [0, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a7 and the second is on a1' do
      it 'returns all the squares in between' do
        squares_between = [[0, 1], [0, 2], [0, 3], [0, 4], [0, 5]]
        end_squares = game.squares_between_on_file([0, 6], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b5 and the second is on b7' do
      it 'returns the square in between' do
        squares_between = [[1, 5]]
        end_squares = game.squares_between_on_file([1, 4], [1, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a2 and the second is on a1' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between_on_file([0, 1], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a2 and the second is on d2' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between_on_file([0, 1], [3, 1])
        expect(end_squares).to eq(squares_between)
      end
    end
  end

  describe '#squares_between_on_rank' do
    context 'the first piece is on a1 and the second is on g1' do
      it 'returns all the squares in between' do
        squares_between = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]
        end_squares = game.squares_between_on_rank([0, 0], [6, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a7 and the second is on a1' do
      it 'returns all the squares in between' do
        squares_between = [[1, 0], [2, 0], [3, 0], [4, 0], [5, 0]]
        end_squares = game.squares_between_on_rank([6, 0], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b5 and the second is on d5' do
      it 'returns the square in between' do
        squares_between = [[2, 4]]
        end_squares = game.squares_between_on_rank([1, 4], [3, 4])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b1 and the second is on a1' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between_on_rank([1, 0], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a2 and the second is on a4' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between_on_rank([0, 1], [0, 3])
        expect(end_squares).to eq(squares_between)
      end
    end
  end

  describe '#squares_between_on_diagonal' do
    context 'the first piece is on a1 and the second is on g7' do
      it 'returns all the squares in between' do
        squares_between = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]
        end_squares = game.squares_between_on_diagonal([0, 0], [6, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on g7 and the second is on a1' do
      it 'returns all the squares in between' do
        squares_between = [[1, 1], [2, 2], [3, 3], [4, 4], [5, 5]]
        end_squares = game.squares_between_on_diagonal([6, 6], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b5 and the second is on e7' do
      it 'returns the square in between' do
        squares_between = [[2, 5]]
        end_squares = game.squares_between_on_diagonal([1, 4], [3, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b2 and the second is on a1' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between_on_diagonal([1, 1], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on a7 and the second is on g1' do
      it 'returns all the squares in between' do
        squares_between = [[1, 5], [2, 4], [3, 3], [4, 2], [5, 1]]
        end_squares = game.squares_between_on_diagonal([0, 6], [6, 0])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on g1 and the second is on a7' do
      it 'returns all the squares in between' do
        squares_between = [[1, 5], [2, 4], [3, 3], [4, 2], [5, 1]]
        end_squares = game.squares_between_on_diagonal([6, 0], [0, 6])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on d5 and the second is on f3' do
      it 'returns the square in between' do
        squares_between = [[4, 3]]
        end_squares = game.squares_between_on_diagonal([3, 4], [5, 2])
        expect(end_squares).to eq(squares_between)
      end
    end

    context 'the first piece is on b2 and the second is on a1' do
      it 'returns an empty array' do
        squares_between = []
        end_squares = game.squares_between_on_diagonal([1, 1], [0, 0])
        expect(end_squares).to eq(squares_between)
      end
    end
  end

  describe '#in_stalemate?' do
    context 'when no white piece can move but white is not in check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[7][0] = :w_king
        game.instance_variable_get(:@playing_field)[5][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[7][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[5][2] = :b_king
        game.instance_variable_get(:@playing_field)[6][3] = :b_rook
        game.instance_variable_get(:@playing_field)[7][2] = :b_queen
      end

      it 'returns true' do
        stalemate_or_not = game.in_stalemate?
        expect(stalemate_or_not).to eq(true)
      end
    end

    context 'when two white pawns can capture and white is not in check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[7][0] = :w_king
        game.instance_variable_get(:@playing_field)[5][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[7][1] = :w_pawn
        game.instance_variable_get(:@playing_field)[5][2] = :b_king
        game.instance_variable_get(:@playing_field)[6][2] = :b_rook
        game.instance_variable_get(:@playing_field)[7][2] = :b_queen
      end

      it 'returns false' do
        stalemate_or_not = game.in_stalemate?
        expect(stalemate_or_not).to eq(false)
      end
    end

    context 'when a white king is the only white piece and cannot move but is not in check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[7][0] = :w_king
        game.instance_variable_get(:@playing_field)[5][1] = :b_queen
        game.instance_variable_get(:@playing_field)[4][2] = :b_king
      end

      it 'returns true' do
        stalemate_or_not = game.in_stalemate?
        expect(stalemate_or_not).to eq(true)
      end
    end

    context 'when a white king is the only white piece and is in checkmate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[7][0] = :w_king
        game.instance_variable_get(:@playing_field)[6][1] = :b_queen
        game.instance_variable_get(:@playing_field)[5][2] = :b_king
      end

      it 'returns false' do
        stalemate_or_not = game.in_stalemate?
        expect(stalemate_or_not).to eq(false)
      end
    end

    context 'when a white king is the only white piece and can move and is in check' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_set(:@current_player, :white)
        game.instance_variable_get(:@playing_field)[7][0] = :w_king
        game.instance_variable_get(:@playing_field)[7][2] = :b_queen
        game.instance_variable_get(:@playing_field)[5][2] = :b_king
      end

      it 'returns true' do
        stalemate_or_not = game.in_stalemate?
        expect(stalemate_or_not).to eq(false)
      end
    end
  end

  # integration tests - test other methods involved in gameplay and stalemate validation
  # use a sequence of moves for the tests
  describe '#in_stalemate?' do
    context 'when white is put into stalemate by a black queen and king in endgame' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[6][1] = :w_king
        game.instance_variable_get(:@playing_field)[4][2] = :b_queen
        game.instance_variable_get(:@playing_field)[5][3] = :b_king
        game.instance_variable_set(:@current_player, :black)
        allow(game).to receive(:player_move).and_return('typo', 'e3e2', 'g2h1', 'e2f2')
      end

      it 'returns true' do
        game.play
        in_stalemate_or_not = game.in_stalemate?
        expect(in_stalemate_or_not).to eq(true)
      end
    end

    context 'when black is put into stalemate by a black queen and king in endgame' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[3][2] = :b_king
        game.instance_variable_get(:@playing_field)[7][0] = :w_queen
        game.instance_variable_get(:@playing_field)[5][2] = :w_king
        game.instance_variable_get(:@playing_field)[5][3] = :w_rook
        game.instance_variable_set(:@current_player, :black)
        allow(game).to receive(:player_move).and_return('d3c3', 'h1a1', 'c3d3', 'a9b9', 'a1c1')
      end

      it 'returns true' do
        game.play
        in_stalemate_or_not = game.in_stalemate?
        expect(in_stalemate_or_not).to eq(true)
      end
    end

    context 'when black is put into checkmate by a black queen and king in endgame' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[2][1] = :b_king
        game.instance_variable_get(:@playing_field)[6][2] = :w_queen
        game.instance_variable_get(:@playing_field)[5][2] = :w_king
        game.instance_variable_get(:@playing_field)[4][2] = :w_rook
        game.instance_variable_set(:@current_player, :white)
        allow(game).to receive(:player_move).and_return('g3g2', 'c2c23', 'c2b1', 'e3e1')
      end

      it 'returns false' do
        game.play
        in_stalemate_or_not = game.in_stalemate?
        expect(in_stalemate_or_not).to eq(false)
      end
    end

    context 'when black is stalemated by a white queen and king and rook in Katie\'s Stalemate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[1][0] = :b_king
        game.instance_variable_get(:@playing_field)[5][2] = :w_rook
        game.instance_variable_get(:@playing_field)[1][2] = :w_king
        game.instance_variable_get(:@playing_field)[3][1] = :w_queen
        game.instance_variable_set(:@current_player, :black)
        allow(game).to receive(:player_move).and_return('b1a1', 'd2c2')
      end

      it 'returns true' do
        game.play
        in_stalemate_or_not = game.in_stalemate?
        expect(in_stalemate_or_not).to eq(true)
      end
    end
  end

  # integration tests - test other methods involved in gameplay and resignation validation
  # use a sequence of moves for the tests
  describe '#resignation?' do
    context 'when black resigns before being put in Fool\'s Mate' do
      before do
        allow(game).to receive(:player_move).and_return('f2f3', 'e7e5', 'g2g4', 'q')
      end

      it 'returns true' do
        game.play
        resigned_or_not = game.instance_variable_get(:@resignation)
        expect(resigned_or_not).to eq(true)
      end
    end

    context 'when black resigns before being put in Katie\'s Stalemate' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[1][0] = :b_king
        game.instance_variable_get(:@playing_field)[5][2] = :w_rook
        game.instance_variable_get(:@playing_field)[1][2] = :w_king
        game.instance_variable_get(:@playing_field)[3][1] = :w_queen
        game.instance_variable_set(:@current_player, :black)
        allow(game).to receive(:player_move).and_return('katie', 'b1a1', 'q')
      end

      it 'returns true' do
        game.play
        resigned_or_not = game.instance_variable_get(:@resignation)
        expect(resigned_or_not).to eq(true)
      end
    end

    context 'when black resigns in Mike\'s Middle Game' do
      before do
        mikes_playing_field = [[nil, :w_pawn, nil, nil, nil, :b_knight, :b_pawn, nil],
                               [nil, :w_pawn, nil, nil, nil, :b_pawn, nil, nil],
                               [:w_rook, :w_pawn, nil, nil, nil, :b_queen, nil, nil],
                               [nil, nil, nil, :b_pawn, nil, nil, nil, nil],
                               [:w_king, nil, nil, :w_pawn, nil, :b_pawn, :b_king, nil],
                               [nil, nil, :w_queen, :w_bishop, nil, :w_rook, nil, :b_rook],
                               [nil, nil, nil, nil, :w_pawn, nil, nil, nil],
                               [nil, nil, nil, :w_pawn, :b_pawn, :b_bishop, nil, nil]]
        game.instance_variable_set(:@playing_field, mikes_playing_field)
        game.instance_variable_set(:@current_player, :white)
        allow(game).to receive(:player_move).and_return('e4e5', 'c6f3', 'f6f8', 'e7f8', 'c1d1',
                                                        'f3f4', 'g5h6', 'f4h6', 'd1d4', 'h6g6',
                                                        'c2c3', 'g6g1', 'q')
      end

      it 'returns true' do
        game.play
        resigned_or_not = game.instance_variable_get(:@resignation)
        expect(resigned_or_not).to eq(true)
      end
    end
  end

  # integration test - test other methods involved in gameplay and resignation validation
  # these test replicate bugs
  # use a sequence of moves for the tests

  describe '#resignation?' do
    context 'when replicating a bug with displaying captured pieces' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'e7e5', 'f1a6', 'b7a6', 'q')
      end

      it 'returns true' do
        game.play
        captured = game.instance_variable_get(:@captured_pieces)[2]
        row = [:w_bishop, nil, nil, nil, nil, nil, nil, nil]
        expect(captured).to eq(row)
      end
    end

    context 'when replicating a bug with displaying captured pieces' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'd7d5', 'e4d5', 'q')
      end

      it 'returns true' do
        game.play
        captured = game.instance_variable_get(:@captured_pieces)[0]
        row = [:b_pawn, nil, nil, nil, nil, nil, nil, nil]
        expect(captured).to eq(row)
      end
    end

    context 'when replicating a bug with displaying captured pieces' do
      before do
        allow(game).to receive(:player_move).and_return('e2e4', 'e7e5', 'f2f4', 'e5f4', 'q')
      end

      it 'returns true' do
        game.play
        captured = game.instance_variable_get(:@captured_pieces)[2]
        row = [:w_pawn, nil, nil, nil, nil, nil, nil, nil]
        expect(captured).to eq(row)
      end
    end
  end

  describe '#pawn_to_promote' do
    context 'when there is a white pawn to promote on a8' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][7] = :w_pawn
      end

      it 'returns [:white, [0, 7]]' do
        color_and_space = game.pawn_to_promote
        expect(color_and_space).to eq([:white, 0])
      end
    end

    context 'when there is a black pawn to promote on d1' do
      before do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[3][0] = :b_pawn
      end

      it 'returns [:black, [3, 0]]' do
        color_and_space = game.pawn_to_promote
        expect(color_and_space).to eq([:black, 3])
      end
    end

    context 'when there is no pawn to promote' do
      it 'returns false' do
        color_and_space = game.pawn_to_promote
        expect(color_and_space).to eq(false)
      end
    end
  end

  # integration tests that also test #pawn_to_promote
  describe '#promote_pawn' do
    context 'when it receives a black pawn on d1 and promotes it to a queen' do
      let(:player_pawn) { instance_double(Player) }
      it 'sets the appropriate @playing_field square to a black queen' do
        game.instance_variable_set(:@player, player_pawn)
        game.instance_variable_get(:@playing_field)[3][0] = :b_pawn
        allow(player_pawn).to receive(:user_input)
        allow(game).to receive(:input_to_piece).and_return(:b_queen)
        game.promote_pawn
        new_piece = game.instance_variable_get(:@playing_field)[3][0]
        expect(new_piece).to eq(:b_queen)
      end
    end

    context 'when it receives a white pawn on c8 and promotes it to a queen' do
      let(:player_pawn) { instance_double(Player) }
      it 'sets the appropriate @playing_field square to a white queen' do
        game.instance_variable_set(:@player, player_pawn)
        game.instance_variable_get(:@playing_field)[2][7] = :w_pawn
        allow(player_pawn).to receive(:user_input)
        allow(game).to receive(:input_to_piece).and_return(:w_rook)
        game.promote_pawn
        new_piece = game.instance_variable_get(:@playing_field)[2][7]
        expect(new_piece).to eq(:w_rook)
      end
    end
  end

  describe '#input_to_piece' do
    context 'when "n" and :black are passed in' do
      it 'returns :b_knight' do
        new_piece = game.input_to_piece('n', :black)
        expect(new_piece).to eq(:b_knight)
      end
    end

    context 'when "B" and :white are passed in' do
      it 'returns :w_bishop' do
        new_piece = game.input_to_piece('B', :white)
        expect(new_piece).to eq(:w_bishop)
      end
    end
  end

  describe '#update_en_passant_column' do
    context 'when [0, 0] and [0, 1] are passed in' do
      it 'sets @en_passant_column to nil' do
        game.update_en_passant_column([0, 0], [0, 1])
        column = game.instance_variable_get(:@en_passant_column)
        expect(column).to eq(nil)
      end
    end

    context 'when [0, 1] and [0, 3] are passed in' do
      it 'sets @en_passant_column to 0' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[0][3] = :w_pawn
        game.update_en_passant_column([0, 1], [0, 3])
        column = game.instance_variable_get(:@en_passant_column)
        expect(column).to eq(0)
      end
    end

    context 'when [5, 6] and [5, 4] are passed in' do
      it 'sets @en_passant_column to 5' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[5][4] = :b_pawn
        game.update_en_passant_column([5, 6], [5, 4])
        column = game.instance_variable_get(:@en_passant_column)
        expect(column).to eq(5)
      end
    end
  end

  describe '#update_castling_piece_states' do
    context 'when called at the start' do
      it 'sets @white_kingside_rook_moved to false' do
        game.update_castling_piece_states(:start)
        rook_moved = game.instance_variable_get(:@white_kingside_rook_moved)
        expect(rook_moved).to eq(false)
      end

      it 'sets @black_king_moved to false' do
        game.update_castling_piece_states(:start)
        king_moved = game.instance_variable_get(:@black_king_moved)
        expect(king_moved).to eq(false)
      end
    end

    context 'when called during a game at a0' do
      it 'sets @white_queenside_rook_moved to true' do
        game.update_castling_piece_states(:during, [0, 0])
        rook_moved = game.instance_variable_get(:@white_queenside_rook_moved)
        expect(rook_moved).to eq(true)
      end
    end

    context 'when called during a game at a8' do
      it 'sets @black_queenside_rook_moved to true' do
        game.update_castling_piece_states(:during, [0, 7])
        rook_moved = game.instance_variable_get(:@black_queenside_rook_moved)
        expect(rook_moved).to eq(true)
      end
    end
  end

  describe 'move_is_white_castle?' do
    context 'when all conditions are met' do
      it 'returns true' do
        white_castle_or_not = game.move_is_white_castle?([4, 0], [2, 0], :queen)
        expect(white_castle_or_not).to eq(true)
      end
    end

    context 'when the side is wrong' do
      it 'returns false' do
        white_castle_or_not = game.move_is_white_castle?([4, 0], [2, 0], :king)
        expect(white_castle_or_not).to eq(false)
      end
    end
  end

  describe 'white_can_kingside_castle?' do
    context 'when the white king has moved already' do
      it 'returns false' do
        game.instance_variable_set(:@white_king_moved, true)
        can_castle_or_not = game.white_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when the white kingside rook has moved already' do
      it 'returns false' do
        game.instance_variable_set(:@white_kingside_rook_moved, true)
        can_castle_or_not = game.white_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end
  end

  describe 'white_can_queenside_castle?' do
    context 'when the white king has moved already' do
      it 'returns false' do
        game.instance_variable_set(:@white_king_moved, true)
        can_castle_or_not = game.white_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when the white queenside rook has moved already' do
      it 'returns false' do
        game.instance_variable_set(:@white_queenside_rook_moved, true)
        can_castle_or_not = game.white_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end
  end

  # integration tests that also test helper methods
  describe 'white_can_kingside_castle?' do
    context 'when neither piece has moved yet but the king is in check' do
      it 'returns false' do
        game.instance_variable_set(:@white_king_moved, false)
        game.instance_variable_set(:@white_kingside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[7][0] = :w_rook
        game.instance_variable_get(:@playing_field)[6][2] = :b_bishop
        can_castle_or_not = game.white_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when neither piece has moved yet but a square is in check' do
      it 'returns false' do
        game.instance_variable_set(:@white_king_moved, false)
        game.instance_variable_set(:@white_kingside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[7][0] = :w_rook
        game.instance_variable_get(:@playing_field)[5][2] = :b_rook
        can_castle_or_not = game.white_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when neither piece has moved yet but a piece is in the way' do
      it 'returns false' do
        game.instance_variable_set(:@white_king_moved, false)
        game.instance_variable_set(:@white_kingside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[7][0] = :w_rook
        game.instance_variable_get(:@playing_field)[5][0] = :w_bishop
        can_castle_or_not = game.white_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when kingside castling is allowed' do
      it 'returns true' do
        game.instance_variable_set(:@white_king_moved, false)
        game.instance_variable_set(:@white_kingside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[7][0] = :w_rook
        game.instance_variable_get(:@playing_field)[6][5] = :w_rook
        can_castle_or_not = game.white_can_kingside_castle?
        expect(can_castle_or_not).to eq(true)
      end
    end
  end

  # integration tests that also test helper methods
  describe 'white_can_queenside_castle?' do
    context 'when neither piece has moved yet but the king is in check' do
      it 'returns false' do
        game.instance_variable_set(:@white_king_moved, false)
        game.instance_variable_set(:@white_queenside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][0] = :w_rook
        game.instance_variable_get(:@playing_field)[6][2] = :b_bishop
        can_castle_or_not = game.white_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when neither piece has moved yet but a square is in check' do
      it 'returns false' do
        game.instance_variable_set(:@white_king_moved, false)
        game.instance_variable_set(:@white_queenside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][0] = :w_rook
        game.instance_variable_get(:@playing_field)[3][2] = :b_rook
        can_castle_or_not = game.white_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when neither piece has moved yet but a piece is in the way' do
      it 'returns false' do
        game.instance_variable_set(:@white_king_moved, false)
        game.instance_variable_set(:@white_queenside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][0] = :w_rook
        game.instance_variable_get(:@playing_field)[2][0] = :w_bishop
        can_castle_or_not = game.white_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when queenside castling is allowed' do
      it 'returns true' do
        game.instance_variable_set(:@white_king_moved, false)
        game.instance_variable_set(:@white_queenside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][0] = :w_king
        game.instance_variable_get(:@playing_field)[0][0] = :w_rook
        game.instance_variable_get(:@playing_field)[6][5] = :w_rook
        can_castle_or_not = game.white_can_queenside_castle?
        expect(can_castle_or_not).to eq(true)
      end
    end
  end

  describe 'no_white_castling_squares_in_check?' do
    context 'when none of the castling squares are in check' do
      it 'returns true' do
        allow(game).to receive(:under_attack?).and_return(false, false, false)
        squares_not_in_check = game.no_white_castling_squares_in_check?(:king)
        expect(squares_not_in_check).to eq(true)
      end
    end

    context 'when one of the castling squares is in check' do
      it 'returns false' do
        allow(game).to receive(:under_attack?).and_return(false, true, false)
        squares_not_in_check = game.no_white_castling_squares_in_check?(:king)
        expect(squares_not_in_check).to eq(false)
      end
    end
  end

  describe 'white_kingside_castling_squares_empty?' do
    context 'when both squares are empty' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        squares_empty_or_not = game.white_kingside_castling_squares_empty?
        expect(squares_empty_or_not).to eq(true)
      end
    end

    context 'when one square is not empty' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[5][0] = :w_bishop
        squares_empty_or_not = game.white_kingside_castling_squares_empty?
        expect(squares_empty_or_not).to eq(false)
      end
    end
  end

  describe 'white_queenside_castling_squares_empty?' do
    context 'when both squares are empty' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        squares_empty_or_not = game.white_queenside_castling_squares_empty?
        expect(squares_empty_or_not).to eq(true)
      end
    end

    context 'when one square is not empty' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[2][0] = :w_bishop
        squares_empty_or_not = game.white_queenside_castling_squares_empty?
        expect(squares_empty_or_not).to eq(false)
      end
    end
  end

  describe 'move_is_black_castle?' do
    context 'when all conditions are met' do
      it 'returns true' do
        black_castle_or_not = game.move_is_black_castle?([4, 7], [2, 7], :queen)
        expect(black_castle_or_not).to eq(true)
      end
    end

    context 'when the side is wrong' do
      it 'returns false' do
        black_castle_or_not = game.move_is_black_castle?([4, 7], [2, 7], :king)
        expect(black_castle_or_not).to eq(false)
      end
    end
  end

  describe 'black_can_kingside_castle?' do
    context 'when the black king has moved already' do
      it 'returns false' do
        game.instance_variable_set(:@black_king_moved, true)
        can_castle_or_not = game.black_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when the black kingside rook has moved already' do
      it 'returns false' do
        game.instance_variable_set(:@black_kingside_rook_moved, true)
        can_castle_or_not = game.black_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end
  end

  describe 'black_can_queenside_castle?' do
    context 'when the black king has moved already' do
      it 'returns false' do
        game.instance_variable_set(:@black_king_moved, true)
        can_castle_or_not = game.black_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when the black queenside rook has moved already' do
      it 'returns false' do
        game.instance_variable_set(:@black_queenside_rook_moved, true)
        can_castle_or_not = game.black_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end
  end

  # integration tests that also test helper methods
  describe 'black_can_kingside_castle?' do
    context 'when neither piece has moved yet but the king is in check' do
      it 'returns false' do
        game.instance_variable_set(:@black_king_moved, false)
        game.instance_variable_set(:@black_kingside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :w_king
        game.instance_variable_get(:@playing_field)[7][7] = :w_rook
        game.instance_variable_get(:@playing_field)[6][5] = :b_bishop
        can_castle_or_not = game.black_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when neither piece has moved yet but a square is in check' do
      it 'returns false' do
        game.instance_variable_set(:@black_king_moved, false)
        game.instance_variable_set(:@black_kingside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :w_king
        game.instance_variable_get(:@playing_field)[7][7] = :w_rook
        game.instance_variable_get(:@playing_field)[5][5] = :b_rook
        can_castle_or_not = game.black_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when neither piece has moved yet but a piece is in the way' do
      it 'returns false' do
        game.instance_variable_set(:@black_king_moved, false)
        game.instance_variable_set(:@black_kingside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :w_king
        game.instance_variable_get(:@playing_field)[7][7] = :w_rook
        game.instance_variable_get(:@playing_field)[5][7] = :w_bishop
        can_castle_or_not = game.black_can_kingside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when kingside castling is allowed' do
      it 'returns true' do
        game.instance_variable_set(:@black_king_moved, false)
        game.instance_variable_set(:@black_kingside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :w_king
        game.instance_variable_get(:@playing_field)[7][7] = :w_rook
        game.instance_variable_get(:@playing_field)[6][5] = :w_rook
        can_castle_or_not = game.black_can_kingside_castle?
        expect(can_castle_or_not).to eq(true)
      end
    end
  end

  # integration tests that also test helper methods
  describe 'black_can_queenside_castle?' do
    context 'when neither piece has moved yet but the king is in check' do
      it 'returns false' do
        game.instance_variable_set(:@black_king_moved, false)
        game.instance_variable_set(:@black_queenside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :w_king
        game.instance_variable_get(:@playing_field)[0][7] = :w_rook
        game.instance_variable_get(:@playing_field)[6][5] = :b_bishop
        can_castle_or_not = game.black_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when neither piece has moved yet but a square is in check' do
      it 'returns false' do
        game.instance_variable_set(:@black_king_moved, false)
        game.instance_variable_set(:@black_queenside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :w_king
        game.instance_variable_get(:@playing_field)[0][7] = :w_rook
        game.instance_variable_get(:@playing_field)[3][5] = :b_rook
        can_castle_or_not = game.black_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when neither piece has moved yet but a piece is in the way' do
      it 'returns false' do
        game.instance_variable_set(:@black_king_moved, false)
        game.instance_variable_set(:@black_queenside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :w_king
        game.instance_variable_get(:@playing_field)[0][7] = :w_rook
        game.instance_variable_get(:@playing_field)[2][7] = :w_bishop
        can_castle_or_not = game.black_can_queenside_castle?
        expect(can_castle_or_not).to eq(false)
      end
    end

    context 'when queenside castling is allowed' do
      it 'returns true' do
        game.instance_variable_set(:@black_king_moved, false)
        game.instance_variable_set(:@black_queenside_rook_moved, false)
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[4][7] = :w_king
        game.instance_variable_get(:@playing_field)[0][7] = :w_rook
        game.instance_variable_get(:@playing_field)[6][5] = :w_rook
        can_castle_or_not = game.black_can_queenside_castle?
        expect(can_castle_or_not).to eq(true)
      end
    end
  end

  describe 'no_black_castling_squares_in_check?' do
    context 'when none of the castling squares are in check' do
      it 'returns true' do
        allow(game).to receive(:under_attack?).and_return(false, false, false)
        squares_not_in_check = game.no_black_castling_squares_in_check?(:king)
        expect(squares_not_in_check).to eq(true)
      end
    end

    context 'when one of the castling squares is in check' do
      it 'returns false' do
        allow(game).to receive(:under_attack?).and_return(false, true, false)
        squares_not_in_check = game.no_black_castling_squares_in_check?(:king)
        expect(squares_not_in_check).to eq(false)
      end
    end
  end

  describe 'black_kingside_castling_squares_empty?' do
    context 'when both squares are empty' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        squares_empty_or_not = game.black_kingside_castling_squares_empty?
        expect(squares_empty_or_not).to eq(true)
      end
    end

    context 'when one square is not empty' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[5][7] = :w_bishop
        squares_empty_or_not = game.black_kingside_castling_squares_empty?
        expect(squares_empty_or_not).to eq(false)
      end
    end
  end

  describe 'black_queenside_castling_squares_empty?' do
    context 'when both squares are empty' do
      it 'returns true' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        squares_empty_or_not = game.black_queenside_castling_squares_empty?
        expect(squares_empty_or_not).to eq(true)
      end
    end

    context 'when one square is not empty' do
      it 'returns false' do
        blank_playing_field = Array.new(8) { Array.new(8) { nil } }
        game.instance_variable_set(:@playing_field, blank_playing_field)
        game.instance_variable_get(:@playing_field)[2][7] = :w_bishop
        squares_empty_or_not = game.black_queenside_castling_squares_empty?
        expect(squares_empty_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
