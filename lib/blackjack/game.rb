module Blackjack
  class Game
    attr_accessor :is_over
    attr_reader :deck

    START_MONEY = 1000

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

    def over?
      @is_over
    end

    private

    def say_greetings
      puts 'Hi there!'
    end

    def say_rules
      puts RULES
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

  end
end
