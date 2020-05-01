module Yard::Kit::Services::Sidebar::Modules

  def self.get_modules_list(options:, url_generator:)
    config       = Yard::Kit::Config.config
    modules_list = Yard::Kit::Services::Modules.get_modules_hash(options: options)

    modules_groups_lists = Yard::Kit::Services::Sidebar.get_groups_list(groups: config[:groups_for_modules])

    modules_list.each do |full_path, el|
      url  = url_generator.call(el: el)
      data = {
        title:   full_path,
        id:      url.gsub(/\.html$/, ''),
        url:     url,
        headers: [],
      }

      el_groups = Yard::Kit::Services::Sidebar.match_groups(groups: config[:groups_for_modules], value: full_path)
      el_groups.each do |group_name|
        modules_groups_lists[group_name] << data.merge({ group: group_name })
      end
    end

    modules_groups_lists
      .map { |_, list| list }
      .flatten
  end

end