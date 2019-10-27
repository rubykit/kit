module Kit::Contract::Services::Types
  include Kit::Contract

  # NOTE: adding this level of indirection allows us to ensures the result is always a Tupple
  #before Hash[contract: Callable, args: Any] #->(contract:) { contract.respond_to?(:call) }
  #after  Result                              #->(result:)   { result.is_a?(Array) && result.first.in?([:ok, :error]) }
  #contract Hash[contract: Callable, args: Any] => Result
  def self.valid?(contract:, args:)
    result = contract.call(args)

    if result == true
      result = [:ok]
    elsif result == false
      result = [:error]
    else
      status, ctx = result

      # NOTE: we go through context_update to sanitize errors
      ctx = Kit::Organizer::Services::Organize.context_update(
        ctx_current: {},
        ctx_out:     ctx,
        status:      status,
      )
      result = [status, ctx]
    end

    result
  end

  #contract Hash[list: Array[].all(Hash[contract: Callable, args: Any])] => Result
  def self.all_valid?(list:)
    global_status = :ok
    errors        = []

    list.each do |contract:, args:|
      status, ctx = Kit::Contract::Services::Types.valid?(contract: contract, args: args)

      if status == :error
        global_status = :error
        if ctx&.dig(:errors)
          errors.concat(ctx[:errors])
        end
      end
    end

    result = [global_status]
    if errors.size > 0
      result[1] = { errors: errors }
    end

    result
  end

end