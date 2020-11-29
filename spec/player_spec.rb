# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

require_relative '../lib/player.rb'

RSpec.describe Player do
  subject(:player) { described_class.new }
  describe '#user_input' do
    context 'when a1a3 is input' do
      before do
        allow(player).to receive(:obtain_user_input).and_return('a1a3')
      end

      it 'returns a1a3' do
        input = player.user_input(:move)
        expect(input).to eq('a1a3')
      end
    end

    context 'when input is invalid twice, then a1a3 is input' do
      before do
        allow(player).to receive(:obtain_user_input).and_return('invalid', 'invalid', 'a1a3')
        allow(player).to receive(:puts)
      end

      it 'returns a1a3' do
        input = player.user_input(:move)
        expect(input).to eq('a1a3')
      end
    end
  end

  describe '#input_in_correct_format?' do
    context 'it is a move input in the right format' do
      it 'returns true' do
        correct_format_or_not = player.input_in_correct_format?('a1a3', :move)
        expect(correct_format_or_not).to eq(true)
      end

      it 'returns true' do
        correct_format_or_not = player.input_in_correct_format?('b3h4', :move)
        expect(correct_format_or_not).to eq(true)
      end
    end

    context 'it is a move input of the wrong length' do
      it 'returns false' do
        correct_format_or_not = player.input_in_correct_format?('a1a3a5', :move)
        expect(correct_format_or_not).to eq(false)
      end

      it 'returns false' do
        correct_format_or_not = player.input_in_correct_format?('b3', :move)
        expect(correct_format_or_not).to eq(false)
      end
    end

    context 'it is a move input in the wrong format' do
      it 'returns false' do
        correct_format_or_not = player.input_in_correct_format?('aabb', :move)
        expect(correct_format_or_not).to eq(false)
      end

      it 'returns false' do
        correct_format_or_not = player.input_in_correct_format?('b0h9', :move)
        expect(correct_format_or_not).to eq(false)
      end
    end

    context 'it is a piece input in the right format' do
      it 'returns true' do
        correct_format_or_not = player.input_in_correct_format?('q', :piece)
        expect(correct_format_or_not).to eq(true)
      end

      it 'returns true' do
        correct_format_or_not = player.input_in_correct_format?('n', :piece)
        expect(correct_format_or_not).to eq(true)
      end
    end

    context 'it is a move input in the right format' do
      it 'returns true' do
        correct_format_or_not = player.input_in_correct_format?('q', :move)
        expect(correct_format_or_not).to eq(true)
      end

      it 'returns true' do
        correct_format_or_not = player.input_in_correct_format?('Q', :move)
        expect(correct_format_or_not).to eq(true)
      end

      it 'returns true' do
        correct_format_or_not = player.input_in_correct_format?('S', :move)
        expect(correct_format_or_not).to eq(true)
      end

      it 'returns true' do
        correct_format_or_not = player.input_in_correct_format?('l', :move)
        expect(correct_format_or_not).to eq(true)
      end
    end

    context 'it is a move input of the wrong length' do
      it 'returns false' do
        correct_format_or_not = player.input_in_correct_format?('a1a3a5', :piece)
        expect(correct_format_or_not).to eq(false)
      end

      it 'returns false' do
        correct_format_or_not = player.input_in_correct_format?('k', :piece)
        expect(correct_format_or_not).to eq(false)
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
