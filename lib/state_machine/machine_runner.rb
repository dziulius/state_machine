module StateMachine
  class MachineRunner
    def initialize(object, event_name)
      self.object = object
      self.event_name = event_name
      self.machine = object.class.machine
    end

    def perform
      validate_runnable
      return false unless transition_can_run?

      run_callbacks(machine.states[object.state], prefix: :leave) do
        run_callbacks(machine.states[transition.to], prefix: :enter) do
          run_callbacks(transition) do
            object.state = transition.to
          end
        end
      end
    end

    def can_perform?
      transition != nil && transition_can_run?
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

    def run_callbacks(target, prefix: nil)
      target.callback_for(:before, prefix: prefix)&.call(object)
      yield
      target.callback_for(:after, prefix: prefix)&.call(object)
    end

    attr_accessor :object, :event_name, :machine
  end
end
