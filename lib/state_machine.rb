require 'state_machine/version'
require 'state_machine/state_definition'

module StateMachine
  def self.included(klass)
    klass.extend(StateDefinition::ClassMethods)
    klass.include(StateDefinition::InstanceMethods)
  end
end
