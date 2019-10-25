module Kit
  module Organizer
    include Contract

    #Contract KeywordArgs[list: ArrayOf[Or[RespondTo[:call], Symbol]], ctx: Optional[Hash]] => [Symbol, Hash]
    def self.call(list:, ctx: {}, expose: nil)
      arguments = { list: list, ctx: ctx, expose: expose }

      Kit::Organizer::Services::Organize.call(arguments)
    end

    def self.call_for_contract(list:, ctx: {})
      arguments = { list: list, ctx: ctx }

      Kit::Organizer::Services::Organize.call_for_contract(arguments)
    end

=begin
      def always(calleable, key)
        calleable = to_calleable(calleable: calleable)
        ->(ctx_in) { [:ok, key: calleable.call(ctx_in)] }
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