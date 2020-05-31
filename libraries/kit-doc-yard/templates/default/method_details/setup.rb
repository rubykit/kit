include ::Kit::Doc::Yard::TemplatePluginHelper # rubocop:disable Style/MixinUsage

def init
  sections :header, [
    :method_signature,
    :docstring_wrapper, [
      T('docstring'),
    ],
    #:source,
  ]
end
