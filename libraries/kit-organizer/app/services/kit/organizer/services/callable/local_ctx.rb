# Allows you to enrich context of a specific callable, without leaking the value in the general context.
#
# Useful for custom error messages.
#
# ## Example
#
# ```irb
# irb> Kit::Organize::Services::Organize.call(
#   list: [
#     ->(counter:) { [:ok, counter: counter + 1] },
#     [:local_ctx, -> (counter:, custom:) { [:ok, counter: counter + custom] }, { custom: 2 }]
#   ],
#   ctx: { counter: 1 },
# )
# [:ok, counter: 2]
# ```
module Kit::Organizer::Services::Callable::LocalCtx

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  # Receive element from `:list` and resolve it to a callable if the contract matches.
  #
  # The expected format for `:args` is `[:local_ctx, callable, local_context]`
  before Ct::Hash[args: Ct::Array[Ct::Eq[:local_ctx], Ct::Any, Ct::Hash]]
  def self.resolve(args:)
    _, callable, local_ctx = args

    wrapped_callable = ->(**arguments) do
      ctx_in_extended = (arguments || {}).merge(local_ctx)

      status, ctx_out = Kit::Organizer.call(
        list: [callable],
        ctx:  ctx_in_extended,
      )

      ctx_out = ctx_out.slice(*arguments.keys)

      [status, ctx_out]
    end

    [:ok, callable: wrapped_callable]
  end

end
