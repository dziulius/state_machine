require 'state_machine'
require 'support/fancy_machine'

RSpec.describe StateMachine do
  context 'when machine is valid' do
    let(:machine) { FancyMachine.new }

    context 'when default state passed' do
      it 'uses given state' do
        expect(FancyMachine.new(:running)).to be_running
      end
    end

    context 'when no state passed' do
      it 'uses initial state' do
        expect(FancyMachine.new).to be_standing
      end
    end

    context 'calling events' do
      it 'changes state' do
        expect {
          machine.run!
        }.to change { machine.running? }.to(true)
      end

      it 'calls event callbacks' do
        expect(machine).to receive(:start_running)
        machine.run!
      end

      it 'calls state callbacks' do
        expect(machine).to receive(:before_enter_running)
        machine.run!
      end

      context 'when transition unavailable' do
        it 'raises error' do
          expect {
            machine.hold!
          }.to raise_error(StateMachine::UnknownTransitionError)
        end
      end
    end
  end
end
