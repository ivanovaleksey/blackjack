# frozen_string_literal: true

describe Blackjack::Game do
  let(:game) { build :game }

  describe '#start' do
    let(:dealer) { double :dealer }
    let(:player) { double :player }

    before do
      allow(game).to receive(:dealer).and_return dealer
      allow(game).to receive(:define_player).and_yield player
      allow(dealer).to receive(:play_with)
    end
    after   { subject }
    subject { game.start }

    it { expect(game).to receive :say_greetings }
    it { expect(game).to receive :say_rules }
    it { expect(dealer).to receive(:play_with).with player }
  end
end
