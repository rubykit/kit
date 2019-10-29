module Kit::Organizer::Services
  module Organize

    #contract Hash[list: Array.of(Or[Callable, Symbol]), ctx: Optional[Hash], expose: Optional[Boolean]] => ResultTupple
    def self.call(list:, ctx: {}, expose: nil)
      status = :ok

      begin
        list.each do |calleable|
          calleable = to_calleable(calleable: calleable)

          ctx_in = generate_ctx_in(calleable: calleable, ctx: ctx)
          if ENV['LOG_ORGANIZER']
            puts "# Calling `#{calleable}` with keys |#{ctx_in}|".colorize(:yellow)
          end
          status, ctx_out = calleable.call(*ctx_in)

          if ENV['LOG_ORGANIZER']
            puts "#   Result |#{status}|#{ctx_out}|".colorize(:blue)
          end

          ctx = context_update(ctx_current: ctx, ctx_out: ctx_out, status: status)

          if ENV['LOG_ORGANIZER']
            puts "#   New context keys |#{ctx.keys}|".colorize(:yellow)
            if ctx[:errors]
              puts "#   Errors |#{ctx[:errors]}|".colorize(:red)
            end
            puts ""
            puts ""
          end

          if status == :error || status == :ok_stop
            break
          end
        end
      #rescue StandardException => e
      #  status = :error
      #  # Todo: use event bus to notify error handlers ?
      end

      if status == :ok_stop
        status = :ok
      end

      if expose && expose[status]
        ctx = ctx.slice([expose[status]].flatten)
      end

      [status, ctx]
    end

    def self.call_for_contract(list:, ctx: {})
      status = :ok

      begin
        list.each do |calleable|
          calleable = to_calleable(calleable: calleable)

          ctx_in    = generate_ctx_in(calleable: calleable, ctx: ctx)
          if ENV['LOG_ORGANIZER']
            puts "# Calling `#{calleable}` with keys |#{ctx_in}|".colorize(:yellow)
          end

          result = calleable.call(*ctx_in)

          if result == true
            status = :ok
          elsif result == false
            status = :error
          else
            status, ctx_out = result
            ctx = context_update(ctx_current: ctx, ctx_out: ctx_out, status: status)
          end

          if ENV['LOG_ORGANIZER']
            puts "#   Result |#{result}|".colorize(:blue)
          end

          if status == :error
            ctx[:contract_error] = { callable: calleable, ctx: ctx_in }
            break
          end
        end
      end

      [status, ctx]
    end


    def self.context_update(ctx_current:, ctx_out:, status:)
      return {} if !ctx_out

      ctx_out = ctx_out.dup

      if status == :error
        # NOTE: this is a potenially dangerous unexpected behaviour !
        if ctx_out.is_a?(Hash)
          if !ctx_out.has_key?(:errors) && ctx_out.has_key?(:detail)
            ctx_out = { errors: [ctx_out] }
          end
        elsif ctx_out.is_a?(Array)
          ctx_out = { errors: ctx_out }
        elsif ctx_out.is_a?(String)
          ctx_out = { errors: [{ detail: ctx_out }] }
        end
      end

      # NOTE: should we do a deep merge?
      ctx_current.merge(ctx_out)
    end

    def self.to_calleable(calleable:)
      if calleable.is_a?(Array)
        class_object, method_name = calleable

        calleable = class_object.method(method_name)
      elsif calleable.is_a?(Symbol)
        calleable = Kit::Organizer::Services::Store.get(id: calleable)
      end

      calleable
    end

    def self.generate_ctx_in(calleable:, ctx:)
      if calleable.is_a?(Proc) || calleable.is_a?(Method)
        parameters = calleable.parameters
      #elsif calleable.is_a?(Module)
      #  parameters = calleable.method(:call).parameters
      elsif calleable.respond_to?(:call)
        parameters = calleable.method(:call).parameters
      else
        raise "Unsupported calleable"
      end

      result = []

      expected_keys = parameters
        .map { |el| el[0].in?([:keyreq, :key]) ? el[1] : nil }
        .compact

      if expected_keys.size > 0
        available_keys = expected_keys
          .select { |name| ctx.has_key?(name) }

        result << ctx.slice(*available_keys)
      end

      if parameters.any? { |el| el[0] == :keyrest }
        result << ctx.slice(*(ctx.keys - expected_keys))
      end

      result
    end

  end
end