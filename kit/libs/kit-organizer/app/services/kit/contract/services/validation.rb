module Kit::Contract::Services::Validation
  include Kit::Contract

  Ct = Kit::Contract::BuiltInContracts

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
    elsif !result# Falsey
      status = :error
    elsif result.is_a?(::Array) && result[0].in?([:ok, :error])
      result      = Kit::Organizer::Services::Organize.sanitize_errors(result: result)
      status, ctx = result
      if ctx
        ctx = Kit::Organizer::Services::Organize.update_context(ctx: {}, local_ctx: ctx)
      end
    else
      raise "UNREACHABLE. If we get here, we are in trouble."
    end

    if status == :error
      (ctx[:errors] ||= []) << { detail: "Invalid result type for contract" }
      ctx[:contract_error] = { callable: contract, args: args, }
    end

    result = [status]
    result << ctx if (ctx && !ctx.empty?)

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