# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/player.rb'

RSpec.describe Player do
  subject(:player) { described_class.new }
  describe '#move_in_right_format?' do
    context 'it is a move in the right format' do
      it 'returns true' do
        right_format_or_not = player.move_in_right_format?('a1a3')
        expect(right_format_or_not).to eq(true)
      end

      it 'returns true' do
        right_format_or_not = player.move_in_right_format?('b3h4')
        expect(right_format_or_not).to eq(true)
      end
    end

    context 'it is a move of the wrong length' do
      it 'returns false' do
        right_format_or_not = player.move_in_right_format?('a1a3a5')
        expect(right_format_or_not).to eq(false)
      end

      it 'returns false' do
        right_format_or_not = player.move_in_right_format?('b3')
        expect(right_format_or_not).to eq(false)
      end
    end

    context 'it is a move in the wrong format' do
      it 'returns false' do
        right_format_or_not = player.move_in_right_format?('aabb')
        expect(right_format_or_not).to eq(false)
      end

      it 'returns false' do
        right_format_or_not = player.move_in_right_format?('b0h9')
        expect(right_format_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
