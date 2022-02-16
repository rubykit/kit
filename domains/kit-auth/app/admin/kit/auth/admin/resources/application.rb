module Kit::Auth::Admin::Resources::Application

  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||= Kit::Auth::Models::Read::Application
    name      ||= 'Application'
    namespace ||= :kit_auth
    menu_opts = {
      label:  name,
      parent: 'Developer',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace  do
      menu menu_opts

      actions :all, except: [:new, :edit, :destroy]

      self.instance_eval(&Kit::Auth::Admin::Resources::Application.setup_index)
      self.instance_eval(&Kit::Auth::Admin::Resources::Application.setup_show)
    end

    [:ok]
  end

  def self.setup_index
    proc do
      index do
        Kit::Admin::Services::Renderers::Index.render(ctx: self,
          attrs: Kit::Auth::Admin::Attributes::Application.index,
        )
      end
    end
  end

  def self.setup_show
    proc do
      show do
        Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
          attrs: Kit::Auth::Admin::Attributes::Application.show,
        )

        hr

        Kit::Admin::Services::Renderers::PanelList.render(ctx: self,
          attrs:    Kit::Auth::Admin::Attributes::Application.list.except(:application),
          relation: resource.user_access_tokens,
        )
      end
    end
  end

end
