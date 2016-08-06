# frozen_string_literal: true
require 'blackjack/mixins/interacting'

module Blackjack
  class Dealer
    include Mixins::Interacting
    attr_reader :hand

    PROMPT_NEW_ROUND_OPTIONS = %w(y n).freeze

    def initialize(game)
      @game = game
      @hand = Hand.new
      @bet  = 0
    end

    def play_with(player)
      @player = player
      start_round until @game.over?
    end

    def to_s
      'Dealer'
    end

    private

    def start_round
      prepare_round
      play_round
      count_bets
      @game.is_over = prompt_new_round
    end

    def prepare_round
      @hand.refresh
      @player.hand.refresh

      @player.make_bet
      say_about_money
      deal_initial @player

      deal_initial self
      hide_hole_card

      show_hand @player
      show_hand self
    end

    def play_round
      unless @player.blackjack?
        go_on_with_player
        deal_to_self unless @hand.blackjack?
      end
    rescue Hand::BustedError
      return
    end

    def go_on_with_player
      return if @player.make_move == 'stay'

      deal @player
      show_hand @player
      show_hand self

      if @player.busted?
        show_hand @player
        raise Hand::BustedError
      end

      go_on_with_player
    end

    def count_bets
      if @player.busted?
        # player loses
        puts 'You have busted => you lose'
        say_about_money
        return
      end

      money = 0
      # TODO: refactor this
      if @player.blackjack?
        if @hand.blackjack?
          # dealer and player have blackjack => tied
          money = @player.bet
          puts format('Tied at blackjack. You get your $%{money} back', money: money)
        else
          # player has blackjack, dealer does not => player wins 3:2
          prize = @player.bet * 1.5
          money = @player.bet + prize
          puts format('You have blackjack! You win $%{money}', money: prize)
        end
      else
        if @hand.busted?
          # dealer have busted, player have not => player wins 1:1
          prize = @player.bet
          money = @player.bet + prize
          puts format('%{player} have busted, you have not. You win $%{money}', player: self, money: prize)
        else
          if @player.hand == @hand
            # dealer and player have same score => tied
            money = @player.bet
            puts format('Tied at %{score}. You get your $%{money} back', score: @hand.value, money: money)
          elsif @player.hand > @hand
            # player wins 1:1
            prize = @player.bet
            money = @player.bet + prize
            puts format('You win %{winner_score} : %{looser_score}. You win $%{money}',
                        winner_score: @player.hand.value, looser_score: @hand.value, money: prize)
          else
            # player loses
            if @hand.blackjack?
              puts format('%{winner} has blackjack! You lose your $%{money}', winner: self, money: @player.bet)
            else
              puts format('%{player} wins %{winner_score} : %{looser_score}. You lose your $%{money}',
                          player: self, winner_score: @hand.value, looser_score: @player.hand.value, money: @player.bet)
            end
          end
        end
      end

      @player.charge money
      say_about_money
    end

    def deal_initial(player)
      2.times { deal player }
    end

    def deal(player)
      player.hand.push @game.deck.pop
    end

    def deal_to_self
      deal(self) until enough?

      show_hole_card
      show_hand self
    end

    def hide_hole_card
      @hand.cards.last.hide!
    end

    def show_hole_card
      @hand.hole_card.show!
    end

    def enough?
      @hand.value >= 17
    end

    def show_hand(player)
      pp do
        puts player
        puts player.hand
      end
    end

    def prompt_new_round
      prompt_text = format('Would you like to play new round? (%{options})',
                           options: PROMPT_NEW_ROUND_OPTIONS.join('/'))
      error_text  = 'Invalid answer, try again.'
      answer = ''
      prompt(prompt_text, error_text) do |value|
        if PROMPT_NEW_ROUND_OPTIONS.include? value
          answer = value
          puts
          break
        end
      end
      answer == 'n'
    end

    def say_about_money
      pp('*') { puts format('You have $%{money} left', money: @player.money) }
    end
  end
end
