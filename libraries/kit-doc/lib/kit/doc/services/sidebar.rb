# Data transformation logic for the documentation `Sidebar` content.
module Kit::Doc::Services::Sidebar

  # Generate the group container needed in `sidebar_items`.
  #
  # This maintain the group order defined in the initial config.
  def self.get_ordered_groups_container(groups:)
    result = {}

    if groups.dig(0, 0) != ''
      result[''] = []
    end

    groups.each do |name, _|
      result[name] = []
    end

    result
  end

  # Check if an element (module / extra) should be part of a group, based on its name, given groups conditions.
  #
  # An element be in multiple groups if it matches inclusion conditions.
  #
  # Also generate the display name && css classes.
  #
  # If no group is specified, we default to the empty group (first to be displayed) rather than hidding the element.
  def self.find_element_groups(element_name:, groups:)
    result = []

    groups.each do |group_name, group_data|
      matchers = transform_matchers(group_data: group_data, group_name: group_name)

      matchers.each do |inclusion_fn:, display_title:, css_classes:, display:|
        next if !inclusion_fn.call(element_name)

        display_title = display_title.call(element_name) if display_title.respond_to?(:call)
        css_classes   = css_classes.call(element_name)   if css_classes.respond_to?(:call)
        css_classes ||= []

        group_data = {
          group_name:    group_name,
          display_title: display_title,
          css_classes:   css_classes.join(' '),
          display:       display,
        }

        result << group_data
        break
      end
    end

    if result.size > 0
      result
    else
      [{ group_name: '', display_title: nil, css_classes: [], display: true }]
    end
  end

  # Transform the group matcher input format to allow Callables & Regexps.
  #
  # The following is valid input:
  # ```ruby
  # groups_for_modules: {
  #   # List of regexps
  #   'My group' => [
  #     # Regexp
  #     %r{^ClassA$},
  #     # Callable
  #     ->(name) { name.start_with?('ModuleB'),
  #     # Hash with the following keys:
  #     {
  #       # Inclusion needs to be either a Regexp or a Callable
  #       inclusion:   %r{^ModuleB.*},
  #       # A callable that returns an array of css classes
  #       css_classes: ->(name) do
  #         ['text-left', name.start_with?('Module') ? 'module' : 'class'],
  #       end,
  #       # A callable that return the name that will be displayed in the sidebar
  #       display_title: ->(name) { name.split('::')[-1] },
  #     },
  #   ],
  # }
  # ```
  def self.transform_matchers(group_data:, group_name:)
    matchers = []

    if !group_data.is_a?(Array)
      group_data = [group_data]
    end

    group_data.each do |current_matcher|
      matcher = {
        inclusion_fn:  nil,
        display_title: nil,
        css_classes:   nil,
        display:       true,
      }

      if current_matcher.is_a?(Hash)
        matcher[:display_title] = current_matcher[:display_title]
        matcher[:css_classes]   = current_matcher[:css_classes]
        matcher[:display]       = (current_matcher[:display] == false) ? false : true
        current_matcher         = current_matcher[:inclusion]
      end

      if current_matcher.is_a?(Regexp)
        matcher[:inclusion_fn] = ->(value) { current_matcher.match?(value) }
      elsif current_matcher.respond_to?(:call)
        matcher[:inclusion_fn] = current_matcher
      else
        puts "Kit::Doc - Ignoring group `#{ group_name }` for sidebar: invalid inclusion matcher."
        next
      end

      matchers << matcher
    end

    matchers
  end

end
