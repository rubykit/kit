# Allow to call a callable that's part of the current context.
#
# ## Example
#
# ```ruby
# status, ctx = Kit::Organize::Services::Organize.call(
#   list: [
#     [:ctx_call, :increment_callable],
#   ],
#   ctx: {
#     number:             1,
#     increment_callable: ->(number:) { [:ok, number: number + 1] },
#   },
# )
# ctx[:number] == 2 # true
# ```
module Kit::Organizer::Services::Callable::CtxCall

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  # The expected format for `:args` is `[:ctx_call, :key_of_the_callable_context]`
  contract Ct::Hash[args: Ct::Tupple[Ct::Eq[:ctx_call], Ct::Symbol]]
  def self.resolve(args:)
    _, target_callable_key = args

    callable = ->(**arguments) do
      ctx_in          = arguments || {}
      target_callable = arguments[target_callable_key]

      Kit::Organizer.call(
        list: [target_callable],
        ctx:  ctx_in,
      )
    end

    [:ok, callable: callable]
  end

end
