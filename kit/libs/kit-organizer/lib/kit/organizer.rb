require 'contracts'

module Kit
  module Organizer
    include Contracts

    class << self

      Contract KeywordArgs[list: ArrayOf[RespondTo[:call]], ctx: Optional[Hash]] => [Symbol, Hash]
      def call(list:, ctx: {})
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
              puts "#   Result |#{result}|#{ctx_out}|".colorize(:yellow)
            end

            # NOTE: should we do a deep merge?
            ctx = ctx.merge(context_update(ctx_out: ctx_out, result: result))

            if ENV['LOG_ORGANIZER']
              puts "#   New context keys |#{ctx.keys}|".colorize(:yellow)
              puts "#   Errors |#{ctx[:errors]}|".colorize(:yellow)
            end

            if result == :error
              break
            end
          end
        #rescue StandardException => e
        #  result = :error
        #  # Todo: use event bus to notify error handlers ?
        end

        [result, ctx]
      end

      def always(calleable, key)
        calleable = to_calleable(calleable: calleable)
        ->(ctx_in) { [:ok, key: calleable.call(ctx_in)] }
      end

      protected

      def context_update(ctx_out:, result:)
        return {} if !ctx_out

        ctx_out = ctx_out.dup

        if result == :error
          if ctx_out.is_a?(Hash)
            if !ctx_out[:errors]
              ctx_out = { errors: [ctx_out] }
            end
          elsif ctx_out.is_a?(Array)
            ctx_out = { errors: ctx_out }
          else
            # NOTE: not sure failing silently the best course
            ctx_out = {}
          end
        end

        ctx_out
      end

      def to_calleable(calleable:)
        if calleable.is_a?(Array)
          class_object, method_name = calleable

          calleable = class_object.method(method_name)
        end

        calleable
      end

      def generate_ctx_in(calleable:, ctx:)
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

end

require "kit/organizer/railtie"