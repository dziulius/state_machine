module StateMachine
  # Responsible for calling event on machine and checking if event can be ran.
  #  - checks if event can be run
  #  - runs before/after callbacks on states and transitions
  #  - sets new state if transition can be performed
  # :reek:MissingSafeMethod
  class MachineRunner
    def initialize(object, event_name)
      self.object = object
      self.transition = machine.find_transition(event_name, object.state)
    end

    def perform!
      raise UnknownTransitionError unless transition

      return false unless can_perform?

      run_callbacks do
        object.state = transition.to
      end
    end

    # :reek:NilCheck
    def can_perform?
      !transition.nil? && transition_can_run?
    end

    private

    def machine
      object.class.machine
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

    attr_accessor :object, :transition
  end
end
