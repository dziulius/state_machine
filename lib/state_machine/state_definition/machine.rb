require_relative 'event'
require_relative 'state'

module StateMachine
  module StateDefinition
    # Main state definition class. Stores events, states and initial state
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

      #:reek:BooleanParameter :reek:ControlParameter
      def add_state(name, initial: false, **options)
        state = State.new(name, options)
        states[state.name] = state

        assign_initial_state(state) if initial
      end

      def add_event(name, &block)
        event = Event.new(name, &block)
        event.validate(states)
        events[event.name] = event
      end

      private

      def assign_initial_state(state)
        raise DuplicatedInitialStateError if initial_state

        self.initial_state = state.name
      end

      attr_writer :states, :events, :initial_state
    end
  end
end
