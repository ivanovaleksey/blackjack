module Blackjack
  class Card

    def initialize(rank, suit)
      @rank = rank
      @suit = suit
      @is_hole = false
    end

    def value
      @value ||=
        case @rank
          when 2..10         then @rank
          when 'J', 'Q', 'K' then 10
          when 'A'           then 1
        end
    end

    def ace?
      @rank == 'A'
    end

    def hide!
      @is_hole = true
    end

    def show!
      @is_hole = false
    end

    def hole?
      @is_hole
    end

    def to_s
      hole? ? 'Hole' : format('%s %s', @rank, @suit)
    end

  end
end
