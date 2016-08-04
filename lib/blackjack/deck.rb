module Blackjack
  class Deck
    attr_reader :cards

    SUITS = ['♠', '♦', '♥', '♣'].freeze
    RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 'J', 'Q', 'K', 'A'].freeze

    def initialize
      refresh
    end

    def refresh
      @cards = SUITS.map do |suit|
        RANKS.map { |rank| Card.new rank, suit }
      end.flatten
      # TODO: improve shuffling
      @cards.shuffle!
    end

    def empty?
      @cards.empty?
    end

    def pop
      refresh if empty?
      @cards.pop
    end

    def to_s
      @cards.join ', '
    end

  end
end
