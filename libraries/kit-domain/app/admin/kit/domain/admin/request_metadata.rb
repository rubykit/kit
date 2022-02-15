require 'browser'

module Kit::Domain::Admin::RequestMetadata

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

      controller do
        def scoped_collection
          super.preload(:user)
        end
      end

      index do
        Kit::Domain::Admin::Tables::RequestMetadata.new(self).index
      end

      show do
        columns do
          column do
            Kit::Domain::Admin::Tables::RequestMetadata.new(self).panel resource, attrs_list: :limited
          end
        end

        columns do
          column do
            Kit::Domain::Admin::Tables::RequestMetadata.new(self).panel resource, attrs_list: :ip
          end

          column do
            Kit::Domain::Admin::Tables::RequestMetadata.new(self).panel resource, attrs_list: :user_agent
          end

          column do
            Kit::Domain::Admin::Tables::RequestMetadata.new(self).panel resource, attrs_list: :utm
          end
        end
      end

    end

    [:ok]
  end

end
