module Kit::Organizer::Services::Context
  include Kit::Contract
  Ct = Kit::Organizer::Contracts

  # Performs a 1 level deep merge on the organizer context.
  # @api private
  # @note The content of the `:errors` key is merged manually.
  def self.update_context(ctx:, local_ctx:)
    local_ctx ||= {}
    ctx_errors  = ctx[:errors]

    # NOTE: should we just do a deep merge?
    ctx = ctx.merge(local_ctx)

    if ctx_errors
      ctx[:errors] = ctx_errors + (local_ctx[:errors] || [])
    end

    ctx
  end

  # Extract needed key from the organizer context to send them to the callable.
  # @api private
  # @note This id done by using introspection on the callable.
  # @example
  #    generate_callable_ctx(callable: ->(a:), { a: 1, b: 2, c: 3 }) => { a: 1 }
  #    generate_callable_ctx(callable: ->(a:, **), { a: 1, b: 2, c: 3 }) => { a: 1, b: 2, c: 3 }
  contract Ct::Hash[callable: Ct::Callable, ctx: Ct::Hash] => Ct::Or[Ct::Hash, Ct::Eq[nil]]
  def self.generate_callable_ctx(callable:, ctx:)
    parameters = Kit::Contract::Services::RubyHelpers.get_parameters(callable: callable)
    by_type    = parameters.group_by { |el| el[0] }

    if (by_type.keys - [:keyreq, :key, :keyrest]).size > 0
      raise Kit::Organizer::Error.new("Unsupported parameter type in organized callable")
    end

    if by_type[:keyrest]
      ctx.dup
    elsif by_type[:keyreq] || by_type[:key]
      keys = ((by_type[:keyreq] || []).map { |el| el[1] }) + ((by_type[:key] || []).map { |el| el[1] })
      ctx.slice(*keys)
    else
      nil
    end
  end

end