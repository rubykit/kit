module Kit::Domain::Admin::Resources::Event

  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||=  Kit::Domain::Models::Write::Event
    name      ||= 'Event'
    namespace ||= :kit_domain
    menu_opts = {
      label:  name,
      parent: 'Logs',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace  do
      menu menu_opts

      actions :all, except: [:new, :edit, :destroy]

      self.instance_eval(&Kit::Domain::Admin::Resources::Event.setup_index)
      self.instance_eval(&Kit::Domain::Admin::Resources::Event.setup_show)

      [:ok]
    end
  end

  def self.setup_index
    proc do
      config.sort_order = 'created_at_desc'

      index do
        Kit::Admin::Services::Renderers::Index.render(ctx: self,
          attrs: Kit::Domain::Admin::Attributes::Event.index,
        )
      end
    end
  end

  def self.setup_show
    proc do
      show do
        columns do
          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              title: 'Main',
              attrs: Kit::Domain::Admin::Attributes::Event.show.slice(:id, :created_at, :emitted_at),
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              title: 'Main',
              attrs: Kit::Domain::Admin::Attributes::Event.show.slice(:name, :data, :metadata),
            )
          end
        end
      end
    end
  end

end
