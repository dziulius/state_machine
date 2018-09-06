require 'state_machine/machine_runner'

RSpec.describe StateMachine::MachineRunner do
  let(:machine) { ValidMachine.new }

  describe '#can_perform' do
    context 'when transition available' do
      it 'returns true' do
        expect(described_class.new(machine, :walk).can_perform?).to eq(true)
      end

      context 'when precondition not met' do
        it 'returns false' do
          allow(machine).to receive(:walking_allowed?).and_return(false)
          expect(described_class.new(machine, :walk).can_perform?).to eq(false)
        end
      end
    end

    context 'when transition unavailable' do
      it 'returns false' do
        expect(described_class.new(machine, :hold).can_perform?).to eq(false)
      end
    end
  end

  describe '#perform' do
    context 'running callbacks' do
      it 'keeps callbacks order' do
        machine.walk!

        expect(machine).to receive(:before_leave_walking).ordered
        expect(machine).to receive(:before_enter_running).ordered
        expect(machine).to receive(:start_running).ordered
        expect(machine).to receive(:after_enter_running).ordered
        expect(machine).to receive(:after_leave_walking).ordered

        described_class.new(machine, :run).perform
      end
    end

    it 'sets new state' do
      expect {
        described_class.new(machine, :run).perform
      }.to change { machine.state }.to(:running)
    end

    context 'when precondition not met' do
      before { allow(machine).to receive(:walking_allowed?).and_return(false) }

      it 'returns false' do
        expect(described_class.new(machine, :walk).perform).to eq(false)
      end

      it 'does not change state' do
        expect {
          described_class.new(machine, :walk).perform
        }.not_to change { machine.state }
      end
    end

    context 'when event unavailable' do
      it 'raises error' do
        expect {
          described_class.new(machine, :some_event).perform
        }.to raise_error(StateMachine::UnknownEventError)
      end
    end

    context 'when event unavailable' do
      it 'raises error' do
        expect {
          described_class.new(machine, :hold).perform
        }.to raise_error(StateMachine::UnknownTransitionError)
      end
    end
  end
end
