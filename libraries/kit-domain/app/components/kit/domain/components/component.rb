# Shared logic for any Domain Component
class Kit::Domain::Components::Component < ::ViewComponent::Base

  attr_accessor :id, :request, :classes

  def initialize(request: nil, classes: [], **)
    super

    @request = request
    @classes = [classes].flatten

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

end
