module StateMachine
  module StateDefinition
    class State
      include HasCallbacks

      AVAILABLE_CALLBACKS = %i[before_enter before_leave after_enter after_leave].freeze

      attr_reader :name, :callbacks

      def initialize(name, options)
        self.name = name.to_sym
        self.callbacks = build_callbacks(options)
      end

      private

      attr_writer :name, :callbacks
    end
  end
end
