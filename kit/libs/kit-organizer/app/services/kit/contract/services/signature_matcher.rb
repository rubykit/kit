module Kit::Contract::Services::SignatureMatcher

  # NOTE: a valid order looks like:
  #   [:req, :opt], :rest, [:req, :opt], [:key, :keyreq], :keyrest, :block
  def self.generate_args_in(callable:, args:)
    args       = args.dup
    parameters = get_parameters(callable: callable).dup
    payload    = []

    if parameters.last&.last == :block
      parameters.pop
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
      #payload.unshift(*handle_regular_args(args: args, parameters: parameters))

      payload.unshift(*args)
    end

    payload
  end

  def self.get_parameters(callable:)
    if callable.is_a?(Proc) || callable.is_a?(Method)
      callable.parameters
    elsif callable.respond_to?(:call)
      callable.method(:call).parameters
    else
      # NOTE: not sure what this leaves ?
      raise "Unsupported callable"
    end
  end

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

      if arg_available_keys.size > 0
        payload << hash.slice(*arg_available_keys)
      end
    end

    payload
  end

=begin
  def self.handle_regular_args(args:, parameters:)
    payload     = []
    payload_end = []

    # Start left, if we find `rest`, pause, start right, assign whatever is left
    while parameters.size > 0
      type, name = parameters.first

      if type == :req || type == :opt
        parameters.shift
        payload << args.shift
      elsif type == :rest
        parameters.shift
        while parameters.size > 0
          type, name = parameters.last

          if type == :req || type == :opt
            payload_end.unshift args.pop
            parameters.pop
          end
        end

        payload << args
        payload.concat(payload_end)
      else
        "Unsupported parameter type `#{type}` (named `#{name}`)"
      end
    end

    payload
  end
=end

end