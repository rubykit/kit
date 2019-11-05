module Kit::Contract::Services
  module SignatureMatcher

    def self.get_parameters(callable: callable)
      if callable.is_a?(Proc) || callable.is_a?(Method)
        callable.parameters
      elsif callable.respond_to?(:call)
        callable.method(:call).parameters
      else
        # NOTE: not sure what this leaves ?
        raise "Unsupported callable"
      end
    end

    # Valid ordering is as follows: [:req, :opt], :rest, [:req, :opt], [:key, :keyreq], :keyrest, :block
    def self.generate_args_in(callable:, args:)
      parameters = get_parameters(callable: callable)
      payload    = []

      if parameters.last&.last == :block
        payload << args.pop
      end

      if parameters.last&.first&.in?([:key, :keyrest, :keyreq])
        keyargs_hash   = args.pop
        parameters_key = parameters
          .select { |el| el[0].in?([:key, :keyrest, :keyreq]) }

        parameters
          .delete_if { |el| el[0].in?([:key, :keyrest, :keyreq]) }

        payload.unshift(*handle_key_args(hash: keyargs_hash, parameters: parameters_key))
      end

      if parameters.size > 0
        payload.unshift(*handle_regular_args(args: args, parameters: parameters))
      end

      payload
    end

    # NOTE: this probabluy can be reused for the organizer ?
    def self.handle_key_args(hash:, parameters:)
      raise "Expected hash" if !hash.is_a?(::Hash)

      payload    = []
      keys       = hash.keys
      named_keys = parameters
        .map { |el| el[0].in?([:keyreq, :key]) ? el[1] : nil }
        .compact

      if named_keys.size > 0
        arg_available_keys = named_keys
          .select { |name| hash.has_key?(name) }

        payload << hash.slice(*arg_available_keys)
      end

      if parameters.last[0] == :keyrest
        rest_keys          = keys - named_keys
        arg_available_keys = rest_keys
          .select { |name| hash.has_key?(name) }

        payload << hash.slice(*arg_available_keys)
      end

      payload
    end

    def self.handle_regular_args(args:, parameters:)
      []
    end

  end
end