describe Blackjack::Game do
  let(:game) { described_class.new }

  describe '#foo' do
    subject { game.foo }
    it { is_expected.to eq 'bar' }
  end
end
