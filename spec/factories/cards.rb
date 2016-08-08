# frozen_string_literal: true

FactoryGirl.define do
  factory :card, class: Blackjack::Card do
    rank    Blackjack::Deck::RANKS.sample
    suit    Blackjack::Deck::SUITS.sample
    is_hole false

    initialize_with { new(rank, suit) }

    trait :hole do
      is_hole true
    end

    trait :digit do
      rank { (2..10).to_a.sample }
    end

    trait :face do
      rank %w(J Q K).sample
    end

    trait :ace do
      rank 'A'
    end
  end
end
