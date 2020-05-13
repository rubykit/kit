# Data transformation logic for Modules sidebar content.
module Kit::Doc::Services::Sidebar::Modules

  def self.get_all_namespaces_as_list(options:, url_generator:, anchor_generator:, verifier_runner:)
    config       = Kit::Doc::Services::Config.config
    modules_list = Kit::Doc::Services::Modules.get_all_namespaces_as_hash({
      options:         options,
      verifier_runner: verifier_runner,
    })

    modules_groups_lists = Kit::Doc::Services::Sidebar.get_ordered_groups_container(groups: config[:groups_for_modules])

    modules_list.each do |full_path, el|
      url  = url_generator.call(el: el)
      data = {
        title:         full_path,
        display_title: full_path,
        id:            el.name,
        url:           url,
        nodeGroups:    generate_node_groups({
          object:           el,
          options:          options,
          anchor_generator: anchor_generator,
          verifier_runner:  verifier_runner,
        }),
      }

      el_groups = Kit::Doc::Services::Sidebar.find_element_groups(groups: config[:groups_for_modules], element_name: full_path)
      el_groups.each do |group_name:, display_title:, css_classes:, display:|
        next if !display

        data_for_group = data.merge({
          group:         group_name,
          display_title: display_title,
          css_classes:   css_classes,
        })

        modules_groups_lists[group_name] << data_for_group
      end
    end

    modules_groups_lists
      .map { |_, list| list }
      .flatten
  end

  def self.generate_node_groups(options:, object:, anchor_generator:, verifier_runner:)
    templates = [
      {
        key:       'methods-class',
        name:      'Class methods',
        list:      Kit::Doc::Services::Modules.get_object_methods({
          object:                   object,
          options:                  options,
          include_instance_methods: false,
          include_aliases:          true,
          verifier_runner:          verifier_runner,
        }),
        transform: ->(el:) do
          {
            id: "##{ el.name }",
          }
        end,
      },
      {
        key:       'methods-instance',
        name:      'Instance methods',
        list:      Kit::Doc::Services::Modules.get_object_methods({
          object:                object,
          options:               options,
          include_class_methods: false,
          include_aliases:       true,
          verifier_runner:       verifier_runner,
        }),
        transform: ->(el:) do
          {
            id: ".#{ el.name }",
          }
        end,
      },
      {
        key:       'attributes-instance',
        name:      'Instance attributes',
        list:      Kit::Doc::Services::Modules.get_object_attributes({
          object:          object,
          options:         options,
          verifier_runner: verifier_runner,
        }),
        transform: ->(el:) do
          {
            id: ".#{ el.name }",
          }
        end,
      },
      {
        key:       'constants',
        name:      'Constants',
        list:      Kit::Doc::Services::Modules.get_object_constants({
          object:          object,
          options:         options,
          verifier_runner: verifier_runner,
        }),
        transform: ->(el:) do
          {
            id: el.name,
          }
        end,
      },
    ]

    templates.map do |data|
      list = data[:list]
      next if list.size == 0

      {
        key:   data[:key],
        name:  data[:name],
        nodes: list.map do |node|
          res = {
            anchor:     anchor_generator.call(el: node),
            properties: Kit::Doc::Services::Properties.object_properties({
              item:            node,
              verifier_runner: verifier_runner,
            }),
          }

          res = res.merge data[:transform].call(el: node)

          res
        end,
      }
    end.compact
  end

end
