# Organizer passes the result of a callable to another callable (as long as the result is successfull).
# It is mostly useful when you need to execute a series of operations resembling a pipeline.
# You might alredy be familiar with some solutions that deal with this (Promises, Railway Programming, Pipe operators).
# `Kit::Organizer` is a flavor of functional interactor.
#
# ### Introduction
# Describing a list of operations often leads to code that is difficult to follow or nested requires a lot of nesting. For instance:
# ```ruby
# fire_user_created_event(persist_user(validate_password(validate_email({ email: email, password: password }))))
#
# # or
#
# valid_email?    = validate_email(email)
# valid_password? = validate_password(password)
# if valid_email? && valid_password?
#   user = persist_user(email: email, password: password)
#   if user
#     fire_user_created_event(user: user)
#   end
# end
# ```
#
# With `Organizer`, this is expressed as:
# ```ruby
# Kit::Organize::Services::Organize.call(
#   list: [
#     :validate_email,
#     :validate_password,
#     :persist_user,
#     :fire_user_created_event,
#   ],
#   ctx: {
#     email: '',
#     password: '',
#   },
# )
# ```
#
# #### Context
# An organizer uses a context. The context contains everything the set of operations need to work.
# When an operation is called, it can affect the context.
#
# #### Callable
# A callable is expected to return a result tupple of the following format:
# ```ruby
# [:ok] || [:ok, context_update] || [:error] || [:error, context_update]
# ```

module Kit::Organizer::Services::Organize
  include Kit::Contract
  Ct = Kit::Organizer::Contracts

  # Run a `list` of `operations` (callable) in order. Each results update the initial `ctx` which is then sent to the next operation.
  # An `operation` needs to be a callable, but it can be resolved from other format (see #to_callable)
  # Note: Every operation is expected to return a tupple of the format `[:ok]` or `[:error]` with an optional context update (`[:ok, { new_ctx_key: 'value' }]`, `[:errors, { errors: [{ detail: 'Error explaination' }], }]`). If an `:error` tupple is returned, the next operations are canceled and `call` will return.
  # @param list An array of operations (callables) that will be called in order
  # @param ctx A hash containing values to send to the operations (callables). It will be updated after every operation.
  # @param filter Allows to slice specific keys on the context
  # @return The updated context.
  #contract Ct::Hash[list: Ct::Operations, ctx: Ct::Optional[Ct::Hash], filter: Ct::Optional[Ct::Or[Ct::Hash[ok: Ct::Array], Ct::Hash[error: Ct::Array]]]] => Ct::ResultTupple
  def self.call(list:, ctx: {}, filter: nil)
    ctx    = ctx.dup
    status = :ok

    begin
      list
        .map { |el| to_callable(callable: el) }
        .each do |callable|
          local_ctx = generate_callable_ctx(callable: callable, ctx: ctx)

          _log("# Calling `#{callable}` with keys |#{local_ctx.keys}|", :yellow)

          result = callable.call(local_ctx)
          result = sanitize_errors(result: result)

          status, local_ctx = result

          _log("#   Result |#{status}|#{local_ctx}|", :blue)

          ctx = update_context(ctx: ctx, local_ctx: local_ctx)

          _log("#   Ctx keys post |#{ctx.keys}|", :yellow)
          _log("#   Errors |#{ctx[:errors]}|", :red) if ctx[:errors]
          _log("\n\n")

          if status == :error || status == :ok_stop
            break
          end
        end
    #rescue StandardException => e
    #  status = :error
    #  # Todo: use event bus to notify error handlers ?
    end

    # TODO: audit usefulness
    status = :ok if status == :ok_stop

    # TODO: audit usefulness
    if filter&.dig(status)
      ctx = ctx.slice(*filter[status])
    end

    [status, ctx]
  end

  # Sanitizes returned errors, if any.
  # @api private
  # @note Enable simpler error return format from an organized callable.
  # @example Returning an error as a string
  #    sanitize_result([:error, 'Error details']) => [:error, { errors: [{ detail: 'Error details' }] }]
  # @example Returning an error as hash with detail
  #    sanitize_result([:error, { detail: 'Error details' }]) => [:error, { errors: [{ detail: 'Error details' }] }]
  # @example Returning an array of errors in the two former formats
  #    sanitize_result([:error, ['Error1 detail', { detail: 'Error2 details' }]) => [:error, { errors: [{ detail: 'Error1 details' }, { detail: 'Error2 details' }] }]
  #contract Ct::Hash[result: Ct::ResultTupple] => Ct::ResultTupple
  def self.sanitize_errors(result:)
    status, ctx = result

    return result if status != :error

    if ctx.is_a?(String)
      ctx = { errors: [{ detail: ctx }] }
    elsif ctx.is_a?(Hash)
      if !ctx[:errors]
        if ctx[:detail]
          ctx = { errors: [ctx] }
        elsif ctx[:error]
          ctx = { errors: [ctx[:error]] }
        end
      end
    elsif ctx.is_a?(Array)
      ctx = { errors: ctx.map { |el| el.is_a?(String) ? { detail: el } : el } }
    end

    [status, ctx]
  end

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

  # Ensures every action is a callable.
  # @api private
  # @note Accepted format are `['Module', 'singleton_method_name']` or `:method_identifier` (in this case `Kit::Organizer::Store` is used to get the real callable)
  # @example Generating a callable from a tupple
  #    to_callable(callable: ['AuthenticationModule', 'sign_in']) => Proc(AuthenticationModule#sign_in)
  # @example Generating a callable from a tupple
  #    Kit::Organizer::Store.register(id: :login, target: AuthenticationModule.method(:sign_in)) => true
  #    to_callable(callable: :login) => Proc(AuthenticationModule#sign_in)
  #contract Ct::Hash[callable: Ct::Or[Ct::Callable, Ct::Symbol, Ct::Array.size(2)]] => Ct::Callable
  def self.to_callable(callable:)
    if callable.is_a?(Array)
      class_object, method_name = callable
      if class_object.is_a?(::String) || class_object.is_a?(::Symbol)
        class_object = class_object.to_s.constantize
      end
      callable = class_object.method(method_name.to_sym)
    elsif callable.is_a?(Symbol)
      callable = Kit::Organizer::Services::Store.get(id: callable)
    end

    callable
  end

  # Extract needed key from the organizer context to send them to the callable.
  # @api private
  # @note This id done by using introspection on the callable.
  # @example
  #    generate_callable_ctx(callable: ->(a:), { a: 1, b: 2, c: 3 }) => { a: 1 }
  #    generate_callable_ctx(callable: ->(a:, **), { a: 1, b: 2, c: 3 }) => { a: 1, b: 2, c: 3 }
  #contract Ct::Hash[callable: Ct::Callable, ctx: Ct::Hash] => Ct::Hash
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
      {}
    end
  end

  # Display debug information when `ENV['LOG_ORGANIZER']` is set
  # @api private
  def self._log(txt, color = nil)
    env_value = ENV['LOG_ORGANIZER']
    return if !env_value || env_value == ''

    if color
      txt = txt.colorize(color)
    end

    puts txt

    nil
  end

end