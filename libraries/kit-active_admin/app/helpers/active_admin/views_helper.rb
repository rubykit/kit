module ActiveAdmin::ViewsHelper

  # Make sure `link_to` calls `main_app.url_for` instead of `url_for`
  def link_to(name = nil, options = nil, html_options = nil, &block)
    html_options, options, name = options, name, block if block_given?
    options ||= {}

    html_options = convert_options_to_data_attributes(options, html_options)

    # NOTE: only change is the following line
    url = main_app.url_for(options)
    html_options["href"] ||= url

    content_tag("a", name || url, html_options, &block)
  end

end
