# frozen_string_literal: true
module Yard::Kit::YardKitPluginHelper

  # Allow access to plugin config
  def config
    ::Yard::Kit::Config.config
  end

end
