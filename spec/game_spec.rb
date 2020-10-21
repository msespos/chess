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

  # integration test that also tests #king_location and #under_attack and #valid_move?
  describe 'in_check?' do
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

  describe 'in_check?' do
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

  describe 'king_location' do
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
  describe 'under_attack?' do
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

  describe '#in_checkmate?' do
    context '' do
      it '' do
      end
    end
  end

  # integration tests - also test #accessible_squares and #surrounding_squares
  # and #king_location and #valid_move?
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

  describe '#attacker_can_be_blocked?' do
    context '' do
      it '' do
      end
    end
  end

  describe '#squares_between' do
    context '' do
      it '' do
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
    context '' do
      it '' do
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

    # integration test - tests #start_and_finish_spaces_valid? as well
    context 'when the pieces are the same color' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 0], [0, 1], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #start_and_finish_spaces_valid? as well
    context 'when the start piece is nil' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 2], [0, 1], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests #start_and_finish_spaces_valid? as well
    context 'when the finish piece is nil' do
      it 'returns false' do
        valid_or_not = game.valid_move?([0, 0], [0, 2], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests Board#overwrite_playing_field and tests that Piece#rook_path exists
    context 'when both spaces are valid and the color is correct and #rook_path? is false' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns false' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_spaces_valid?).and_return(true)
        allow(piece_valid).to receive(:rook_path?).and_return(false)
        valid_or_not = game.valid_move?([0, 0], [0, 1], 'color')
        expect(valid_or_not).to eq(false)
      end
    end

    # integration test - tests Board#overwrite_playing_field and tests that Piece#rook_path exists
    context 'when both spaces are valid and the color is correct and #rook_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_spaces_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:rook_path?).and_return(true)
        valid_or_not = game.valid_move?([0, 0], [0, 1], 'color')
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests Board#overwrite_playing_field and tests that Piece#knight_path exists
    context 'when both spaces are valid and the color is correct and #knight_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_spaces_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:knight_path?).and_return(true)
        valid_or_not = game.valid_move?([1, 0], [2, 2], 'color')
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests Board#overwrite_playing_field and tests that Piece#queen_path exists
    context 'when both spaces are valid and the color is correct and #queen_path? is true' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_spaces_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:queen_path?).and_return(true)
        valid_or_not = game.valid_move?([3, 0], [4, 0], 'color')
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests Board#overwrite_playing_field and tests that Piece#queen_path exists
    context 'when both spaces are valid and the color is correct and #white_pawn_path? is false' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns true' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_spaces_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:white_pawn_path?).and_return(true)
        valid_or_not = game.valid_move?([3, 1], [3, 2], 'color')
        expect(valid_or_not).to eq(true)
      end
    end

    # integration test - tests Board#overwrite_playing_field and tests that Piece#queen_path exists
    context 'when both spaces are valid and the color is correct and #king_path? is false' do
      let(:piece_valid) { instance_double(Piece) }
      it 'returns false' do
        game.instance_variable_set(:@piece, piece_valid)
        allow(game).to receive(:start_and_finish_spaces_valid?).and_return(true)
        allow(game).to receive(:correct_color?).and_return(true)
        allow(piece_valid).to receive(:king_path?).and_return(false)
        valid_or_not = game.valid_move?([4, 0], [1, 0], 'color')
        expect(valid_or_not).to eq(false)
      end
    end
  end

  describe '#correct_color?' do
    context 'when the start piece is white and the current player is set to white' do
      it 'returns true' do
        correct_color_or_not = game.correct_color?(:white, [0, 1])
        expect(correct_color_or_not).to eq(true)
      end
    end

    context 'when the start piece is white and the current player is set to black' do
      it 'returns false' do
        correct_color_or_not = game.correct_color?(:black, [0, 1])
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

  describe '#start_and_finish_spaces_valid?' do
    context 'when the start piece is nil and the finish space is valid' do
      it 'returns false' do
        allow(game).to receive(:finish_space_valid?).and_return(true)
        start_and_finish_spaces_valid_or_not = game.start_and_finish_spaces_valid?([0, 2], [0, 3])
        expect(start_and_finish_spaces_valid_or_not).to eq(false)
      end
    end

    context 'when the start piece is not nil and the finish space is valid' do
      it 'returns true' do
        allow(game).to receive(:finish_space_valid?).and_return(true)
        start_and_finish_spaces_valid_or_not = game.start_and_finish_spaces_valid?([0, 1], [0, 3])
        expect(start_and_finish_spaces_valid_or_not).to eq(true)
      end
    end

    context 'when the start piece is not nil and the finish space is not valid' do
      it 'returns false' do
        allow(game).to receive(:finish_space_valid?).and_return(false)
        start_and_finish_spaces_valid_or_not = game.start_and_finish_spaces_valid?([0, 1], [0, 3])
        expect(start_and_finish_spaces_valid_or_not).to eq(false)
      end
    end
  end

  describe '#finish_space_valid?' do
    context 'when the finish piece is nil' do
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
