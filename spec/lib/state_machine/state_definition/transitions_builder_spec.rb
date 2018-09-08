require 'state_machine/state_definition/transitions_builder'

RSpec.describe StateMachine::StateDefinition::TransitionsBuilder do
  let(:builder) do
    described_class.new
  end

  let(:transitions) do
    builder.build do
      transitions from: :walking, to: :standing
      transitions from: :running, to: :standing
    end
  end

  it 'builds all transitions' do
    expect(transitions.size).to eq(2)
  end

  it 'sets transition attributes' do
    expect(transitions.first.from).to eq(%i[walking])
    expect(transitions.first.to).to eq(:standing)
  end
end
