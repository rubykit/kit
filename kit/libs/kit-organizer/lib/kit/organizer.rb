module Kit
  # Forward declaration of the namespace, the actual logic lives in `app`


  module Organizer

    def self.call(list:, ctx: {}, filter: nil)
      arguments = { list: list, ctx: ctx, filter: filter }

      Kit::Organizer::Services::Organize.call(arguments)
    end

    def self.call_for_contract(list:, ctx: {})
      arguments = { list: list, ctx: ctx }

      Kit::Organizer::Services::Organize.call_for_contract(arguments)
    end

=begin
      def always(callable, key)
        callable = to_callable(callable: callable)
        ->(ctx_in) { [:ok, key: callable.call(ctx_in)] }
      end
=end

    def self.register(id:, target:)
      arguments = { id: id, target: target }

      Kit::Organizer::Services::Store.register(arguments)
    end

    def self.merge(results:)
      arguments = { results: results }

      Kit::Organizer::Services::Results.merge(arguments)
    end

  end
end

require 'kit/organizer/engine'
