module Kit::Contract::Services::Types
  include Kit::Contract

  # NOTE: adding this level of indirection allows us to ensures the result is always a Tupple
  before ->(contract:) { contract.respond_to?(:call) }
  after  ->(result:)   { result.is_a?(Array) && result.first.in?([:ok, :error]) }
  def self.valid?(contract:, args:)
    result = contract.call(args)

    if result == true
      result = [:ok]
    elsif result == false
      result = [:error]
    else
      status, ctx = result

      # NOTE: this sanitizes errors
      ctx = Kit::Organizer::Services::Organize.context_update(
        ctx_current: {},
        ctx_out:     ctx,
        status:      status,
      )
      result = [status, ctx]
    end

    result
  end

end