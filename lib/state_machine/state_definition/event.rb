require_relative 'transition'

module StateMachine
  module StateDefinition
    # Parses and contains transisions available on event
    class Event
      attr_reader :name

      def initialize(name, &block)
        self.name = name.to_sym
        self.available_transitions = []

        instance_eval(&block)
      end

      def find_transition(state)
        available_transitions.detect { |transition| transition.from?(state) }
      end

      def validate(states)
        return true if available_transitions.all? { |transition| transition.valid?(states) }

        raise UndefinedStateError
      end

      private

      attr_writer :name
      attr_accessor :available_transitions

      def transitions(options)
        transition = Transition.new(options)

        available_transitions.push(transition)
      end
    end
  end
end
