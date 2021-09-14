# Add a basic if / else behaviour based on the result of the callable sent as a first argument.
module Kit::Organizer::Services::Callable::If

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  before Ct::Hash[args: Ct::Array[Ct::Eq[:if], Ct::Callable, Ct::Hash[ok: Ct::Optional[Ct::Array], error: Ct::Optional[Ct::Array]]]]
  def self.resolve(args:)
    _, callable, branches = args

    wrapped_callable = ->(**arguments) do
      ctx_in = arguments || {}

      status, ctx_out = Kit::Organizer.call(
        list: [callable],
        ctx:  ctx_in,
      )

      ctx_in  = Kit::Organizer::Services::Context.update_context(ctx: ctx_in, local_ctx: ctx_out)
      ctx_out = nil

      if status == :ok
        if branches[:ok]
          status, ctx_out = Kit::Organizer.call(
            list: branches[:ok],
            ctx:  ctx_in,
          )
        end
      elsif branches[:error]
        status, ctx_out = Kit::Organizer.call(
          list: branches[:error],
          ctx:  ctx_in,
        )
      end

      ctx_out = ctx_out ? Kit::Organizer::Services::Context.update_context(ctx: ctx_in, local_ctx: ctx_out) : ctx_in

      [status, ctx_out]
    end

    [:ok, callable: wrapped_callable]
  end

end
