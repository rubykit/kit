module Kit::Contract::Services::Validation
  #include Kit::Contract
  #include Kit::Contract::Types

  #EXPECTED_CALLABLE_RESULT_TYPE = Or[Boolean, ResultTupple]

  #contract Hash[contract: Callable, args: Any] => ResultTupple
  def self.valid?(contract:, args:)
    args_in = Kit::Contract::Services::SignatureMatcher.generate_args_in(callable: contract, args: args)

    if ENV['LOG_ORGANIZER']
      puts "# Calling `#{contract}` with args: `#{args_in}`".colorize(:yellow)
    end
    result = contract.call(*args_in)
    if ENV['LOG_ORGANIZER']
      puts "#   Result |#{result}|".colorize(:blue)
    end

    ctx = {}

    if result == true
      status = :ok
    elsif result == false
      status = :error
    elsif result.is_a?(::Array) && result[0].in?([:ok, :error])
      status, ctx = result

      # NOTE: we go through context_update to sanitize errors
      ctx = Kit::Organizer::Services::Organize.context_update(
        ctx_current: {},
        ctx_out:     ctx,
        status:      status,
      )
    else
      raise "UNREACHABLE"
    end

    if status == :error
      (ctx[:errors] ||= []) << "Invalid result type for contract"
      ctx[:contract_error] = { callable: contract, args: args, }
    end

    result = [status]
    result << ctx if !ctx.empty?

    result
  end

  #contract Hash[contracts: Array.of(Callable), args: Array] => ResultTupple
  def self.all(contracts:, args:)
    status = :ok
    ctx    = {}

    contracts.each do |contract|
      status, ctx = valid?(contract: contract, args: args,)

      break if status == :error
    end

    [status, ctx]
  end

end