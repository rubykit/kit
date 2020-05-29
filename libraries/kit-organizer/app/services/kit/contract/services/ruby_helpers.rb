# Helpers methods to manipulate function signatures.
# This should be part of the language in one form or another.
module Kit::Contract::Services::RubyHelpers

=begin
  # Given a `callable`, check if it can receive `args` as a payload
  def self.can_receive?(callable:, signature:)
  end
=end

  # Given a `callable`, attempt to transform `args` to make it compatible with the signature
  # @note a valid order looks like: `[:req, :opt], :rest, [:req, :opt], [:key, :keyreq], :keyrest, :block`
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

  # Given a `callable`, get its `parameters` data
  def self.get_parameters(callable:)
    if callable.is_a?(Proc) || callable.is_a?(Method)
      callable.parameters
    elsif callable.respond_to?(:call)
      callable.method(:call).parameters
    else
      # NOTE: not sure what this leaves ?
      # binding.pry
      raise "Unsupported callable #{ callable.class } `#{ callable }`"
    end
  end

  # Given a `hash` and some callable `parameters`, attempts to generate a compatible version of that `hash`.
  def self.handle_key_args(hash:, parameters:)
    raise 'Expected hash' if !hash.is_a?(::Hash)

    payload    = []
    keys       = hash.keys
    named_keys = parameters
      .map { |el| el[0].in?([:keyreq, :key]) ? el[1] : nil }
      .compact

    if named_keys.size > 0
      arg_available_keys = named_keys
        .select { |name| hash.key?(name) }

      payload << hash.slice(*arg_available_keys)
    end

    if parameters.last[0] == :keyrest
      rest_keys          = keys - named_keys
      arg_available_keys = rest_keys
        .select { |name| hash.key?(name) }

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

  # Given some callable `parameters`, generate the a callable definition
  # @note Default values are not available, so they are lost. Kudos to Ruby.
  def self.parameters_as_signature_to_s(parameters:)
    signature = parameters
      .map do |type, name|
        case type
        when :req
          name
        when :rest
          "*#{ name || '_kc_rest' }"
        when :opt
          # Unknown default argument.
          "#{ name } = nil"
        when :key
          # Unknown default argument.
          "#{ name }: nil"
        when :keyreq
          "#{ name }:"
        when :keyrest
          "**#{ name || '_kc_keyrest' }"
        when :block # NOTE: name can not be nil for block
          "&#{ name }"
        end
      end
      .join(', ')

    signature
  end

  # Given some callable `parameters`, attempt to generate the array we would have gotten when using a single splat.
  # @note This is a poor man Ruby equivalent of javascript `arguments`
  def self.parameters_as_array_to_s(parameters:)
    block_name   = (parameters.last&.first == :block)   ? parameters.pop[1] : nil
    keyrest_name = (parameters.last&.first == :keyrest) ? (parameters.pop[1] || '_kc_keyrest') : nil

    named_str = nil
    keys_str  = nil

    named = parameters
      .map do |type, name|
        if type == :req || name == :opt
          "#{ name }"
        elsif type == :rest
          "#{ name || '_kc_rest' }"
        else
          nil
        end
      end
      .compact

    if named.count > 0
      named_str = named.join(', ')
    end

    keys = parameters
      .select { |t, _n| t == :key || t == :keyreq }
      .map    { |_t, n| "#{ n }: #{ n }" }

    if keys.count > 0
      keys_str = "{ #{ keys.join(', ') } }"
    end

    if keyrest_name
      if keys_str
        keys_str = "#{ keys_str }.merge(#{ keyrest_name })"
      else
        keys_str = keyrest_name
      end
    end

    "[#{ named_str ? "#{ named_str }, " : '' }#{ keys_str ? "#{ keys_str }, " : '' }#{ block_name }]"
  end

end
