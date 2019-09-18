module Kit::Organizer
  module Flow

    #Contract KeywordArgs[list: ArrayOf[Or[RespondTo[:call], Symbol]], ctx: Optional[Hash]] => [Symbol, Hash]
    # Flows is a hash where the value are calleables
    def self.organize(flows:)
    end



   # NOTE: probably quite dangerous with nesting
    def self.example
      flow(
        default: [:process, :render],
        flows: {
          process: {
            list: [
              'Kit::Domain::Controllers::JsonApi.method(:ensure_media_type)',
              'Kit::Auth::Actions::Users::CreateUserWithPassword',
            ]
            ensure: ->() { [:flow, :render] },
          }
          render: [
            'self.method(:render)',
          ],
        }
      )

    end

  end
end
