require_relative 'event'
require_relative 'state'

module StateMachine
  module StateDefinition
    class Machine
      attr_reader :states, :events, :initial_state

      def initialize
        self.states = {}
        self.events = {}
      end

      def initial_state_from(state)
        return nil if states.empty?
        return state if state && states.key?(state.to_sym)

        initial_state 
      end

      def add_state(name, initial: false, **options)
        state = State.new(name, options)
        states[state.name] = state

        self.initial_state = state.name if initial
      end

      def add_event(name, &block)
        event = Event.new(name, &block)
        events[event.name] = event
      end

      private

      attr_writer :states, :events, :initial_state
    end
  end
end
