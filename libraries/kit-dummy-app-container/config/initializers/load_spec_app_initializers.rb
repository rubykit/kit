if KIT_APP_PATHS['GEM_SPEC_INITIALIZERS']
  list = KIT_APP_PATHS['GEM_SPEC_INITIALIZERS']
  list = [list] if !list.is_a?(::Array)

  list.each do |initializer_file|
    require_relative initializer_file
  end
end
