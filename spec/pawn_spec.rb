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
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color', 'column')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is on the starting rank with standard conditions met' do
      it 'returns true' do
        allow(pawn).to receive(:on_starting_rank?).and_return(true)
        allow(pawn).to receive(:standard_conditions_met?).and_return(true)
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color', 'column')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is not on the starting rank with standard conditions met' do
      it 'returns true' do
        allow(pawn).to receive(:on_starting_rank?).and_return(false)
        allow(pawn).to receive(:standard_conditions_met?).and_return(true)
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color', 'column')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is not on the starting rank, standard conditions not met, en passant condiitons met' do
      it 'returns false' do
        allow(pawn).to receive(:on_starting_rank?).and_return(false)
        allow(pawn).to receive(:standard_conditions_met?).and_return(false)
        allow(pawn).to receive(:en_passant_conditions_met?).and_return(true)
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color', 'column')
        expect(path_or_not).to eq(true)
      end
    end

    context 'when it is not on the starting rank with neither standard nor en passant condiitons met' do
      it 'returns false' do
        allow(pawn).to receive(:on_starting_rank?).and_return(false)
        allow(pawn).to receive(:standard_conditions_met?).and_return(false)
        allow(pawn).to receive(:en_passant_conditions_met?).and_return(false)
        path_or_not = pawn.path?('start', 'finish', 'playing field', 'color', 'column')
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
    context 'when the pawn is a white pawn' do
      it 'calls #white_two_squares?' do
        expect(pawn).to receive(:white_two_squares?)
        pawn.two_squares_ahead_free?('start', 'finish', 'playing field', :white)
      end
    end

    context 'when the pawn is a black pawn' do
      it 'calls #black_two_squares?' do
        expect(pawn).to receive(:black_two_squares?)
        pawn.two_squares_ahead_free?('start', 'finish', 'playing field', :black)
      end
    end
  end

  describe '#white_two_squares?' do
    context 'when it is a white pawn and the two squares ahead are free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_pawn
        white_two_squares_or_not = pawn.white_two_squares?([0, 1], [0, 3], playing_field)
        expect(white_two_squares_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn and the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][2] = :w_pawn
        white_two_squares_or_not = pawn.white_two_squares?([3, 1], [3, 3], playing_field)
        expect(white_two_squares_or_not).to eq(false)
      end
    end

    context 'when it is a white pawn and the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][3] = :w_pawn
        white_two_squares_or_not = pawn.white_two_squares?([3, 1], [3, 3], playing_field)
        expect(white_two_squares_or_not).to eq(false)
      end
    end
  end

  describe '#black_two_squares?' do
    context 'when it is a black pawn and the two squares ahead are free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][6] = :b_pawn
        black_two_squares_or_not = pawn.black_two_squares?([0, 6], [0, 4], playing_field)
        expect(black_two_squares_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn and the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][6] = :b_pawn
        playing_field[3][5] = :b_pawn
        black_two_squares_or_not = pawn.black_two_squares?([3, 6], [3, 4], playing_field)
        expect(black_two_squares_or_not).to eq(false)
      end
    end

    context 'when it is a black pawn and the two squares ahead are not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][6] = :b_pawn
        playing_field[3][4] = :b_pawn
        black_two_squares_or_not = pawn.black_two_squares?([3, 6], [3, 4], playing_field)
        expect(black_two_squares_or_not).to eq(false)
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
        allow(pawn).to receive(:one_square_ahead_free?).and_return(false)
        allow(pawn).to receive(:left_diagonal_capture?).and_return(true)
        standard_or_not = pawn.standard_conditions_met?('start', 'finish,', 'playing field', 'color')
        expect(standard_or_not).to eq(true)
      end
    end

    context 'when it has a right diagonal capture available' do
      it 'returns true' do
        allow(pawn).to receive(:one_square_ahead_free?).and_return(false)
        allow(pawn).to receive(:left_diagonal_capture?).and_return(false)
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
    context 'when the pawn is a white pawn' do
      it 'calls #white_one_square?' do
        expect(pawn).to receive(:white_one_square?)
        pawn.one_square_ahead_free?('start', 'finish', 'playing field', :white)
      end
    end

    context 'when the pawn is a black pawn' do
      it 'calls #black_one_square?' do
        expect(pawn).to receive(:black_one_square?)
        pawn.one_square_ahead_free?('start', 'finish', 'playing field', :black)
      end
    end
  end

  describe '#white_one_square?' do
    context 'when it is a white pawn and the square ahead is free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_pawn
        white_one_square_or_not = pawn.white_one_square?([0, 1], [0, 2], playing_field)
        expect(white_one_square_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn and the square ahead is not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        playing_field[3][2] = :w_pawn
        white_one_square_or_not = pawn.white_one_square?([3, 1], [3, 2], playing_field)
        expect(white_one_square_or_not).to eq(false)
      end
    end
  end

  describe '#black_one_square?' do
    context 'when it is a black pawn and the square ahead is free' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][6] = :b_pawn
        black_one_square_or_not = pawn.black_one_square?([0, 6], [0, 5], playing_field)
        expect(black_one_square_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn and the square ahead is not free' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][6] = :b_pawn
        playing_field[3][5] = :b_pawn
        black_one_square_or_not = pawn.black_one_square?([3, 6], [3, 5], playing_field)
        expect(black_one_square_or_not).to eq(false)
      end
    end
  end

  describe '#left_diagonal_capture?' do
    context 'when it is a white pawn' do
      it 'calls white_left_diagonal?' do
        expect(pawn).to receive(:white_left_diagonal?)
        pawn.left_diagonal_capture?('start', 'finish', 'playing field', :white)
      end
    end
  end

  describe '#white_left_diagonal?' do
    context 'when it is a white pawn and a left diagonal capture is possible' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        playing_field[3][5] = :b_pawn
        white_left_diagonal_or_not = pawn.white_left_diagonal?([4, 4], [3, 5], playing_field)
        expect(white_left_diagonal_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn and a left diagonal capture is not possible' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        white_left_diagonal_or_not = pawn.white_left_diagonal?([3, 1], [2, 2], playing_field)
        expect(white_left_diagonal_or_not).to eq(false)
      end
    end
  end

  describe '#black_left_diagonal?' do
    context 'when it is a black pawn and a left diagonal capture is possible' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][5] = :b_pawn
        playing_field[5][4] = :w_pawn
        black_left_diagonal_or_not = pawn.black_left_diagonal?([4, 5], [5, 4], playing_field)
        expect(black_left_diagonal_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn and a left diagonal capture is not possible' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[2][2] = :b_pawn
        black_left_diagonal_or_not = pawn.black_left_diagonal?([2, 2], [3, 1], playing_field)
        expect(black_left_diagonal_or_not).to eq(false)
      end
    end
  end

  describe '#right_diagonal_capture?' do
    context 'when it is a white pawn' do
      it 'calls white_right_diagonal?' do
        expect(pawn).to receive(:white_right_diagonal?)
        pawn.right_diagonal_capture?('start', 'finish', 'playing field', :white)
      end
    end
  end

  describe '#white_right_diagonal?' do
    context 'when it is a white pawn and a right diagonal capture is possible' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[0][1] = :w_pawn
        playing_field[1][2] = :b_pawn
        white_right_diagonal_or_not = pawn.white_right_diagonal?([0, 1], [1, 2], playing_field)
        expect(white_right_diagonal_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn and a right diagonal capture is not possible' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[3][1] = :w_pawn
        white_right_diagonal_or_not = pawn.white_right_diagonal?([3, 1], [4, 2], playing_field)
        expect(white_right_diagonal_or_not).to eq(false)
      end
    end
  end

  describe '#black_right_diagonal?' do
    context 'when it is a black pawn and a right diagonal capture is possible' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[1][2] = :b_pawn
        playing_field[0][1] = :w_pawn
        black_right_diagonal_or_not = pawn.black_right_diagonal?([1, 2], [0, 1], playing_field)
        expect(black_right_diagonal_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn and a right diagonal capture is not possible' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][2] = :b_pawn
        black_right_diagonal_or_not = pawn.black_right_diagonal?([4, 2], [3, 1], playing_field)
        expect(black_right_diagonal_or_not).to eq(false)
      end
    end
  end

  describe '#square_not_empty?' do
    context 'when the square is not empty' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][2] = :b_pawn
        not_empty_or_not = pawn.square_not_empty?([4, 2], playing_field)
        expect(not_empty_or_not).to eq(true)
      end
    end

    context 'when the square is empty' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        not_empty_or_not = pawn.square_not_empty?([4, 2], playing_field)
        expect(not_empty_or_not).to eq(false)
      end
    end
  end

  describe '#en_passant_conditions_met?' do
    context 'when it is not on an en passant starting rank' do
      it 'returns false' do
        allow(pawn).to receive(:on_en_passant_starting_rank?).and_return(false)
        allow(pawn).to receive(:left_en_passant?).and_return(true)
        en_passant_or_not = pawn.en_passant_conditions_met?('start', 'finish,',
                                                            'playing field', 'color', 'column')
        expect(en_passant_or_not).to eq(false)
      end
    end

    context 'when it has a left en passant capture available' do
      it 'returns true' do
        allow(pawn).to receive(:on_en_passant_starting_rank?).and_return(true)
        allow(pawn).to receive(:left_en_passant?).and_return(true)
        en_passant_or_not = pawn.en_passant_conditions_met?('start', 'finish,',
                                                            'playing field', 'color', 'column')
        expect(en_passant_or_not).to eq(true)
      end
    end

    context 'when it has a right en passant capture available' do
      it 'returns true' do
        allow(pawn).to receive(:on_en_passant_starting_rank?).and_return(true)
        allow(pawn).to receive(:left_en_passant?).and_return(false)
        allow(pawn).to receive(:right_en_passant?).and_return(true)
        en_passant_or_not = pawn.en_passant_conditions_met?('start', 'finish,',
                                                            'playing field', 'color', 'column')
        expect(en_passant_or_not).to eq(true)
      end
    end

    context 'when none of the en passant conditions are met' do
      it 'returns false' do
        allow(pawn).to receive(:on_en_passant_starting_rank?).and_return(false)
        allow(pawn).to receive(:left_en_passant?).and_return(false)
        allow(pawn).to receive(:right_en_passant?).and_return(false)
        en_passant_or_not = pawn.en_passant_conditions_met?('start', 'finish,',
                                                            'playing field', 'color', 'column')
        expect(en_passant_or_not).to eq(false)
      end
    end
  end

  describe '#on_en_passant_starting_rank?' do
    context 'when it is a white pawn on the en passant starting rank' do
      it 'returns true' do
        en_passant_rank_or_not = pawn.on_en_passant_starting_rank?([6, 4], :white)
        expect(en_passant_rank_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn on the en passant starting rank' do
      it 'returns true' do
        en_passant_rank_or_not = pawn.on_en_passant_starting_rank?([6, 3], :black)
        expect(en_passant_rank_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn not on the en passant starting rank' do
      it 'returns false' do
        en_passant_rank_or_not = pawn.on_en_passant_starting_rank?([7, 6], :white)
        expect(en_passant_rank_or_not).to eq(false)
      end
    end

    context 'when it is a black pawn not on the en passant starting rank' do
      it 'returns false' do
        en_passant_rank_or_not = pawn.on_en_passant_starting_rank?([4, 1], :black)
        expect(en_passant_rank_or_not).to eq(false)
      end
    end
  end

  # integration tests that also test #left_diagonal_capture? and related helper methods
  describe '#left_en_passant?' do
    context 'when it is a white pawn that can make a left diagonal en passant capture' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        playing_field[3][4] = :b_pawn
        left_en_passant_or_not = pawn.left_en_passant?([4, 4], [3, 5], playing_field, :white, 3)
        expect(left_en_passant_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn that can make a left diagonal en passant capture' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][3] = :b_pawn
        playing_field[5][3] = :w_pawn
        left_en_passant_or_not = pawn.left_en_passant?([4, 3], [5, 2], playing_field, :black, 5)
        expect(left_en_passant_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn that can not make a left diagonal en passant capture' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        playing_field[3][4] = :b_pawn
        left_en_passant_or_not = pawn.left_en_passant?([4, 4], [3, 5], playing_field, :white, 2)
        expect(left_en_passant_or_not).to eq(false)
      end
    end

    context 'when it is a white pawn that can not make a left diagonal en passant capture' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        playing_field[3][5] = :b_pawn
        left_en_passant_or_not = pawn.left_en_passant?([4, 4], [3, 5], playing_field, :white, 2)
        expect(left_en_passant_or_not).to eq(false)
      end
    end

    context 'when it is a white pawn that can not make a left diagonal en passant capture' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        left_en_passant_or_not = pawn.left_en_passant?([4, 4], [3, 5], playing_field, :white, nil)
        expect(left_en_passant_or_not).to eq(false)
      end
    end
  end

  # integration tests that also test #right_diagonal_capture? and related helper methods
  describe '#left_en_passant?' do
    context 'when it is a white pawn that can make a right diagonal en passant capture' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        playing_field[5][4] = :b_pawn
        right_en_passant_or_not = pawn.right_en_passant?([4, 4], [5, 5], playing_field, :white, 5)
        expect(right_en_passant_or_not).to eq(true)
      end
    end

    context 'when it is a black pawn that can make a right diagonal en passant capture' do
      it 'returns true' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][3] = :b_pawn
        playing_field[3][3] = :w_pawn
        right_en_passant_or_not = pawn.right_en_passant?([4, 3], [3, 2], playing_field, :black, 3)
        expect(right_en_passant_or_not).to eq(true)
      end
    end

    context 'when it is a white pawn that can not make a right diagonal en passant capture' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        playing_field[5][4] = :b_pawn
        right_en_passant_or_not = pawn.right_en_passant?([4, 4], [5, 5], playing_field, :white, 2)
        expect(right_en_passant_or_not).to eq(false)
      end
    end

    context 'when it is a white pawn that can not make a right diagonal en passant capture' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        playing_field[5][4] = :b_pawn
        right_en_passant_or_not = pawn.right_en_passant?([4, 4], [5, 5], playing_field, :white, 2)
        expect(right_en_passant_or_not).to eq(false)
      end
    end

    context 'when it is a white pawn that can not make a right diagonal en passant capture' do
      it 'returns false' do
        playing_field = Array.new(8) { Array.new(8) { nil } }
        playing_field[4][4] = :w_pawn
        right_en_passant_or_not = pawn.right_en_passant?([4, 4], [5, 5], playing_field, :white, nil)
        expect(right_en_passant_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
