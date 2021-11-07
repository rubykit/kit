# Call the branch which name is returned by `branch_callable`.
#
# ## Example
#
# ```ruby
# Kit::Organize::Services::Organize.call(
#   list: [
#     [:branch, ->(number:) { number.even? ? :even : :odd }, {
#       even: [
#         ->() { some_action },
#       ],
#       odd: [
#         ->() { some_other_action },
#       ],
#     },],
#   ],
#   ctx: { number: rand(1...10) },
# )
# ```
module Kit::Organizer::Services::Callable::Branch

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Organizer::Contracts

  # The expected format for `:args` is `[:branch, branch_callable, branch_list]`
  before Ct::Hash[args: Ct::Array[Ct::Eq[:branch], Ct::Any, Ct::Hash]]
  def self.resolve(args:)
    _, callable, branches = args

    wrapped_callable = ->(**arguments) do
      ctx_in = arguments || {}

      branch_name, _ctx_out = Kit::Organizer.call(
        list: [callable],
        ctx:  ctx_in,
      )

      ctx_out = {}
      list    = branches[branch_name]

      if list && !list.empty?
        status, ctx_out = Kit::Organizer.call(
          list: branches[branch_name],
          ctx:  ctx_in,
        )

        ctx_out = ctx_out ? Kit::Organizer::Services::Context.update_context(ctx: ctx_in, local_ctx: ctx_out) : ctx_in
      end

      [status, ctx_out]
    end

    [:ok, callable: wrapped_callable]
  end

end
