module Kit::Geolocation
  module Routes

    # NOTE: The indirection is needed somehow for a thread safety thing.
    #   Otherwise we get a `url_options` issue.
    module UrlHelpers
      include Kit::Geolocation::Engine.routes.url_helpers
    end

    extend UrlHelpers

    def self.default_url_options
      Kit::Geolocation::Engine.routes.default_url_options || {}
    end

  end
end