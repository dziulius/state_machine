module StateMachine
  # Error raised when transition unavailable
  class UnknownTransitionError < StandardError; end
  # Error raised when event cannot be found
  class UnknownEventError < StandardError; end
  # Error raised when event cannot be called on current state
  class UndefinedStateError < StandardError; end
  # Error raised when trying to define second initial state
  class DuplicatedInitialStateError < StandardError; end
end
