# Allows you to enrich context of a specific callable, without leaking the value in the general context.
#
# The third argument is a local context that is injected as is.
#
# The 4th argument is a "rename" context. It renames keys from the ctx to be sent with another name to the callable.
#   
#
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
  before Ct::Hash[args: Ct::Array[Ct::Eq[:local_ctx], Ct::Any, Ct::Optional[Ct::Hash], Ct::Optional[Ct::Hash]]]
  def self.resolve(args:)
    _, callable, local_ctx, rename_rules = args

    local_ctx    ||= {}
    rename_rules ||= {}

    wrapped_callable = ->(**arguments) do
      renamed_ctx = {}
      if rename_rules
        res = rename_keys(ctx: arguments, rename_rules: rename_rules)
        renamed_ctx = res[1][:renamed_ctx]
      end

      ctx_in_extended = (arguments || {})
        .merge(local_ctx)
        .merge(renamed_ctx)

      status, ctx_out = Kit::Organizer.call(
        list: [callable],
        ctx:  ctx_in_extended,
      )

      ctx_out = ctx_out
        .except(*local_ctx.keys)
        .except(*renamed_ctx.keys)

      [status, ctx_out]
    end

    [:ok, callable: wrapped_callable]
  end

  # Replace keys name in `:ctx` according to `:rename_rules`
  #
  # `:rename_rules` is a hash where the key are the new key_name, and the values the current key_name
  def self.rename_keys(ctx:, rename_rules:)
    renamed_ctx = {}

    if rename_rules && !rename_rules.empty?
      rename_rules.each do |k, v|
        if ctx[v]
          renamed_ctx[k] = ctx[v]
        end
      end
    end

    [:ok, renamed_ctx: renamed_ctx]
  end

end
