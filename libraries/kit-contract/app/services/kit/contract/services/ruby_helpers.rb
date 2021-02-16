# Helpers methods to manipulate function signatures.
# This should be part of the language in one form or another.
module Kit::Contract::Services::RubyHelpers

  # Attempt to generate a version of `args` that can be sent to `callable`
  #
  # @note a valid order looks like: `[:req, :opt], :rest, [:req, :opt], [:key, :keyreq], :keyrest, :block`
  def self.generate_args_in(callable:, args:)
    args       = args.dup
    parameters = get_parameters(callable: callable).dup

    payload    = {
      args:   [],
      kwargs: {},
      block:  nil,
    }

    if parameters.last&.last == :block
      payload[:block] = args.pop
      parameters.pop
    end

    kwargs_types = [:key, :keyrest, :keyreq]
    if parameters.last&.first&.in?(kwargs_types)
      keyargs_hash = args.pop

      parameters_kwargs = parameters.select { |type, _name| type.in?(kwargs_types) }

      # So that we can use the remaining
      parameters.delete_if { |el| el[0].in?(kwargs_types) }

      # If there is :keyreq, everything goes! Otherwise slice.
      has_keyreq = parameters_kwargs.any? { |type, _name| type == :keyrest }
      if !has_keyreq
        keyargs_hash = keyargs_hash.slice(*(parameters_kwargs.map { |_type, name| name }))
      end

      payload[:kwargs] = keyargs_hash
    end

    if parameters.size > 0
      payload[:args] = *args
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
