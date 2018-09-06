require 'state_machine/state_definition/transition'

RSpec.describe StateMachine::StateDefinition::Transition do
  let(:transition) do
    described_class.new(from: :running, to: :passing, when: :success?, before: :test, after: :print)
  end

  context 'states' do
    it 'sets source state' do
      expect(transition.from).to eq(%i[running])
    end

    it 'sets target state' do
      expect(transition.to).to eq(:passing)
    end
  end

  describe '#from?' do
    it 'returns true when source state matches' do
      expect(transition).to be_from(:running)
    end

    it 'returns false when source does not match state' do
      expect(transition).not_to be_from(:failing)
    end

    context 'when source is array' do
      let(:transition) do
        described_class.new(from: %i[running failing], to: :passing, when: :success?, before: :test, after: :print)
      end

      it 'returns true when source state matches' do
        expect(transition).to be_from(:running)
      end

      it 'returns false when source does not match state' do
        expect(transition).not_to be_from(:starting)
      end
    end
  end

  context 'condition' do
    it 'sets condition' do
      expect(transition.condition).to be_instance_of(StateMachine::Callable)
    end
  end

  context 'callbacks' do
    it 'sets callbacks' do
      expect(transition.callbacks).to match(
        before: instance_of(StateMachine::Callable),
        after: instance_of(StateMachine::Callable)
        )
    end
  end
end
