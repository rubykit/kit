# Namespace for Contract validation
module Kit::Contract::Services::Validation

  include Kit::Contract::Mixin
  # @doc false
  Ct = Kit::Contract::BuiltInContracts

  #EXPECTED_CALLABLE_RESULT_TYPE = Or[Boolean, ResultTupple]

  #contract Hash[contract: Callable, args: Any] => ResultTupple
  # Run a contract & normalize output.
  def self.valid?(contract:, args:)
    args_in = Kit::Contract::Services::RubyHelpers.generate_args_in(callable: contract, args: args)

    if ENV['KIT_CONTRACT_DEBUG'] == 'true'
      puts "# Calling `#{ contract }` with args: `#{ args_in }`".yellow
    end
    result = contract.call(*args_in)
    if ENV['KIT_CONTRACT_DEBUG'] == 'true'
      puts "#   Result |#{ result }|".blue
    end

    ctx = {}

    if result == true
      status = :ok
    elsif !result # Falsey
      status = :error
    elsif result.is_a?(::Array) && result[0].in?([:ok, :error])
      result      = Kit::Organizer::Services::Organize.sanitize_errors(result: result)
      status, ctx = result
      if ctx
        ctx = Kit::Organizer::Services::Context.update_context(ctx: {}, local_ctx: ctx)
      end
    else
      raise 'UNREACHABLE... If we got here, we are truly in trouble.'
    end

    if status == :error
      if (ctx[:errors]&.size || 0) == 0
        (ctx[:errors] ||= []) << { detail: 'Invalid result type for contract' }
      end

      if !ctx[:contract_error]
        ctx[:contract_error] = { callable: contract, args: args, contracts_stack: [contract] }
      else
        ctx[:contract_error][:contracts_stack] << contract
      end
    end

    result = [status]
    result << ctx if ctx && !ctx.empty?

    result
  end

  #contract Hash[contracts: Array.of(Callable), args: Array] => ResultTupple
  def self.all(contracts:, args:)
    status = :ok
    ctx    = {}

    contracts.each do |contract|
      status, ctx = valid?(contract: contract, args: args)

      break if status == :error
    end

    [status, ctx]
  end

end
