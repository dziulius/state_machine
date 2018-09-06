module StateMachine
  class Callable
    def initialize(lambda_or_method)
      self.lambda_or_method = lambda_or_method
    end

    def call(object)
      return unless lambda_or_method

      if lambda_or_method.respond_to?(:call)
        lambda_or_method.call(object)
      else
        object.send(lambda_or_method)
      end
    end

    private

    attr_accessor :lambda_or_method
  end
end
