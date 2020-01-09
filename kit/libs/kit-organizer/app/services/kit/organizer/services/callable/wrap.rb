# Allows to wrap a callable in order to adapt the input & output contexts
module Kit::Organizer::Services::Callable::Wrap
  include Kit::Contract
  Ct = Kit::Organizer::Contracts

  before Ct::Hash[args: Ct::Array[Ct::Eq[:wrap], Ct::Callable, Ct::Hash[in: Ct::Optional[Ct::Hash], out: Ct::Optional[Ct::Hash]]]]
  def self.resolve(args:)
    _, callable, opts = args

    opts_in  = opts[:in]  || {}
    opts_out = opts[:out] || {}

    wrapped_callable = ->(**arguments) do
      ctx_in = arguments || {}
      if opts_in
        ctx_in = Kit::Organizer::Services::Callable::Wrap.slice(ctx: ctx_in, transform: opts_in)
      end

      status, ctx_out = Kit::Organizer.call({
        list: [callable],
        ctx: ctx_in,
      })

      if opts_out
        ctx_out = Kit::Organizer::Services::Callable::Wrap.slice(ctx: ctx_out, transform: opts_out)
      end

      [status, ctx_out]
    end

    [:ok, callable: wrapped_callable]
  end

  def self.slice(ctx:, transform:)
    ctx
      .map do |k, v|
        if k.in?(transform)
          [transform[k], v]
        else
          nil
        end
      end
      .compact
      .to_h
  end

end