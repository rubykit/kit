module Kit::Organizer::Services
  module Organize

    #Contract KeywordArgs[list: ArrayOf[Or[RespondTo[:call], Symbol]], ctx: Optional[Hash]] => [Symbol, Hash]
    def self.call(list:, ctx: {}, expose: nil)
      result = :ok

      begin
        list.each do |calleable|
          calleable = to_calleable(calleable: calleable)

          ctx_in = generate_ctx_in(calleable: calleable, ctx: ctx)
          if ENV['LOG_ORGANIZER']
            puts "# Calling `#{calleable}` with keys |#{ctx_in.keys}|".colorize(:yellow)
          end
          result, ctx_out = calleable.call(ctx_in)

          if ENV['LOG_ORGANIZER']
            puts "#   Result |#{result}|#{ctx_out}|".colorize(:blue)
          end

          # NOTE: should we do a deep merge?
          ctx = ctx.merge(context_update(ctx_out: ctx_out, result: result))

          if ENV['LOG_ORGANIZER']
            puts "#   New context keys |#{ctx.keys}|".colorize(:yellow)
            if ctx[:errors]
              puts "#   Errors |#{ctx[:errors]}|".colorize(:red)
            end
            puts ""
            puts ""
          end

          if result == :error || result == :ok_stop
            break
          end
        end
      #rescue StandardException => e
      #  result = :error
      #  # Todo: use event bus to notify error handlers ?
      end

      if result == :ok_stop
        result = :ok
      end

      if expose && expose[result]
        ctx = ctx.slice([expose[result]].flatten)
      end

      [result, ctx]
    end

    def self.call_for_contract(list:, ctx: {})
      result     = :ok
      result_ctx = nil

      begin
        list.each do |calleable|
          calleable = to_calleable(calleable: calleable)

          ctx_in = generate_ctx_in(calleable: calleable, ctx: ctx)
          if ENV['LOG_ORGANIZER']
            puts "# Calling `#{calleable}` with keys |#{ctx_in.keys}|".colorize(:yellow)
          end

          predicate_result = calleable.call(ctx_in)
          if !predicate_result
            result = :error
          end

          if ENV['LOG_ORGANIZER']
            puts "#   Result |#{result}|".colorize(:blue)
          end

          if result == :error
            result_ctx = { callable: calleable, ctx: ctx_in }
            break
          end
        end
      end

      [result, result_ctx]
    end


    def self.context_update(ctx_out:, result:)
      return {} if !ctx_out

      ctx_out = ctx_out.dup

      if result == :error
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

      ctx_out
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
      elsif calleable.is_a?(Module)
        parameters = calleable.method(:call).parameters
      else
        raise "Unsupported calleable"
      end

      keys_list = parameters
        .map do |el|
          if el[0] == :keyreq || el[0] == :key && ctx.has_key?(el[1])
            el[1]
          else
            nil
          end
        end
        .compact

      ctx.slice(*keys_list)
    end

  end
end