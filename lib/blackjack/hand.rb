# frozen_string_literal: true
require 'forwardable'

module Blackjack
  class Hand
    class BustedError < StandardError; end

    include Comparable
    extend Forwardable
    attr_accessor :cards

    BLACKJACK = 21

    def initialize
      refresh
    end

    def refresh
      @cards = []
    end

    def value
      val = @cards.reject(&:ace?).inject(0) { |a, e| a + e.value }
      ace = @cards.find(&:ace?)
      if ace
        ace.value = val <= (BLACKJACK - 11) ? 11 : 1
        val += ace.value
      end
      val
    end

    def new?
      @cards.count == 2
    end

    def blackjack?
      new? && value == BLACKJACK
    end

    def busted?
      value > BLACKJACK
    end

    def hole_card
      @cards.find(&:hole?)
    end

    def <=>(other)
      value <=> other.value
    end

    def to_s
      displayed_value = value
      displayed_value -= hole_card.value if hole_card
      format 'Cards: %{cards}, Value: %{value}', cards: @cards.join(', '), value: displayed_value
    end

    def_delegators :@cards, :push
  end
end
