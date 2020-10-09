# frozen_string_literal: true

require_relative 'game.rb'
require_relative 'player.rb'
require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'pawn.rb'
require_relative 'knight.rb'
require_relative 'rook.rb'
require_relative 'bishop.rb'
require_relative 'queen.rb'
require_relative 'king.rb'

Game.new.play
