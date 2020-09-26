# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/game.rb'

RSpec.describe Game do
  describe '#initialize' do
    subject(:game) { described_class.new }
    context 'when the game class is instantiated' do
      it 'creates an instance of Board' do
        board = game.instance_variable_get(:@board)
        expect(board).to be_a(Board)
        game.send(:initialize)
      end

      it 'calls #opening_playing_field' do
        expect(game).to receive(:opening_playing_field)
        game.send(:initialize)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
