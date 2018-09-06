require 'state_machine/state_definition'
require 'support/basic_machine'

RSpec.describe StateMachine::StateDefinition do
  let(:machine) { BasicMachine.new }

  it 'defines perform event method' do
    expect(machine).to respond_to(:walk!)
  end

  it 'defines can perform event method' do
    expect(machine).to respond_to(:can_walk?)
  end

  it 'defines test state method' do
    expect(machine).to respond_to(:walking?)
  end

  it 'sets default state' do
    expect(machine).to be_standing
  end
end
