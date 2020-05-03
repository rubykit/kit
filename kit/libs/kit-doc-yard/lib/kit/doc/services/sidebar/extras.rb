module Kit::Doc::Services::Sidebar::Extras

  def self.get_extras_list(options:, url_generator:)
    config      = Kit::Doc::Services::Config.config
    extras_list = Kit::Doc::Services::Extras.get_extras_list(options: options)

    extras_groups_lists = Kit::Doc::Services::Sidebar.get_groups_list(groups: config[:groups_for_extras])

    extras_list.each do |el|
      url = url_generator.call(el: el)
      toc = el.contents_toc

      data = {
        title:   toc&.dig(0, :title) || el.name,
        id:      url.gsub(/\.html$/, ''),
        url:     url,
        headers: (toc&.dig(0, :sections) || []).map do |h2|
          {
            id:     h2[:title],
            anchor: h2[:anchor],
          }
        end,
      }

      el_groups = Kit::Doc::Services::Sidebar.match_groups(groups: config[:groups_for_extras], value: el.filename)
      el_groups.each do |group_name|
        extras_groups_lists[group_name] << data.merge({ group: group_name })
      end

    end

    extras_export_list = extras_groups_lists
      .map { |_, list| list }
      .flatten

    extras_export_list.unshift({
      title:   'API Reference',
      id:      'api_reference',
      url:     'api_reference.html',
      group:   '',
=begin
      headers: [
        {
          anchor: 'namespaces',
          id:     'Namespaces',
        },
      ],
=end
    })

    extras_export_list
  end

end