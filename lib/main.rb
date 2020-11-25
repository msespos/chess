# frozen_string_literal: true

require_relative 'game'
require_relative 'player'
require_relative 'minimalist_board'
require_relative 'checkerboard_board'
require_relative 'piece'
require_relative 'pawn'
require_relative 'knight'
require_relative 'rook'
require_relative 'bishop'
require_relative 'queen'
require_relative 'king'

Game.new.play
