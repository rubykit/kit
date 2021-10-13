# Add a nested error / success flow.
#
# ## Example
#
# ```ruby
# Kit::Organize::Services::Organize.call(
#   ok: [
#     [:nest, {
#       ok: [
#         ->() { some_action },
#       ],
#       error: [
#         ->() { some_other_action },
#       ],
#     },],
#   ],
#   ctx: { number: 1 },
# )
# ```
module Kit::Organizer::Services::Callable::Nest

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  # The expected format for `:args` is `[:nest, { ok: [callable_list1], error: [callable_list2] }]`
  before Ct::Hash[args: Ct::Array[Ct::Eq[:nest], Ct::Hash[ok: Ct::Optional[Ct::Array], error: Ct::Optional[Ct::Array]]]]
  def self.resolve(args:)
    _, branches = args

    wrapped_callable = ->(**arguments) do
      ctx_in = arguments || {}

      Kit::Organizer.call(**branches.merge(ctx: ctx_in))
    end

    [:ok, callable: wrapped_callable]
  end

end
