# frozen_string_literal: true

module Blackjack
  module Hands
    class BustedError < StandardError; end

    class Base
      include Comparable
      attr_reader :cards

      BLACKJACK = 21

      def initialize
        refresh
      end

      def refresh
        @cards = []
        @value = 0
        @has_ace = false
        @hole_card = nil
      end

      def push(card)
        @has_ace ||= card.ace?
        @cards << card
      end

      def value
        val = @cards.inject(0) { |a, e| a + e.value }
        val += 10 if has_ace? && val <= (BLACKJACK - 10)
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

      def has_ace?
        @has_ace
      end

      def hole_card
        raise NotImplementedError
      end

      def <=>(other)
        value <=> other.value
      end

      def to_s
        displayed_value = value
        displayed_value -= hole_card.value if hole_card
        format 'Cards: %s, Value: %s (%s)', @cards.join(', '), displayed_value, value
      end
    end
  end
end
