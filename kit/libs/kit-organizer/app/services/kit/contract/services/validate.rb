module Kit::Contract::Services
  module Validate
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

      if result == true
        result = [:ok]
      elsif result == false
        result = [:error]
      elsif result.is_a?(::Array) && result[0].in?([:ok, :error])
        status, ctx = result

        # NOTE: we go through context_update to sanitize errors
        ctx = Kit::Organizer::Services::Organize.context_update(
          ctx_current: {},
          ctx_out:     ctx,
          status:      status,
        )
        result = [status]

        result << ctx if !ctx.empty?
      else
        result = [:error, {
          errors:         ["Invalid result type for contract"],
          contract_error: { callable: contract, args: args, },
        },]
      end

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
end