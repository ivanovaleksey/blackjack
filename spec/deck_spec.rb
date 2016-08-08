# frozen_string_literal: true

describe Blackjack::Deck do
  let(:deck) { build :deck }

  describe '#pop' do
    let(:is_empty) { false }
    before  { allow(deck).to receive(:empty?).and_return is_empty }
    after   { subject }
    subject { deck.pop }

    context 'when deck is empty' do
      let(:is_empty) { true }
      it { expect(deck).to receive :refresh }
    end

    context 'when deck is not empty' do
      it { expect(deck).not_to receive :refresh }
    end

    it { expect(deck.cards).to receive :pop }
  end

  describe '#to_s' do
    after   { subject }
    subject { deck.to_s }
    it { expect(deck.cards).to receive(:join).with ', ' }
  end

  describe '#empty?' do
    subject { deck.send :empty? }

    context 'without cards' do
      let(:deck) { build :deck, :empty }
      it { is_expected.to be_truthy }
    end

    context 'with cards' do
      it { is_expected.to be_falsey }
    end
  end

  describe '#refresh' do
    after   { subject }
    subject { deck.send :refresh }

    it { expect(deck).to receive :load_cards }
    it { expect(deck).to receive :shuffle }
  end

  describe '#load_cards' do
    it 'should load cards'
  end

  describe '#shuffle' do
    after   { subject }
    subject { deck.send :shuffle }
    it { expect(deck.cards).to receive :shuffle! }
  end
end
