module Kit::Store::Contracts

  # Ensures that the object is a Callable that can receive specific keyword arguments
  class CallableWithHash < InstantiableContract

    def initialize(*expected_key_names)
      @expected_key_names = expected_key_names
    end

    def call(arg)
      if !arg.respond_to?(:call)
        return [:error, 'CALLABLE_WITH_HASH failed: object does not respond_to `call`']
      end

      parameters = Kit::Contract::Services::RubyHelpers.get_parameters(callable: arg)

      if parameters.any? { |el| (el[0] == :keyrest) }
        return [:ok]
      end

      key_names = parameters
        .map  { |el| el[0].in?([:key, :keyreq]) ? el[1] : nil }
        .compact

      remaining_keys = @expected_key_names - key_names
      if !remaining_keys.empty?
        return [:error, "CALLABLE_WITH_HASH failed: callable does not accept the following keys: `#{ remaining_keys }`"]
      end

      return [:ok]
    end

  end

end
