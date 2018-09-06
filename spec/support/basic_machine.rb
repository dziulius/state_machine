class BasicMachine
  include StateMachine

  state :standing, initial: true
  state :walking

  event :walk do
    transitions from: :standing, to: :walking
  end

  event :stop do
    transitions from: :waking, to: :standing
  end
end
