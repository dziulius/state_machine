require_relative 'transition'
require_relative 'transitions_builder'

module StateMachine
  module StateDefinition
    # Parses and contains transitions available on event
    class Event
      attr_reader :name, :transitions

      def initialize(name, &block)
        self.name = name.to_sym
        self.transitions = TransitionsBuilder.new.build(&block)
      end

      def find_transition(state)
        transitions.detect { |transition| transition.from?(state) }
      end

      def validate(states)
        transitions.each { |transition| transition.validate(states) }

        true
      end

      private

      attr_writer :name, :transitions
    end
  end
end
