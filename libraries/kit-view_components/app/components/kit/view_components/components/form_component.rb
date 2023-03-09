# Shared logic for any Domain Component
class Kit::ViewComponents::Components::FormComponent < Kit::ViewComponents::Components::BaseComponent

  include ActiveSupport::Configurable

  # NOTE: overwrite `ActiveSupport::Configurable` default that cause ViewComponent::Base.config to be used
  def self.config
    Class.new(ActiveSupport::Configurable::Configuration).new
  end

  include ActionController::RequestForgeryProtection

  attr_reader :form_action, :form_method, :model, :csrf_token

  def initialize(form_action:, form_method:, model: nil, csrf_token: nil, **)
    super

    @form_action = form_action
    @form_method = form_method
    @csrf_token  = csrf_token
    @model       = model

    @errors_list.each do |el|
      if el[:detail].is_a?(::String) && el[:detail].include?('$attribute') && el[:attribute]
        el[:detail].gsub!('$attribute', el[:attribute].to_s)
      end
    end
  end

  def generic_errors
    @generic_errors ||= errors_list
      .reject { |el| fields_name.include?(el[:attribute]) } || []
  end

  def errors_by_field
    if !defined?(@_errors_by_field)
      list = errors_list.group_by { |v| v[:attribute] }
      fields_name.each do |field|
        if !list[field]
          list[field] = []
        end
      end

      @_errors_by_field = list
    end

    @_errors_by_field
  end

  def fields_name
    return []
    #raise 'IMPLEMENT ME'
  end

end
