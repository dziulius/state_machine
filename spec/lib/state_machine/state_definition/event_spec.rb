require 'state_machine/state_definition/event'

RSpec.describe StateMachine::StateDefinition::Event do
  let(:event) do
    described_class.new('test_event') { transitions from: :running, to: :passing }
  end

  context 'parsing transitions' do
    it 'creates new transition instance' do
      expect(StateMachine::StateDefinition::Transition)
        .to receive(:new).with(from: :running, to: :passing).and_call_original

      event
    end
  end

  describe '#find_transition' do
    let(:event) do
      described_class.new(:test_event) do
        transitions from: :running, to: :passing
        transitions from: :failing, to: :passing
      end
    end

    it 'returns transition for given state' do
      expect(event.find_transition(:running)).to be_instance_of(StateMachine::StateDefinition::Transition)
    end

    it 'returns correct transition for given state' do
      expect(event.find_transition(:running).from).to eq(%i[running])
    end
  end

  describe '#name' do
    it 'returns name' do
      expect(event.name).to eq(:test_event)
    end
  end

  describe '#validate' do
    let(:running_state) { StateMachine::StateDefinition::State.new(:running, {}) }
    let(:passing_state) { StateMachine::StateDefinition::State.new(:passing, {}) }
    let(:failing_state) { StateMachine::StateDefinition::State.new(:failing, {}) }

    let(:event) do
      described_class.new(:pass) do
        transitions from: :failing, to: :passing
        transitions from: :running, to: :passing
      end
    end

    context 'when all transitions are valid' do
      it 'returns true' do
        states = { running: running_state, passing: passing_state, failing: failing_state }

        expect(event.validate(states)).to eq(true)
      end
    end

    context 'when one of transitions is invalid' do
      it 'raises error' do
        expect {
          event.validate(running: running_state)
        }.to raise_error(StateMachine::UndefinedStateError)
      end
    end
  end
end
