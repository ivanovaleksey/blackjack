# frozen_string_literal: true

module Blackjack
  class Dealer
    attr_reader :hand

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
      p '--------------'
    end

    def play_round
      puts 'play_round'
      go_on_with_player unless @player.blackjack?
      deal_to_self unless @hand.blackjack? # TODO: unless can_have_blackjack?
    rescue Hand::BustedError
      return
    end

    def go_on_with_player
      move = @player.make_move
      return if move == 's'

      deal @player
      show_hand @player
      show_hand self
      p '--------------'

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
      if @player.blackjack?
        if @hand.blackjack?
          # dealer and player have blackjack => tied
          money = @player.bet
          puts format('Tied at blackjack. You get your $%{money} back', money: money)
        else
          # player has blackjack, dealer does not => player wins 3:2
          money = @player.bet * 2.5
          puts format('You have blackjack! You win $%{money}', money: money)
        end
      else
        if @hand.busted?
          # dealer have busted, player have not => player wins 1:1
          money = @player.bet * 2
          puts format('%{player} have busted, you have not. You win $%{money}', player: self, money: money)
        else
          if @player.hand == @hand
            # dealer and player have same score => tied
            money = @player.bet
            puts format('Tied at %{score}. You get your $%{money} back', score: @hand.value, money: money)
          elsif @player.hand > @hand
            # player wins 1:1
            money = @player.bet * 2
            puts format('You win %{winner_score} : %{looser_score}. You win $%{money}',
                        winner_score: @player.hand.value, looser_score: @hand.value, money: money)
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
      puts 'deal_to_self'
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
      puts player
      puts player.hand
    end

    def prompt_new_round
      puts 'Would you like to play another round? (y/n)'
      gets.chomp == 'n'
    end

    def say_about_money
      puts format("You have $%s left\n\n", @player.money)
    end
  end
end
