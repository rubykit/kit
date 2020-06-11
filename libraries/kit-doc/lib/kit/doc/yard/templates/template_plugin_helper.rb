# Kit Helper for Templates.
module Kit::Doc::Yard::TemplatePluginHelper

  # Allow access to Kit plugin config from Templates.
  def config
    ::Kit::Doc::Services::Config.config
  end

end
