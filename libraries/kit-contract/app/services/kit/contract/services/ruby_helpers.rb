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

  # Given `parameters` of a callable, generate a function signature able to receive these parameters seamlessly.
  #
  # @note Default values are not available, so they are lost. Kudos to Ruby.
  def self.parameters_to_string_signature(parameters:)
    parameters
      .map do |type, name|
        case type
        when :req
          name
        when :rest
          "*#{ name || '_KC_REST' }"
        when :opt
          # Unknown default argument.
          "#{ name } = nil"
        when :key
          # Unknown default argument.
          "#{ name }: nil"
        when :keyreq
          "#{ name }:"
        when :keyrest
          "**#{ name || '_KC_KEYREST' }"
        when :block # NOTE: name can not be nil for block
          "&#{ name }"
        end
      end
      .join(', ')

  end

  # Given `parameters` of a callable, attempt to capture them in a standard hash.
  # This is used for some evaled metaprogramming (to capture & forward parameters properly).
  #
  # This is a poor man Ruby equivalent of JS `arguments`.
  #
  # ### Unammed arguments
  #
  # [:rest] && [:keyrest] can't be handled (when missing the name as a second arg)
  #
  # ### References
  #
  # - https://www.ruby-lang.org/en/news/2019/12/12/separation-of-positional-and-keyword-arguments-in-ruby-3-0/
  # - https://ruby-doc.org/core-3.0.0/Method.html#method-i-parameters
  def self.parameters_to_string_arguments(parameters:)
    block   = (parameters.last&.first == :block)   ?  parameters.pop[1]                   : nil
    keyrest = (parameters.last&.first == :keyrest) ? (parameters.pop[1] || '_KC_KEYREST') : nil

    named   = parameters.filter_map do |type,  name|
      if type == :req || type == :opt
        name
      elsif type == :rest
        "*#{ name || '_KC_REST' }"
      end
    end

    keyargs = parameters.select { |type, _name| type == :key || type == :keyreq }

    # Generate string

    str = '{ '

    if named.size > 0
      str << "named: [#{ named.join(', ') }], "
    end

    if keyargs.size > 0 || keyrest
       str << "keyargs: { #{ keyargs.map { |_type, name| "#{ name }: #{ name }" }.join(', ') } }"
       str << ".merge(#{ keyrest })" if keyrest
       str << ', '
    end

    if block
      str << "block: #{ block }, "
    end

    str << '}'

    str
  end

end
