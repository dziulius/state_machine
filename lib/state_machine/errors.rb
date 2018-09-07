module StateMachine
  class UnknownTransitionError < StandardError; end
  class UnknownEventError < StandardError; end
  class UndefinedStateError < StandardError; end
  class DuplicatedInitialStateError < StandardError; end
end
