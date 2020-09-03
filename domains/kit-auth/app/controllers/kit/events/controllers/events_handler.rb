module Kit::Events::Controllers
  module EventsHandler

    def self.endpoint(router_request:)
      # This is where we react to an event (send to segment, etc)

      [:ok]
    end

    Kit::Router::Services::Router.register({
      uid:     'kit_events|system|events|process',
      aliases: ['system|events|process'],
      target:  self.method(:endpoint),
    })

  end
end