# frozen_string_literal: true

module Blackjack
  module Hands
    class Dealer < Base
      def hole_card
        @hole_card ||= (new? ? @cards.last : nil)
      end
    end
  end
end
