# frozen_string_literal: true

FactoryGirl.define do
  factory :dealer, class: Blackjack::Dealer do
    game { build :game }
    hand { build :hand }
    bet  0

    initialize_with { new(game) }
  end
end
