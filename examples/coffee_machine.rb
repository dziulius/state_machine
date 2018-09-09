class CoffeeMachine
  include StateMachine

  MAKING_DURATION = 5

  state :waiting_order, initial: true
  state :making_order
  state :delivering_order

  event :order do
    transitions from: :waiting_order, to: :making_order, when: :has_beens?, after: :start_making
  end

  event :make_coffee do
    transitions from: :making_order, to: :delivering_order, when: :order_complete?
  end

  event :deliver do
    transitions from: :delivering_order, to: :waiting_order, after: :order_delivered
  end

  def initialize(*args)
    super
    self.stock = 10
  end

  def has_beens?
    stock > 0
  end

  def start_making
    self.started_at = Time.now
    self.stock = stock - 1
  end

  def order_complete?
    started_at + MAKING_DURATION < Time.now
  end

  def order_delivered
    self.started_at = nil
  end

  protected

  attr_accessor :stock, :started_at
end
