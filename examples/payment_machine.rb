class PaymentMachine
  include StateMachine

  state :pending, initial: :true
  state :confirmed
  state :paid, after_enter: :notify_success
  state :cancelled, after_enter: :abort_payment

  event :confirm do
    transitions from: :pending, to: :confirmed
  end

  event :cancel do
    transitions from: :pending, to: :cancelled
  end

  event :complete do
    transitions from: :confirmed, to: :paid
  end

  def passed_fraud_check?
    true
  end

  def notify_success
    PaymentMailer.success(payment: self).deliver_later
  end

  def abort_payment
    AbortPayment.call(payment: self)
  end
end
