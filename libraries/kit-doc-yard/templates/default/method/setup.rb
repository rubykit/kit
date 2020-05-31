include ::Kit::Doc::Yard::TemplatePluginHelper # rubocop:disable Style/MixinUsage

def init
  sections(:header, [
    T('method_details'),
  ],)
end
