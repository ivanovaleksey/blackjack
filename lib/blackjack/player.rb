# frozen_string_literal: true
require 'forwardable'
require 'blackjack/mixins/interacting'

module Blackjack
  class Player
    class NoMoneyError < StandardError; end
    class WouldNotPlayError < StandardError; end

    include Mixins::Interacting
    extend Forwardable
    attr_reader :bet, :hand, :money, :name

    AVAILABLE_MOVES = { s: 'stay', h: 'hit' }.freeze

    def initialize(name, money)
      @name = name
      @hand = Hand.new
      @money = money
    end

    def make_bet
      prompt_text = format('Make your bet (up to %{limit})', limit: @money)
      error_text  = 'Invalid bet, try again.'
      prompt(prompt_text, error_text) do |value|
        if (1..@money).cover? value.to_i
          @bet = value.to_i
          puts
          break
        end
      end
      @money -= @bet
    end

    def make_move
      prompt_text = format("Choose one of the following:\n%{moves}", moves: available_moves_human)
      error_text  = 'Invalid move, try again.'
      move = ''
      prompt(prompt_text, error_text) do |value|
        if AVAILABLE_MOVES.keys.map(&:to_s).include? value
          move = AVAILABLE_MOVES[value.to_sym]
          puts
          break
        end
      end
      move
    end

    def available_moves_human
      AVAILABLE_MOVES.map { |key, value| "#{key} to #{value}" }.join(', ')
    end

    def charge(sum)
      @money += sum.to_i
    end

    def money?
      @money.positive?
    end

    def to_s
      @name
    end

    def_delegators :@hand, :busted?, :blackjack?
  end
end
