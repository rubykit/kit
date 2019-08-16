require 'kit/domain'

module Kit
  module Payment
    class Engine < ::Rails::Engine

      Kit::Domain.config_engine(
        context:   self,
        namespace: Kit::Payment,
        file:      __FILE__,
      )

    end
  end
end
