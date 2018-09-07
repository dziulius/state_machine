module StateMachine
  module StateDefinition
    class Transition
      include HasCallbacks

      AVAILABLE_CALLBACKS = %i[before after].freeze

      attr_reader :callbacks, :to, :from, :condition

      def initialize(from:, to:, **options)
        self.from = Array(from).map(&:to_sym)
        self.to = to
        self.condition = Callable.new(options[:when]) if options[:when]
        self.callbacks = build_callbacks(options)
      end

      def from?(state)
        from.include?(state)
      end

      def valid?(states)
        states.key?(to) && from.all? { |state| states.key?(state) }
      end

      private

      attr_writer :to, :callbacks, :condition, :from
    end
  end
end
