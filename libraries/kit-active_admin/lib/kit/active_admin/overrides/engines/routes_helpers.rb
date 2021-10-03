# Path related.
#
# Since we mount the admin directly in the application container, the top level routes are not available in the engine.
# There might be a more idiomatic way to handle this by making them available somehow?
#
# Below are various overwrite to make sure:
#   - `url_for` is called on `main_app` and not on the engine context.
#   - when `link_to` is used, it calls the right `url_for`

# See also: `app/helpers/active_admin/views_helper.rb`

# Override `url_for` when it is called directly --------------------------------
proxy = proc do
  def url_for(*args, **kwargs)
    main_app.url_for(*args, **kwargs)
  end
end

list = [
  ActiveAdmin::Component,
  ActiveAdmin::Views::TableFor,
  #ActiveAdmin::Views::MenuItem,
]

list.each do |el|
  el.class_eval &proxy
end

# ------------------------------------------------------------------------------

# ### References
# - https://github.com/activeadmin/activeadmin/blob/v2.9.0/lib/active_admin/namespace.rb#L106
class ActiveAdmin::Namespace

  # Add namespace config "route_prefix" when defined.
  def route_prefix
    segments = []

    if settings.route_prefix
      segments << settings.route_prefix
    end

    if !root?
      segments << (settings.scope_path || @name)
    end

    segments.empty? ? nil : segments.join('_')
  end

end

# ------------------------------------------------------------------------------

# ### References
# - https://github.com/activeadmin/inherited_resources/blob/v1.13.0/lib/inherited_resources/url_helpers.rb#L237
module InheritedResources::UrlHelpers

  protected

  def define_helper_method(prefix, name, suffix, segments)
    method_name = [prefix, name, suffix].compact.join('_')
    params_method_name = ['', prefix, name, :params].compact.join('_')
    segments_method = [prefix, segments, suffix].compact.join('_')

    undef_method method_name if method_defined? method_name

    define_method method_name do |*given_args|
      given_args = send params_method_name, *given_args
      # NOTE: this is the change
      if segments_method.end_with?('_path') || segment_method.end_with?('_route')
        main_app.send(segments_method, *given_args)
      else
        send segments_method, *given_args
      end
    end
    protected method_name
  end

end

# ------------------------------------------------------------------------------

class Kaminari::Helpers::Tag

  def page_url_for(page)
    params = params_for(page)
    params[:only_path] = true
    # NOTE: the following line is the change
    @template.main_app.url_for params
  end

end

# ------------------------------------------------------------------------------

=begin
class ActiveAdmin::Resource::Routes::RouteBuilder

  def routes
    resource.namespace.settings.url_helpers || super
  end

end
=end
