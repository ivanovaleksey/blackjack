# frozen_string_literal: true
require 'forwardable'

module Blackjack
  class Player
    extend Forwardable
    attr_reader :bet, :hand, :money, :name

    def initialize(name, money)
      @name = name
      @hand = Hands::Player.new
      @money = money
    end

    def make_bet
      puts 'Make your bet'
      @bet = gets.chomp.to_i
      @money -= @bet
    end

    def make_move
      puts 'Choose one of the following:'
      puts available_moves
      gets.chomp
    end

    def available_moves
      @available_moves ||= [{ s: 'stay', h: 'hit' }]
    end

    def charge(sum)
      @money += sum
    end

    def to_s
      @name
    end

    def_delegators :@hand, :busted?
    def_delegators :@hand, :blackjack?
  end
end
