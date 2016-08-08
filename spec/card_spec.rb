# frozen_string_literal: true

describe Blackjack::Card do
  let(:card) { build :card }

  describe '#value' do
    subject { card.value }

    context 'with digit card' do
      let(:card) { build :card, :digit }
      it { is_expected.to eq card.rank }
    end

    context 'with face card' do
      let(:card) { build :card, :face }
      it { is_expected.to eq 10 }
    end

    context 'with ace' do
      let(:card) { build :card, :ace }
      it { is_expected.to eq 1 }
    end
  end

  describe '#ace?' do
    subject { card.ace? }

    context 'with ace' do
      let(:card) { build :card, :ace }
      it { is_expected.to be_truthy }
    end

    context 'with any other card' do
      let(:card) { build :card, :face }
      it { is_expected.to be_falsey }
    end
  end

  describe '#hide!' do
    before  { subject }
    subject { card.hide! }

    it { expect(card.is_hole).to be_truthy }
  end

  describe '#show!' do
    let(:card) { build :card, :hole }
    before  { subject }
    subject { card.show! }

    it { expect(card.is_hole).to be_falsey }
  end

  describe '#to_s' do
    before  { allow(card).to receive(:hole?).and_return is_hole }
    subject { card.to_s }

    context 'with hole card' do
      let(:is_hole) { true }
      it { is_expected.to eq 'Hole' }
    end

    context 'with normal card' do
      let(:is_hole) { false }
      let(:label)   { "#{card.rank} #{card.suit}" }
      it { is_expected.to eq label }
    end
  end
end
