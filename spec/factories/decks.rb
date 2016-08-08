# frozen_string_literal: true

FactoryGirl.define do
  factory :deck, class: Blackjack::Deck do
    trait :empty do
      cards []
    end
  end
end
