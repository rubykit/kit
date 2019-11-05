module Kit::Contract::Services
  module Validate

    #EXPECTED_CALLABLE_RESULT_TYPE = Or[Boolean, ResultTupple]

    contract Hash[contract: Callable, args: Any] => ResultTupple
    def self.valid?(contract:, args:)
      args_in = generate_args_in(calleable: calleable, args: args)

      if ENV['LOG_ORGANIZER']
        puts "# Calling `#{calleable}` with args: `#{args_in}`".colorize(:yellow)
      end
      result = contract.call(args_in)
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
        result = [status, ctx]
      else
        result = [:error, {
          errors:         ["Invalid result type for contract"],
          contract_error: { callable: calleable, args: args, },
        },]
      end

      results
    end

    contract Hash[contracts: Array.of(Callable), args: Array] => ResultTupple
    def self.all(contracts:, args:)
      status = :ok
      ctx    = {}

      contracts.each do |calleable|
        status, ctx = valid?(callable: callable, args: args,)

        break if status == :error
      end

      [status, ctx]
    end

  end
end