module StateMachine
  module HasCallbacks
    def build_callbacks(options)
      self.class::AVAILABLE_CALLBACKS.each_with_object({}) do |name, hash|
        callback = options[name] || options[name.to_s]
        next unless callback
        hash[name] = Callable.new(callback)
      end
    end

    def callback_for(type, prefix: nil)
      name = [type, prefix].compact.join('_').to_sym

      callbacks[name]
    end
  end
end
