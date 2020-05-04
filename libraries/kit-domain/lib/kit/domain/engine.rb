module Kit
  module Domain
    class Engine < ::Rails::Engine
      isolate_namespace Kit::Domain

    end
  end
end
