describe Blackjack::Game do
  let(:game) { described_class.new }

  describe '#start' do
    subject { game.start }
    after   { subject }

    it { expect(game).to receive :say_greetings }
    it { expect(game).to receive :say_rules }
  end

  describe '#dealer' do
    subject { game.send :dealer }
    it 'should create new dealer' do
      expect(Blackjack::Dealer).to receive :new
      subject
    end
  end

  describe '#player' do
    subject { game.send :player }
    it 'should create new player' do
      expect(Blackjack::Player).to receive :new
      subject
    end
  end

end
