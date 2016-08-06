# frozen_string_literal: true

module Blackjack
  module Mixins
    module Interacting
      def pp(sign = nil)
        yield
        puts Array.new(21, sign).join('') if sign
        puts
      end

      def prompt(text, error)
        loop do
          pp('^') do
            print text, ' '
            yield gets.chomp
            puts error
          end
        end
      end
    end
  end
end
