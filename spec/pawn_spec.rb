# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/pawn.rb'

RSpec.describe Pawn do
  subject(:pawn) { described_class.new }
  describe '#path?' do
    context 'when it is on the starting rank with two squares ahead free' do
      it 'returns true' do
        allow(pawn).to receive(:on_starting_rank?).and_return(true)
        allow(pawn).to receive(:two_squares_ahead_free?).and_return(true)
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is on the starting rank with standard conditions met' do
      it 'returns true' do
        allow(pawn).to receive(:on_starting_rank?).and_return(true)
        allow(pawn).to receive(:standard_conditions_met?).and_return(true)
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is not on the starting rank with standard conditions met' do
      it 'returns true' do
        allow(pawn).to receive(:on_starting_rank?).and_return(false)
        allow(pawn).to receive(:standard_conditions_met?).and_return(true)
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is not on the starting rank with standard conditions not met' do
      it 'returns false' do
        allow(pawn).to receive(:on_starting_rank?).and_return(false)
        allow(pawn).to receive(:standard_conditions_met?).and_return(false)
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color')
        expect(path_or_not).to eq(false)
      end
    end
  end

  describe '#on_starting_rank?' do
    context 'when it is a white pawn on the starting rank' do
      it 'returns true' do
        starting_rank_or_not = pawn.on_starting_rank?([6, 1], :white)
        expect(starting_rank_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn on the starting rank' do
      it 'returns true' do
        starting_rank_or_not = pawn.on_starting_rank?([6, 6], :black)
        expect(starting_rank_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn not on the starting rank' do
      it 'returns false' do
        starting_rank_or_not = pawn.on_starting_rank?([7, 6], :white)
        expect(starting_rank_or_not).to eq(false)
      end
    end

    context 'when it is a black pawn not on the starting rank' do
      it 'returns false' do
        starting_rank_or_not = pawn.on_starting_rank?([4, 1], :black)
        expect(starting_rank_or_not).to eq(false)
      end
    end
  end

  describe '#two_squares_ahead_free?' do
    context 'when it is a white pawn and the two squares ahead are free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([0, 1], [0, 3], playing_field, :white)
        expect(two_squares_ahead_free_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn and the two squares ahead are free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][6] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([0, 6], [0, 4], playing_field, :black)
        expect(two_squares_ahead_free_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn and the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][2] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([3, 1], [3, 3], playing_field, :white)
        expect(two_squares_ahead_free_or_not).to eq(false)
      end
    end

    context 'when it is a black pawn and the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][6] = :w_pawn
        playing_field[3][5] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([3, 6], [3, 4], playing_field, :black)
        expect(two_squares_ahead_free_or_not).to eq(false)
      end
    end

    context 'when it is a white pawn and the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][3] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([3, 1], [3, 3], playing_field, :white)
        expect(two_squares_ahead_free_or_not).to eq(false)
      end
    end

    context 'when it is a black pawn and the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][6] = :w_pawn
        playing_field[3][4] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([3, 6], [3, 4], playing_field, :black)
        expect(two_squares_ahead_free_or_not).to eq(false)
      end
    end
  end

  describe '#standard_conditions_met?' do
    context 'when it has one square ahead free' do
      it 'returns true' do
        allow(pawn).to receive(:one_square_ahead_free?).and_return(true)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field', 'color')
        expect(standard_or_not).to eq(true)
      end
    end

    context 'when it has a left diagonal capture available' do
      it 'returns true' do
        allow(pawn).to receive(:left_diagonal_capture?).and_return(true)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field', 'color')
        expect(standard_or_not).to eq(true)
      end
    end

    context 'when it has a right diagonal capture available' do
      it 'returns true' do
        allow(pawn).to receive(:right_diagonal_capture?).and_return(true)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field', 'color')
        expect(standard_or_not).to eq(true)
      end
    end

    context 'when none of the standard conditions are met' do
      it 'returns false' do
        allow(pawn).to receive(:one_square_ahead_free?).and_return(false)
        allow(pawn).to receive(:left_diagonal_capture?).and_return(false)
        allow(pawn).to receive(:right_diagonal_capture?).and_return(false)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field', 'color')
        expect(standard_or_not).to eq(false)
      end
    end
  end

  describe '#one_square_ahead_free?' do
    context 'when the square ahead is free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_pawn
        one_square_ahead_free_or_not = pawn.one_square_ahead_free?([0, 1], [0, 2], playing_field, 'color')
        expect(one_square_ahead_free_or_not).to eq(true)
      end
    end

    context 'when the square ahead is not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][2] = :w_pawn
        one_square_ahead_free_or_not = pawn.one_square_ahead_free?([3, 1], [3, 2], playing_field, 'color')
        expect(one_square_ahead_free_or_not).to eq(false)
      end
    end
  end

  describe '#left_diagonal_capture?' do
    context 'when a left diagonal capture is possible' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        playing_field[3][5] = :b_pawn
        left_diagonal_capture_or_not = pawn.left_diagonal_capture?([4, 4], [3, 5], playing_field, 'color')
        expect(left_diagonal_capture_or_not).to eq(true)
      end
    end

    context 'when a left diagonal capture is not possible' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        left_diagonal_capture_or_not = pawn.left_diagonal_capture?([3, 1], [2, 2], playing_field, 'color')
        expect(left_diagonal_capture_or_not).to eq(false)
      end
    end
  end

  describe '#right_diagonal_capture?' do
    context 'when a right diagonal capture is possible' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_pawn
        playing_field[1][2] = :w_pawn
        right_diagonal_capture_or_not = pawn.right_diagonal_capture?([0, 1], [1, 2], playing_field, 'color')
        expect(right_diagonal_capture_or_not).to eq(true)
      end
    end

    context 'when a left diagonal capture is not possible' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        right_diagonal_capture_or_not = pawn.right_diagonal_capture?([3, 1], [4, 2], playing_field, 'color')
        expect(right_diagonal_capture_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
