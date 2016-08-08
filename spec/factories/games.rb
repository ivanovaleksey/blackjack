# frozen_string_literal: true

FactoryGirl.define do
  factory :game, class: Blackjack::Game do
    deck    { build :deck }
    is_over false
  end
end
