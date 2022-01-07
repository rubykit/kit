if defined?(Slim) && [true, 'true'].include?(ENV['SLIM_PRETTY'])
  Slim::Engine.set_options pretty: true, sort_attrs: false
end
