module Kit
  module ActiveAdmin
  end
end

require_relative "active_admin/engine"

require_relative "active_admin/railtie"
require_relative "active_admin/table"
require_relative "active_admin/overrides"

# NOTE: to be able to load the assets
require 'activeadmin_addons'
require 'bootstrap'
require 'popper_js'
