# Add a basic if / else behaviour based on the result of a predicate callable.
#
# ## Example
#
# ```ruby
# Kit::Organize::Services::Organize.call(
#   list: [
#     [:if, ->(number:) { [(number > 5) ? :ok : :error] }, {
#       ok: [
#         ->() { some_action },
#       ],
#       error: [
#         ->() { some_other_action },
#       ],
#     },],
#   ],
#   ctx: { number: rand(1...10) },
# )
# ```
module Kit::Organizer::Services::Callable::If

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  # The expected format for `:args` is `[:if, predicate_callable, { ok: [callable_list1], error: [callable_list2] }]`
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
