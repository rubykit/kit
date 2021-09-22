# Organizer passes the result of a callable to another callable (as long as the result is successfull).
#
# It is mostly useful when you need to execute a series of operations ressembling a pipeline.
#
# You might alredy be familiar with some solutions that deal with this (Promises, Railway Programming, Pipe operators):
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
#     [:alias, :validate_email],
#     [:alias, :validate_password],
#     [:alias, :persist_user],
#     [:alias, :fire_user_created_event],
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
# [:ok] || [:ok, context_update] || [:halt] || [:halt, context_update] || [:error] || [:error, context_update]
# ```
module Kit::Organizer::Services::Organize

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  # Run a `list` of `operations` (callable) in order.
  #
  # Each results update the initial `ctx` which is then sent to the next operation.
  #
  # An `operation` needs to be a callable, but it can be resolved from other format (see `#to_callable`)
  #
  # NOTE: Every operation is expected to return a tupple of the format `[:ok]` or `[:error]` with an optional context update (`[:ok, { new_ctx_key: 'value' }]`, `[:errors, { errors: [{ detail: 'Error explaination' }], }]`). If an `:error` tupple is returned, the next operations are canceled and `call` will return.
  #
  # @param list An array of operations (callables) that will be called in order
  # @param ctx A hash containing values to send to the operations (callables). It will be updated after every operation.
  # @param filter Allows to slice specific keys on the context
  # @return The updated context.
  # contract Ct::Hash[list: Ct::Operations, ctx: Ct::Optional[Ct::Hash], filter: Ct::Optional[Ct::Or[Ct::Hash[ok: Ct::Array], Ct::Hash[error: Ct::Array]]]] => Ct::ResultTupple
  def self.call(list: nil, ctx: nil, ok: nil, error: nil)
    status = :ok
    ctx    = (ctx || {}).dup

    list_error = (error || [])
    list_ok    = (list  || ok)

    status, ctx = call_list(list: list_ok, status: status, ctx: ctx)

    # If there is an error on the :ok track, switch to :error one.
    if status == :error
      status, ctx = call_list(list: list_error, status: status, ctx: ctx)
    end

    if status == :halt
      status = :ok
    end

    [status, ctx]
  end

  def self.call_list(list:, status:, ctx:)
    list
      .map do |el|
        _, local_callable_ctx = Kit::Organizer::Services::Callable.resolve(target: el)
        # TODO: check status?
        local_callable_ctx[:callable]
      end
      .each do |callable|
        local_ctx = Kit::Organizer::Services::Context.generate_callable_ctx(callable: callable, ctx: ctx)

        Kit::Organizer::Log.log(msg: -> { "# Calling `#{ callable }` with keys |#{ local_ctx&.keys }|" }, flags: [:debug, :warning])

        result = local_ctx ? callable.call(**local_ctx) : callable.call()
        result = sanitize_errors(result: result)
        status, local_ctx = result

        Kit::Organizer::Log.log(msg: -> { "#   Result |#{ status }|#{ local_ctx }|" }, flags: [:debug, :info])

        ctx = Kit::Organizer::Services::Context.update_context(ctx: ctx, local_ctx: local_ctx)

        Kit::Organizer::Log.log(msg: -> { "#   Ctx keys post |#{ ctx.keys }|" }, flags: [:debug, :warning])
        Kit::Organizer::Log.log(msg: -> { "#   Errors |#{ ctx[:errors] }|" }, flags: [:debug, :danger]) if ctx[:errors]
        Kit::Organizer::Log.log(msg: "\n\n")

        break if [:error, :halt].include?(status)
      end

    [status, ctx]
  end

  # Sanitizes returned errors, if any.
  #
  # @api private
  # @note Enable simpler error return format from an organized callable.
  #
  # @example Returning an error as a string
  #    sanitize_result([:error, 'Error details']) => [:error, { errors: [{ detail: 'Error details' }] }]
  # @example Returning an error as hash with detail
  #    sanitize_result([:error, { detail: 'Error details' }]) => [:error, { errors: [{ detail: 'Error details' }] }]
  # @example Returning an array of errors in the two former formats
  #    sanitize_result([:error, ['Error1 detail', { detail: 'Error2 details' }]) => [:error, { errors: [{ detail: 'Error1 details' }, { detail: 'Error2 details' }] }]
  #
  #contract Ct::Hash[result: Ct::ResultTupple] => Ct::ResultTupple
  def self.sanitize_errors(result:)
    status, ctx = result

    return result if status != :error

    case ctx
    when String
      ctx = { errors: [{ detail: ctx }] }
    when Hash
      if !ctx[:errors]
        if ctx[:detail]
          ctx = { errors: [ctx] }
        elsif ctx[:error]
          ctx = { errors: [ctx[:error]] }
        end
      end
    when Array
      ctx = { errors: ctx.map { |el| el.is_a?(String) ? { detail: el } : el } }
    end

    [status, ctx]
  end

end
