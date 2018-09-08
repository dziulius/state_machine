module StateMachine
  module StateDefinition
    # Builds transition objects from DSL
    class TransitionsBuilder
      def build(&block)
        self.transitions_list = []
        instance_eval(&block)
        transitions_list
      end

      private

      attr_accessor :transitions_list

      def transitions(**options)
        transition = Transition.new(options)

        transitions_list.push(transition)
      end
    end
  end
end
