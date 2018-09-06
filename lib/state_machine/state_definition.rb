require_relative 'has_callbacks'
require_relative 'callable'
require_relative 'state_definition/machine'
require_relative 'machine_runner'
require_relative 'errors'

module StateMachine
  module StateDefinition
    module ClassMethods
      def state(name, options = {})
        machine.add_state(name, options)
        define_state_methods(name)
      end

      def event(name, &block)
        machine.add_event(name, &block)
        define_event_methods(name)
      end

      def machine
        @machine ||= Machine.new
      end

      private

      def define_state_methods(name)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}?
            state.to_sym == :'#{name}'
          end
        RUBY
      end

      def define_event_methods(name)
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{name}!
            MachineRunner.new(self, :'#{name}').perform
          end

          def can_#{name}?
            MachineRunner.new(self, :'#{name}').can_perform?
          end
        RUBY
      end
    end

    module InstanceMethods
      attr_accessor :state

      def initialize(state = nil)
        self.state = self.class.machine.initial_state_from(state)
      end
    end
  end
end
