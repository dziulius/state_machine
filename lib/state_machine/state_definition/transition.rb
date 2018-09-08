module StateMachine
  module StateDefinition
    # Stores information about transition: from and to states, callbacks, guard clause
    class Transition
      include HasCallbacks

      AVAILABLE_CALLBACKS = %i[before after].freeze

      attr_reader :callbacks, :to, :from, :condition

      # :reek:DuplicateMethodCall
      def initialize(from:, to:, **options)
        self.from = Array(from).map(&:to_sym)
        self.to = to.to_sym
        self.condition = Callable.new(options[:when]) if options[:when]
        self.callbacks = build_callbacks(options)
      end

      def from?(state)
        from.include?(state)
      end

      def validate(states)
        [to].concat(from).each do |state|
          raise UndefinedStateError, "Missing state: #{state}" unless states.key?(state)
        end

        true
      end

      private

      attr_writer :to, :callbacks, :condition, :from
    end
  end
end
