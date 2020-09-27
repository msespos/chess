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

      it 'creates an instance of Rook' do
        rook = game.instance_variable_get(:@rook)
        expect(rook).to be_a(Rook)
        game.send(:initialize)
      end

      it 'calls #starting_playing_field' do
        expect(game).to receive(:starting_playing_field)
        game.send(:initialize)
      end
    end
  end

  describe '#starting_playing_field' do
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
        game.starting_playing_field
      end
    end
  end

  describe '#algebraic_to_cartesian' do
    context 'when "a1" is passed in' do
      it 'returns [0, 0]' do
        coords = game.algebraic_to_cartesian('a1')
        expect(coords).to eq([0, 0])
      end
    end

    context 'when "c3" is passed in' do
      it 'returns [2, 2]' do
        coords = game.algebraic_to_cartesian('c3')
        expect(coords).to eq([2, 2])
      end
    end

    context 'when "h4" is passed in' do
      it 'returns [7, 3]' do
        coords = game.algebraic_to_cartesian('h4')
        expect(coords).to eq([7, 3])
      end
    end
  end

  describe '#move_piece' do
    context 'when a white rook is moved from a1 to a4 legally and does not capture' do
      before do
        expect(game).to receive(:valid_move?).and_return(true)
        expect(game).to receive(:capture?).and_return(false)
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
  end

  describe '#move_piece' do
    context 'when a white rook attempts to move from a1 to a4 illegally' do
      it 'returns :invalid' do
        expect(game).to receive(:valid_move?).and_return(false)
        move = game.move_piece([0, 0], [0, 3])
        expect(move).to eq(:invalid)
      end
    end
  end

  describe '#move_piece' do
    context 'when a black pawn is moved from g7 to h6 legally and captures a rook' do
      before do
        expect(game).to receive(:valid_move?).and_return(true)
        expect(game).to receive(:capture?).and_return(true)
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
end

# rubocop:enable Metrics/BlockLength
