# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/pawn.rb'

RSpec.describe Pawn do
  subject(:pawn) { described_class.new }
  describe '#path?' do
    context 'when it is a white pawn and has a white path' do
      it 'returns true' do
        allow(pawn).to receive(:white_pawn_path?).and_return(true)
        path_or_not = pawn.path?('start', 'finish,', 'playing field', :white)
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn and does not have a white path' do
      it 'returns false' do
        allow(pawn).to receive(:white_pawn_path?).and_return(false)
        path_or_not = pawn.path?('start', 'finish,', 'playing field', :white)
        expect(path_or_not).to eq(false)
      end
    end

    context 'when it is a black pawn and has a black path' do
      it 'returns true' do
        allow(pawn).to receive(:black_pawn_path?).and_return(true)
        path_or_not = pawn.path?('start', 'finish,', 'playing field', :black)
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn and does not have a black path' do
      it 'returns false' do
        allow(pawn).to receive(:black_pawn_path?).and_return(false)
        path_or_not = pawn.path?('start', 'finish,', 'playing field', :black)
        expect(path_or_not).to eq(false)
      end
    end
  end

  describe '#white_pawn_path?' do
    context 'when it is on the second rank with two squares ahead free' do
      it 'returns true' do
        allow(pawn).to receive(:on_second_rank?).and_return(true)
        allow(pawn).to receive(:two_squares_ahead_free?).and_return(true)
        path_or_not = pawn.white_pawn_path?('start', 'finish,', 'playing field')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is on the second rank with standard conditions met' do
      it 'returns true' do
        allow(pawn).to receive(:on_second_rank?).and_return(true)
        allow(pawn).to receive(:standard_conditions_met?).and_return(true)
        path_or_not = pawn.white_pawn_path?('start', 'finish,', 'playing field')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is not on the second rank with standard conditions met' do
      it 'returns true' do
        allow(pawn).to receive(:on_second_rank?).and_return(false)
        allow(pawn).to receive(:standard_conditions_met?).and_return(true)
        path_or_not = pawn.white_pawn_path?('start', 'finish,', 'playing field')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is not on the second rank with standard conditions not met' do
      it 'returns false' do
        allow(pawn).to receive(:on_second_rank?).and_return(false)
        allow(pawn).to receive(:standard_conditions_met?).and_return(false)
        path_or_not = pawn.white_pawn_path?('start', 'finish,', 'playing field')
        expect(path_or_not).to eq(false)
      end
    end
  end

  describe '#on_second_rank?' do
    context 'when it is on the second rank' do
      it 'returns true' do
        second_rank_or_not = pawn.on_second_rank?([6, 1])
        expect(second_rank_or_not).to eq(true)
      end
    end

    context 'when it is not on the second rank' do
      it 'returns false' do
        second_rank_or_not = pawn.on_second_rank?([6, 5])
        expect(second_rank_or_not).to eq(false)
      end
    end
  end

  describe '#two_squares_ahead_free?' do
    context 'when the two squares ahead are free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([0, 1], [0, 3], playing_field)
        expect(two_squares_ahead_free_or_not).to eq(true)
      end
    end

    context 'when the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][2] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([3, 1], [3, 3], playing_field)
        expect(two_squares_ahead_free_or_not).to eq(false)
      end
    end

    context 'when the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][3] = :w_pawn
        two_squares_ahead_free_or_not = pawn.two_squares_ahead_free?([3, 1], [3, 3], playing_field)
        expect(two_squares_ahead_free_or_not).to eq(false)
      end
    end
  end

  describe '#standard_conditions_met?' do
    context 'when it has one square ahead free' do
      it 'returns true' do
        allow(pawn).to receive(:one_square_ahead_free?).and_return(true)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field')
        expect(standard_or_not).to eq(true)
      end
    end

    context 'when it has a left diagonal capture available' do
      it 'returns true' do
        allow(pawn).to receive(:left_diagonal_capture?).and_return(true)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field')
        expect(standard_or_not).to eq(true)
      end
    end

    context 'when it has a right diagonal capture available' do
      it 'returns true' do
        allow(pawn).to receive(:right_diagonal_capture?).and_return(true)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field')
        expect(standard_or_not).to eq(true)
      end
    end

    context 'when none of the standard conditions are met' do
      it 'returns false' do
        allow(pawn).to receive(:one_square_ahead_free?).and_return(false)
        allow(pawn).to receive(:left_diagonal_capture?).and_return(false)
        allow(pawn).to receive(:right_diagonal_capture?).and_return(false)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field')
        expect(standard_or_not).to eq(false)
      end
    end
  end

  describe '#one_square_ahead_free?' do
    context 'when the square ahead is free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_pawn
        one_square_ahead_free_or_not = pawn.one_square_ahead_free?([0, 1], [0, 2], playing_field)
        expect(one_square_ahead_free_or_not).to eq(true)
      end
    end

    context 'when the square ahead is not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][2] = :w_pawn
        one_square_ahead_free_or_not = pawn.one_square_ahead_free?([3, 1], [3, 2], playing_field)
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
        left_diagonal_capture_or_not = pawn.left_diagonal_capture?([4, 4], [3, 5], playing_field)
        expect(left_diagonal_capture_or_not).to eq(true)
      end
    end

    context 'when a left diagonal capture is not possible' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        left_diagonal_capture_or_not = pawn.left_diagonal_capture?([3, 1], [2, 2], playing_field)
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
        right_diagonal_capture_or_not = pawn.right_diagonal_capture?([0, 1], [1, 2], playing_field)
        expect(right_diagonal_capture_or_not).to eq(true)
      end
    end

    context 'when a left diagonal capture is not possible' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        right_diagonal_capture_or_not = pawn.right_diagonal_capture?([3, 1], [4, 2], playing_field)
        expect(right_diagonal_capture_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
