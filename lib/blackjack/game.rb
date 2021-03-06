# frozen_string_literal: true
require 'blackjack/mixins/interacting'

module Blackjack
  class Game
    include Mixins::Interacting
    attr_accessor :deck, :is_over

    START_MONEY = 1_000

    RULES = <<-RULES.gsub(/^\s*/, '')
      The game is implemented with the following rules:
      - There are two players: you and the dealer (computer)
      - You got only two choises: hit or stay
      - The dealer starts with two cards one of them is faced down (the hole card)
      - The deck is endless
    RULES

    def initialize
      @deck = Deck.new
      @is_over = false
    end

    def start
      say_greetings
      say_rules

      define_player do |player|
        dealer.play_with player
      end
      puts 'Good bye! Thanks for the game.'
    end

    alias over? is_over

    private

    def say_greetings
      pp('~') do
        puts <<-GREETING.gsub(/^\s*/, '')
          Hi there!
          Welcome to Blackjack v#{version}
        GREETING
      end
    end

    def say_rules
      pp('~') { puts RULES }
    end

    def define_player
      print 'What is your name [Player]? '
      name = gets.chomp
      name = name.empty? ? 'Player' : name
      yield Player.new(name, START_MONEY)
    end

    def dealer
      Dealer.new self
    end

    def version
      @version ||= `cat .version`.strip
    end
  end
end
