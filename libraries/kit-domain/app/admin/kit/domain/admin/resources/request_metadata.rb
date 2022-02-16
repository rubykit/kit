require 'browser'

module Kit::Domain::Admin::Resources::RequestMetadata

  def self.register_resource(modeL: nil, name: nil, namespace: nil, menu_opts: nil)
    model     ||=  Kit::Domain::Models::Write::RequestMetadata
    name      ||= 'RequestMetadata'
    namespace ||= :kit_domain
    menu_opts = {
      label:  name,
      parent: 'Logs',
    }.merge(menu_opts || {})

    ActiveAdmin.register model, as: name, namespace: namespace  do
      menu menu_opts

      actions :all, except: [:new, :edit, :destroy]

      self.instance_eval(&Kit::Domain::Admin::Resources::RequestMetadata.setup_index)
      self.instance_eval(&Kit::Domain::Admin::Resources::RequestMetadata.setup_show)
    end

    [:ok]
  end

  def self.setup_index
    proc do
      index do
        Kit::Admin::Services::Renderers::Index.render(ctx: self,
          attrs: Kit::Domain::Admin::Attributes::RequestMetadata.index,
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
              attrs: Kit::Domain::Admin::Attributes::RequestMetadata.limited,
            )
          end
        end

        columns do
          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              attrs: Kit::Domain::Admin::Attributes::RequestMetadata.ip,
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              attrs: Kit::Domain::Admin::Attributes::RequestMetadata.user_agent,
            )
          end

          column do
            Kit::Admin::Services::Renderers::Panel.render(ctx: self, resource: resource,
              attrs: Kit::Domain::Admin::Attributes::RequestMetadata.utm,
            )
          end
        end
      end
    end
  end

end
