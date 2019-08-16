require 'kit/domain'

module Kit
  module Geolocation
    class Engine < ::Rails::Engine

      Kit::Domain.config_engine(
        context:   self,
        namespace: Kit::Geolocation,
        file:      __FILE__,
      )

    end
  end
end
