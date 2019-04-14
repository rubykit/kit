module Kit
  module Auth
    class Engine < ::Rails::Engine
      isolate_namespace Kit::Auth
    end
  end
end
