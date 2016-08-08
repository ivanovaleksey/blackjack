# frozen_string_literal: true

FactoryGirl.define do
  factory :hand, class: Blackjack::Hand do
    cards { build_list :card, 2 }
  end
end
