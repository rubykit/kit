# Shared logic for any Domain Component
class Kit::ViewComponents::Components::BaseComponent < ::ViewComponent::Base

  attr_accessor :id, :router_request, :args, :classes, :errors_list

  def initialize(router_request: nil, classes: [], errors_list: nil, **rest)
    super

    @args = {
      router_request: router_request,
      classes:        classes,
    }.merge(rest)

    @router_request = router_request
    @classes        = [classes].flatten
    @errors_list    = ([errors_list].flatten || []) - [nil]

    self.classes << component_class_name
  end

  def classes_str
    classes.join(' ')
  end

  def component_class_name
    @component_class_name ||= self.class.component_class_name
  end

  def random_id(lid = id)
    @random_id ||= "#{ lid.underscore }_#{ SecureRandom.hex(4) }"
  end

  def self.component_class_name
    name = self.name.underscore.split('components/')[1].downcase.dasherize.gsub('/', '_').delete_suffix('-component')

    "component_#{ name }"
  end

  def local_render(router_request: nil, &block)
    controller     = router_request.adapters.dig(:http_rails, :rails_controller)
    lookup_context = ActionView::LookupContext.new(ActionController::Base.view_paths)
    view           = ActionView::Base.new(lookup_context, {}, controller)

    self.render_in(view)
  end

end
