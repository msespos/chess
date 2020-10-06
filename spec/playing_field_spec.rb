# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/playing_field.rb'

RSpec.describe PlayingField do
  subject(:field) { described_class.new }
  describe '#initialize' do
    context 'when the game class is instantiated' do
      it 'creates an instance of Board' do
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
