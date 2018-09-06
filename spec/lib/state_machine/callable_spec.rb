require 'state_machine/callable'

RSpec.describe StateMachine::Callable do
  let(:target) { double('machine', run_test: true) }

  context 'when callable is lambda' do
    it 'calls lambda with object' do
      expect(target).to receive(:run_test)
      described_class.new(proc { |machine| machine.run_test }).call(target)
    end
  end

  context 'when callable is method' do
    it 'calls method on object' do
      expect(target).to receive(:run_test)
      described_class.new(:run_test).call(target)
    end
  end

  context 'when callable is nil' do
    it 'does returns nil' do
      expect(described_class.new(nil).call(target)).to be_nil
    end

    it 'does not crash' do
      expect {
        described_class.new(nil).call(target)
      }.not_to raise_error
    end
  end
end
