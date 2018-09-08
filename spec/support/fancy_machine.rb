# Advaced state machine example with lots of callbacks
class FancyMachine
  include StateMachine

  state :standing, initial: true
  state :walking,
        before_leave: :before_leave_walking, after_leave: :after_leave_walking,
        before_enter: ->(machine) { machine.before_enter_walking }, after_enter: :after_enter_walking
  state :running, before_enter: :before_enter_running, after_enter: ->(machine) { machine.after_enter_running }

  event :walk do
    transitions from: :standing, to: :walking, when: :walking_allowed?
  end

  event :run do
    transitions from: %i[standing walking], to: :running, after: :start_running
  end

  event :hold do
    transitions from: :walking, to: :standing, before: ->(machine) { machine.before_walking_stop }
    transitions from: :running, to: :standing, after: :stopped_running
  end

  def before_walking_stop
  end

  def stopped_running
  end

  def start_running
  end

  def before_enter_walking
  end

  def before_leave_walking
  end

  def after_leave_walking
  end

  def after_enter_walking
  end

  def before_enter_running
  end

  def after_enter_running
  end

  def walking_allowed?
    true
  end
end
