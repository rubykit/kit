module Kit::Doc::Services::Sidebar

  # Generate the group container needed in `sidebar_items`.
  # This maintain the group order defined in the initial config.
  # If no group is specified, we use the empty group (first to be displayed).
  def self.get_groups_list(groups:)
    result = {}

    if groups.first[0] != ''
      result[''] = []
    end

    groups.each do |name, _|
      result[name] = []
    end

    result
  end

  # Assign a group to a module / extra based on the initial config.
  # A module / extra can be in multiple groups.
  def self.match_groups(groups:, value:)
    result = []

    groups.each do |group_name, regex_list|
      regex_list = [regex_list] if !regex_list.is_a?(::Array)

      regex_list.each do |regex|
        next if !regex&.is_a?(::Regexp)

        if regex.match?(value)
          result << group_name
        end
      end
    end

    result.size > 0 ? result : ['']
  end

end
