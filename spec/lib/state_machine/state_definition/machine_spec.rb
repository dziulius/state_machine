require 'state_machine/state_definition/machine'

RSpec.describe StateMachine::StateDefinition::Machine do
  let(:machine) { described_class.new }
  let(:add_waiting_state) { machine.add_state :waiting, initial: true }
  let(:add_running_state) { machine.add_state :running }
  let(:add_run_event) { machine.add_event(:run) { transitions from: :waiting, to: :running } }

  describe '#initial_state_from' do
    context 'when empty' do
      it 'returns nil for any given state' do
        expect(machine.initial_state_from(:passing)).to be_nil
      end

      it 'returns nil for empty given state' do
        expect(machine.initial_state_from(nil)).to be_nil
      end
    end

    context 'when no initial state defined' do
      before { add_running_state }

      it 'returns nil for for empty given state' do
        expect(machine.initial_state_from(nil)).to be_nil
      end

      it 'returns nil for state outside states list' do
        expect(machine.initial_state_from(:testing)).to be_nil
      end

      it 'returns given state for state inside states list' do
        expect(machine.initial_state_from(:running)).to eq(:running)
      end
    end

    context 'when initial state defined' do
      before do
        add_waiting_state
        add_running_state
      end

      it 'returns initial state for for empty given state' do
        expect(machine.initial_state_from(nil)).to eq(:waiting)
      end

      it 'returns nil for state outside states list' do
        expect(machine.initial_state_from(:testing)).to eq(:waiting)
      end

      it 'returns given state for state inside states list' do
        expect(machine.initial_state_from(:running)).to eq(:running)
      end
    end
  end

  describe '#add_event' do
    it 'adds event' do
      add_waiting_state
      add_running_state

      expect(StateMachine::StateDefinition::Event).to receive(:new).with(:run).and_call_original
      add_run_event
    end

    context 'validating' do
      context 'when missing states' do
        it 'raises error' do
          expect {
            add_run_event
          }.to raise_error(StateMachine::UndefinedStateError)
        end
      end

      context 'when states valid' do
        it 'raises error' do
          add_waiting_state
          add_running_state

          expect {
            add_run_event
          }.not_to raise_error
        end
      end
    end
  end

  describe '#add_state' do
    it 'add state' do
      expect(StateMachine::StateDefinition::State).to receive(:new).with(:waiting, {}).and_call_original
      add_waiting_state
    end

    context 'when state is marked as initial' do
      it 'sets initial state' do
        add_waiting_state
        expect(machine.initial_state_from(nil)).to eq(:waiting)
      end
    end

    context 'when duplicate initial state' do
      it 'raises error' do
        add_waiting_state

        expect {
          machine.add_state :running, initial: true
        }.to raise_error(StateMachine::DuplicatedInitialStateError)
      end
    end

    context 'when state not marked as initial' do
      it 'does not set initial state' do
        add_running_state
        expect(machine.initial_state_from(nil)).to be_nil
      end
    end
  end

  describe '#find_transition' do
    before do
      add_waiting_state
      add_running_state
      add_run_event
    end

    context 'when event not found' do
      it 'raises error' do
        expect {
          machine.find_transition(:hold, :running)
        }.to raise_error(StateMachine::UnknownEventError)
      end
    end

    context 'when transition not found' do
      it 'returns nil' do
        expect(machine.find_transition(:run, :walking)).to be_nil
      end
    end

    context 'when transition found' do
      it 'returns transition' do
        expect(machine.find_transition(:run, :waiting).to).to eq(:running)
      end
    end
  end
end
