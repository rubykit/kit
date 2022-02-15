module Kit::Domain::Admin::Event

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

      index do
        Kit::Domain::Admin::Tables::Event.new(self).index
      end

      show do
        columns do
          column do
            Kit::Domain::Admin::Tables::Event.new(self).panel resource
          end
        end
      end

    end

    [:ok]
  end

end
