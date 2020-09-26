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
        expect(field).to eq([%i[w_rook w_knight w_bishop w_queen w_king w_bishop w_knight w_rook],
                             %i[w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn w_pawn],
                             [nil, nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil, nil],
                             [nil, nil, nil, nil, nil, nil, nil, nil],
                             %i[b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn b_pawn],
                             %i[b_rook b_knight b_bishop b_queen b_king b_bishop b_knight b_rook]])
        game.starting_playing_field
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
