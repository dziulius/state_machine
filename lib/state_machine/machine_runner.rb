module StateMachine
  # Responsible for calling event on machine and checking if event can be ran.
  #  - checks if event can be run
  #  - runs before/after callbacks on states and transitions
  #  - sets new state if transition can be performed
  class MachineRunner
    def initialize(object, event_name)
      self.object = object
      self.event_name = event_name
      self.machine = object.class.machine
    end

    def perform
      validate_runnable
      return false unless transition_can_run?

      run_callbacks do
        object.update_state(transition.to)
      end
    end

    # :reek:NilCheck
    def can_perform?
      !transition.nil? && transition_can_run?
    end

    private

    def event
      @event ||= machine.events[event_name]
    end

    def transition
      @transition ||= event.find_transition(object.state) if event
    end

    def validate_runnable
      raise UnknownEventError unless event
      raise UnknownTransitionError unless transition
    end

    def transition_can_run?
      condition = transition.condition
      !condition || condition.call(object)
    end

    # :reek:DuplicateMethodCall
    def run_callbacks
      run_callback(machine.states[object.state], prefix: :leave) do
        run_callback(machine.states[transition.to], prefix: :enter) do
          run_callback(transition) do
            yield
          end
        end
      end
    end

    # :reek:NilCheck
    def run_callback(target, prefix: nil)
      target.callback_for(:before, prefix: prefix)&.call(object)
      yield
      target.callback_for(:after, prefix: prefix)&.call(object)
    end

    attr_accessor :object, :event_name, :machine
  end
end
