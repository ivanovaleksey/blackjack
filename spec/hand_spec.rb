# frozen_string_literal: true

describe Blackjack::Hand do
  let(:hand)  { build :hand, cards: cards }
  let(:cards) { [] }

  describe '#refresh' do
    let(:cards) { %w(J A K) }
    before  { subject }
    subject { hand.refresh }

    it { expect(hand.cards).to be_empty }
  end

  describe '#value' do
    subject { hand.value }
    it 'should return hand value'
  end

  describe '#new?' do
    subject { hand.new? }

    context 'with 2 cards' do
      let(:cards) { %w(K K) }
      it { is_expected.to be_truthy }
    end

    context 'with any other count' do
      let(:cards) { %w(K K K) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#blackjack?' do
    let(:is_new) { false }
    let(:value)  { rand(1...Blackjack::Hand::BLACKJACK) }
    before do
      allow(hand).to receive(:new?).and_return is_new
      allow(hand).to receive(:value).and_return value
    end
    subject { hand.blackjack? }

    context 'when hand is new' do
      let(:is_new) { true }

      context 'when blackjack!' do
        let(:value) { Blackjack::Hand::BLACKJACK }
        it { is_expected.to be_truthy }
      end

      context 'when not blackjack' do
        it { is_expected.to be_falsey }
      end
    end

    context 'when hand is not new' do
      it { is_expected.to be_falsey }
    end
  end

  describe '#busted?' do
    before  { allow(hand).to receive(:value).and_return value }
    subject { hand.busted? }

    context 'when value is greater than blackjack' do
      let(:value) { Blackjack::Hand::BLACKJACK + rand(1..5) }
      it { is_expected.to be_truthy }
    end

    context 'when value is equal blackjack' do
      let(:value) { Blackjack::Hand::BLACKJACK }
      it { is_expected.to be_falsey }
    end

    context 'when value is less blackjack' do
      let(:value) { Blackjack::Hand::BLACKJACK - rand(1..5) }
      it { is_expected.to be_falsey }
    end
  end

  describe '#hole_card' do
    let(:hole_card) { build :card, :hole }
    before  { hand.push hole_card }
    subject { hand.hole_card }
    it { is_expected.to eq hole_card }
  end

  describe '#to_s' do
    subject { hand.to_s }
  end
end
