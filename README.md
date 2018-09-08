# StateMachine

This is a library for defining very simple state machines.

## Usage

To define a state machine first, include `StateMachine` to your class. Next step is defining states and events.

```ruby
class MovementState
  include StateMachine

  state :standing, initial: true
  state :walking
  state :running

  event :walk do
    transitions from: :standing, to: :walking
  end

  event :run do
    transitions from: [:standing, :walking], to: :running
  end

  event :hold do
    transitions from: [:walking, :running], to: :standing
  end
end

movement_state = MovementState.new(:standing)
movement_state.walk!
movement_state.walking? # => true
movement_state.hold! # => raise UnknownTransitionError
movement_state.can_hold? # => false
movement_state.standing? # => false
```

### Defining callbacks

#### State callbacks

Each state can have callbacks for entering or leaving the state. A callback can be a method name defined on your StateMachine or a proc accepting your state machine instance.

```ruby
class MovementState
  include StateMachine

  state :standing, initial: true
  state :walking, before_enter: :before_walking_callback, after_leave: ->(movement_state) { movement_state.after_stop_walking }
  state :running, after_enter: :after_started_running

  def before_walking_callback
    # do something
  end

  def after_stop_walking
    # do something elese
  end

  def after_started_running
    # do stuff
  end
end
```

Available callbacks: `before_enter`, `after_enter`, `before_leave`, `after_leave`

#### Transition callbacks

Transitions support before and after callbacks. A callback can be a method name defined on your StateMachine or a proc accepting your state machine instance.

```ruby
class MovementState
  include StateMachine

  state :standing, initial: true
  state :walking

  event :walk do
    transitions from: :standing, to: :walking, before: :before_start_walking
  end

  event :hold do
    transitions from: :walking, to: :standing, before: :before_stop_walking, after: ->(movement_state) { movement_state.after_stop_walking }
  end

  def before_start_walking
    # do something
  end

  def before_stop_walking
    # do something else
  end

  def after_stop_walking
    # do something more
  end
end
```

#### Callbacks order

Callbacks are called in following order:
* state `before_leave`
* state `before_enter`
* transition `before`
* updates state
* transition `after`
* state `after_enter`
* state `after_leave`

### Transition conditions

A condition can be defined on a transition to check if it can be run. A condition can be a method or a proc.

```ruby
class MovementState
  include StateMachine

  state :standing, initial: true
  state :walking

  event :walk do
    transitions from: :standing, to: :walking, when: :not_sleeping?
  end

  event :hold do
    transitions from: :walking, to: :standing, when: ->(movement_state) { |movement_state| movement_state.walked_kilometer? }
  end

  def not_sleeping?
    true
  end

  def walked_kilometer?
    # do some calculations
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dziulius/state_machine.
