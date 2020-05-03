# frozen_string_literal: true
module Kit::Doc::Yard::TemplatePluginHelper

  # Allow access to plugin config
  def config
    ::Kit::Doc::Services::Config.config
  end

end
