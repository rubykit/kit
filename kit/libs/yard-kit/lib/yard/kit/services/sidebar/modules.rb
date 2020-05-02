module Yard::Kit::Services::Sidebar::Modules

  def self.get_all_modules_as_list(options:, url_generator:, anchor_generator:, verifier_runner:)
    config       = Yard::Kit::Config.config
    modules_list = Yard::Kit::Services::Modules.get_all_modules_as_hash({
      options:         options,
      verifier_runner: verifier_runner,
    })

    modules_groups_lists = Yard::Kit::Services::Sidebar.get_groups_list(groups: config[:groups_for_modules])

    modules_list.each do |full_path, el|
      url  = url_generator.call(el: el)
      data = {
        title:      full_path,
        id:         el.name,
        url:        url,
        nodeGroups: generate_node_groups({
          object:           el,
          options:          options,
          anchor_generator: anchor_generator,
          verifier_runner:  verifier_runner,
        }),
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

  def self.generate_node_groups(options:, object:, anchor_generator:, verifier_runner:)
    templates = [
      {
        key:       'methods-class',
        name:      'Class methods',
        list:      Yard::Kit::Services::Modules.get_object_methods({
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
        list:      Yard::Kit::Services::Modules.get_object_methods({
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
        list:      Yard::Kit::Services::Modules.get_object_attributes({
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
        list:      Yard::Kit::Services::Modules.get_object_constants({
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
            properties: Yard::Kit::Services::Properties.object_properties({
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
