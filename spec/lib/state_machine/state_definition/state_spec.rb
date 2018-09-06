require 'state_machine/state_definition/machine'

RSpec.describe StateMachine::StateDefinition::State do
  let(:state) do
    described_class.new(
      :running,
      before_enter: :entering,
      before_leave: :leaving,
      after_leave: :left,
      wrong_callback: :do_something
    )
  end

  it 'sets name' do
    expect(state.name).to eq(:running)
  end

  it 'sets given callbacks' do
    expect(state.callbacks).to match(
      after_leave: instance_of(StateMachine::Callable),
      before_enter: instance_of(StateMachine::Callable),
      before_leave: instance_of(StateMachine::Callable)
    )
  end
end
