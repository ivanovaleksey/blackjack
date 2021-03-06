# frozen_string_literal: true

module Blackjack
  class Deck
    attr_accessor :cards

    SUITS = ['♠', '♦', '♥', '♣'].freeze
    RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].freeze

    def initialize
      refresh
    end

    def pop
      refresh if empty?
      @cards.pop
    end

    def to_s
      @cards.join ', '
    end

    private

    def empty?
      @cards.empty?
    end

    def refresh
      load_cards
      shuffle
    end

    def load_cards
      @cards = SUITS.map do |suit|
        RANKS.map { |rank| Card.new rank, suit }
      end.flatten
    end

    def shuffle
      # TODO: improve shuffling
      @cards.shuffle!
    end
  end
end
