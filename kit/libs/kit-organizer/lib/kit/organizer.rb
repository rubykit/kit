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
            ctx_in = generate_ctx_in(calleable: calleable, ctx: ctx)
            if ENV['LOG_ORGANIZER']
              puts "# Calling `#{calleable}` with: #{ctx_in}"
            end
            result, ctx_out = calleable.call(ctx_in)

            if ENV['LOG_ORGANIZER']
              puts "# |#{result}|#{ctx_out}|"
            end
            # TODO: should we do a deep merge?
            if ctx_out
              ctx = ctx.merge(ctx_out)
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

      protected

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
            if el[0] == :keyreq || el[1] == :key && ctx.has_key?(el[1])
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